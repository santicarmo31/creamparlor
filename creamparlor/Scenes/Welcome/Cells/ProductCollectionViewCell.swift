//
//  IceCreamCollectionViewCell.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell, Reusable {

    // MARK: - IBOutlets
    @IBOutlet weak private var productImageContainerView: UIView!
    @IBOutlet weak private var productImageView: UIImageView!
    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var productPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        productImageContainerView.layer.cornerRadius = productImageContainerView.bounds.width / 2
        setDefaultBorder()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        setDefaultBorder()
    }

    func setup(imageNamed: String, name: String, price: String, hexBackgroundColor: String) {
        productImageView.image = UIImage(named: imageNamed)
        productNameLabel.text = name
        productPriceLabel.text = price
        productImageContainerView.backgroundColor = UIColor(hex: hexBackgroundColor)
    }

    private func setDefaultBorder() {
        contentView.layer.borderColor = UIColor.lightGray.cgColor
        contentView.layer.borderWidth = 1
    }

}
