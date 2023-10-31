//
//  BrowseTitleHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 29/10/2023.
//

import UIKit

class BrowseTitleHeaderCollectionReusableView: UICollectionViewCell {
    
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(label)
        addConstraints()
    }
    
    private func addConstraints() {
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor),
            label.topAnchor.constraint(equalTo: contentView.topAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func configure(with title: String) {
        label.text = title
    }
}
