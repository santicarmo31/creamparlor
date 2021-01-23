//
//  ReceiptTableViewCell.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import UIKit

class ReceiptTableViewCell: UITableViewCell, Reusable {

    @IBOutlet weak private var productNameLabel: UILabel!
    @IBOutlet weak private var productPriceLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setup(productName: String, productPrice: String) {
        productNameLabel.text = productName
        productPriceLabel.text = productPrice
    }
    
}
