//
//  FeaturedCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 22/10/2023.
//

import UIKit

class FeaturedCollectionViewCell: UICollectionViewCell {
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
        
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.addSubview(playlistCoverImageView)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playlistNameLabel.sizeToFit()
        creatorNameLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistCoverImageView.image = nil
        playlistNameLabel.text = ""
        creatorNameLabel.text = ""
    }
    
    private func addConstraints() {
        let playlistCoverImageViewConstraints = [
            playlistCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            playlistCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            playlistCoverImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            playlistCoverImageView.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: 0.8)
        ]
        
        let playlistNameLabelConstraints = [
            playlistNameLabel.topAnchor.constraint(equalTo: playlistCoverImageView.bottomAnchor, constant: 3),
            playlistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            playlistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
        ]
        
        let creatorNameLabelConstraints = [
            creatorNameLabel.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor, constant: 3),
            creatorNameLabel.leadingAnchor.constraint(equalTo: playlistNameLabel.leadingAnchor),
            creatorNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            creatorNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ]
        
        NSLayoutConstraint.activate(playlistCoverImageViewConstraints)
        NSLayoutConstraint.activate(playlistNameLabelConstraints)
        NSLayoutConstraint.activate(creatorNameLabelConstraints)
    }
    
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
        playlistCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
