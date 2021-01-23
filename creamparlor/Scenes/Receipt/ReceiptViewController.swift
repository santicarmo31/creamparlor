//
//  ReceiptViewController.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import UIKit

protocol ReceiptViewControllerDelegate: class {
    func didDismissViewController(_ viewController: ReceiptViewController)
}

class ReceiptViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var startNewOrderButton: UIButton!

    weak var delegate: ReceiptViewControllerDelegate?
    
    private let receipt: ReceiptViewModel

    enum Section: Int, CaseIterable {
        case items, total
    }

    init?(coder: NSCoder, orderItems: [ProductViewModel]) {
        receipt = ReceiptViewModel(items: orderItems)
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("ReceiptViewController must be created with items")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        startNewOrderButton.layer.borderColor = UIColor.white.cgColor
        startNewOrderButton.layer.borderWidth = 4
        setupTableView()
    }

    private func setupTableView() {
        let nib = UINib(nibName: ReceiptTableViewCell.reuseIdentifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReceiptTableViewCell.reuseIdentifier)
        tableView.dataSource = self
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44
    }

    @IBAction private func startNewOrder(_ sender: Any) {
        delegate?.didDismissViewController(self)
        navigationController?.popViewController(animated: true)
    }
}

extension ReceiptViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return Section.allCases.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .items:
            return receipt.items.count
        case .total:
            return 1
        case .none:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ReceiptTableViewCell.reuseIdentifier) as? ReceiptTableViewCell else {
            assertionFailure("Cell must exist")
            return .init()
        }
        switch Section(rawValue: indexPath.section) {
        case .items:
            let item = receipt.items[indexPath.row]
            cell.setup(productName: receipt.nameWithPrice(for: item), productPrice: receipt.price(for: item))
        case .total:
            cell.setup(productName: "TOTAL", productPrice: receipt.totalPrice)
        case .none:
            assertionFailure("Section #\(indexPath.section) doesn't exists, please add it to enum cases")
            return .init()
        }
        return cell
    }
}
