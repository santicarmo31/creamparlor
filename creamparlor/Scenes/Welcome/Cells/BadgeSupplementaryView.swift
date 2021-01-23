//
//  BadgeSupplementaryView.swift
//  creamparlor
//
//  Created by Santiago Carmona on 23/01/21.
//

import UIKit

class BadgeSupplementaryView: UICollectionReusableView {

    static let reuseIdentifier = "badge-reuse-identifier"
    let label = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    override var frame: CGRect {
        didSet {
            configureBorder()
        }
    }
    override var bounds: CGRect {
        didSet {
            configureBorder()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
}

extension BadgeSupplementaryView {
    func configure() {
        label.translatesAutoresizingMaskIntoConstraints = false
        label.adjustsFontForContentSizeCategory = true
        addSubview(label)
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: centerXAnchor),
            label.centerYAnchor.constraint(equalTo: centerYAnchor)
            ])
        label.font = UIFont.preferredFont(forTextStyle: .footnote)
        label.textAlignment = .center
        label.textColor = .white
        backgroundColor = .primaryColor
        configureBorder()
    }
    func configureBorder() {
        let radius = bounds.width / 2.0
        layer.cornerRadius = radius
        layer.borderColor = UIColor.primaryColor.cgColor
        layer.borderWidth = 1.0
    }
}
