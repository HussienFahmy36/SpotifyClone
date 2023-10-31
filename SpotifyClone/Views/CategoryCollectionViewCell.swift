//
//  GenreCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 29/10/2023.
//

import UIKit
import SDWebImage

class CategoryCollectionViewCell: UICollectionViewCell {
    
    private let imageView: UIImageView = {
       let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "music.quarternote.3", withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .regular))
        return imageView
    }()
    
    private let label: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()
    
    private let cellColors: [UIColor] = [
        .systemRed,
        .systemBlue,
        .systemCyan,
        .systemGray,
        .systemMint,
        .systemPink,
        .systemTeal,
        .systemGreen,
        .systemIndigo,
        .systemYellow,
        .systemPurple
    
    ]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(imageView)
        contentView.addSubview(label)
        contentView.layer.cornerRadius = 4
        contentView.layer.masksToBounds = true
        addConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = nil
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addConstraints() {
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            label.widthAnchor.constraint(equalTo: contentView.widthAnchor),
            label.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ]
        
        let imageViewConstraints = [
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            imageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            imageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.5)
        ]
        
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(imageViewConstraints)
    }
    
    func config(with viewModel: CategoryCollectionViewCellViewModel) {
        label.text = viewModel.title
        contentView.backgroundColor = cellColors.randomElement()
        imageView.sd_setImage(with: viewModel.poster_ImageURL)
    }
}
