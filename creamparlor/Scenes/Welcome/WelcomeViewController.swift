//
//  WelcomeViewController.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var orderButton: UIButton!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!

    

    var products: [Product]! {
        didSet {
            setInitialData()
        }
    }

    private typealias DataSource = UICollectionViewDiffableDataSource<Int, ProductViewModel>
    private typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ProductViewModel>
    static let badgeElementKind = "badge-element-kind"
    private var dataSource: DataSource!


    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "WELCOME"
        activityIndicator.hidesWhenStopped = true
        loadProducts()
        setupCollectionView()
    }

    private func loadProducts() {
        let endpoint = Endpoint<[Product]>("https://gl-endpoint.herokuapp.com/products")
        let networkClient: APINetworkClient = NetworkClient()
        activityIndicator.startAnimating()
        networkClient.executeRequest(endpoint) { (result) in
            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                switch result {
                case .success(let products):
                    self.products = products
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
    }

    private func setupCollectionView() {
        let nib = UINib(nibName: ProductCollectionViewCell.reuseIdentifier, bundle: nil)
        collectionView.register(nib, forCellWithReuseIdentifier: ProductCollectionViewCell.reuseIdentifier)
        collectionView.delegate = self
        collectionView.collectionViewLayout = createLayout()
        configureDataSource()
    }


    private func createLayout() -> UICollectionViewLayout {
        let badgeAnchor = NSCollectionLayoutAnchor(edges: [.top, .trailing], fractionalOffset: CGPoint(x: 0.3, y: -0.3))
        let badgeSize = NSCollectionLayoutSize(widthDimension: .absolute(20),
                                              heightDimension: .absolute(20))
        let badge = NSCollectionLayoutSupplementaryItem(
            layoutSize: badgeSize,
            elementKind: WelcomeViewController.badgeElementKind,
            containerAnchor: badgeAnchor
        )

        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize, supplementaryItems: [badge])
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: 2)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20)

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func configureDataSource() {

        let supplementaryRegistration = UICollectionView.SupplementaryRegistration
        <BadgeSupplementaryView>(elementKind: BadgeSupplementaryView.reuseIdentifier) {
            (badgeView, string, indexPath) in
            guard let model = self.dataSource.itemIdentifier(for: indexPath) else { return }
            badgeView.label.text = "\(model.badgeCount)"
            badgeView.isHidden = !model.hasBadgeCount
        }

        dataSource = DataSource(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, model: ProductViewModel) -> UICollectionViewCell? in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.reuseIdentifier, for: indexPath) as? ProductCollectionViewCell else {
                return nil
            }
            if model.hasBadgeCount {
                cell.contentView.layer.borderColor = UIColor.primaryColor.cgColor
                cell.contentView.layer.borderWidth = 5
            }
            cell.setup(imageNamed: model.product.type, name: model.product.completeName, price: model.product.price, hexBackgroundColor: model.product.bg_color)
            return cell
        }

        dataSource.supplementaryViewProvider = {
            return self.collectionView.dequeueConfiguredReusableSupplementary(using: supplementaryRegistration, for: $2)
        }
    }

    private func setInitialData() {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(products.compactMap({ ProductViewModel(product: $0, badgeCount: 0) }))
        dataSource.apply(snapshot, animatingDifferences: false)
        orderButton.setTitle("ORDER 0 ITEM", for: .normal)
    }

    private func orderItems(_ items: [ProductViewModel]) {
        let receiptViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "Receipt") { (coder) -> ReceiptViewController? in
            return ReceiptViewController(coder: coder, orderItems: items)
        }
        receiptViewController.delegate = self
        show(receiptViewController, sender: nil)
    }

    @IBAction private func orderItems(_ sender: UIButton) {
        let itemsToOrder = dataSource.snapshot().itemIdentifiers.filter({ $0.badgeCount > 0 })
        orderItems(itemsToOrder)
    }
}

extension WelcomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else {
            return
        }
        item.badgeCount += 1
        if item.badgeCount > 2 {
            item.badgeCount = 0
        }
        var snapshot = dataSource.snapshot()
        snapshot.reloadItems([item])
        dataSource.apply(snapshot)

        let orders = snapshot.itemIdentifiers.reduce(0, { $0 + $1.badgeCount })
        orderButton.setTitle("ORDER \(orders) ITEMS", for: .normal)
    }
}

extension WelcomeViewController: ReceiptViewControllerDelegate {
    func didDismissViewController(_ viewController: ReceiptViewController) {
        setInitialData()
    }
}
