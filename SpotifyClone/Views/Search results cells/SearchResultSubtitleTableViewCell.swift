//
//  SearchResultDefaultTableViewCell.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 31/10/2023.
//

import UIKit
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    private let label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 1
        return label
    }()
    

    private let iconImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        accessoryType = .disclosureIndicator
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    private func addConstraints() {
        let imageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            iconImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9),
            iconImageView.widthAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.9)
        ]
        
        let labelConstraints = [
            label.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: 10),
            label.topAnchor.constraint(equalTo: contentView.topAnchor),
            label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ]
        
        let subtitleLabelConstraints = [
            subtitleLabel.leadingAnchor.constraint(equalTo: label.leadingAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 3),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(labelConstraints)
        NSLayoutConstraint.activate(subtitleLabelConstraints)
    }
    
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
        iconImageView.sd_setImage(with: viewModel.imageURL,
                                  placeholderImage: UIImage(systemName: "photo"))
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
}

