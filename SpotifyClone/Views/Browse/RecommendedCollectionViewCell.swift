//
//  RecommendedCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 22/10/2023.
//

import UIKit

class RecommendedCollectionViewCell: UICollectionViewCell {
    private let albumCoverImageView: UIImageView = {
        let imageView = UIImageView(frame: .zero)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let albumNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14, weight: .thin)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(artistNameLabel)

        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        albumNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumCoverImageView.image = nil
        albumNameLabel.text = ""
        artistNameLabel.text = ""
    }
    
    private func addConstraints() {
        let albumCoverImageViewConstraints = [
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            albumCoverImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
            albumCoverImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3),
            albumCoverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.3)
        ]
        
        let albumNameLabelConstraints = [
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 1),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            albumNameLabel.topAnchor.constraint(equalTo: albumCoverImageView.topAnchor, constant: -3),
        ]
        
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 3),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ]
        
        NSLayoutConstraint.activate(albumCoverImageViewConstraints)
        NSLayoutConstraint.activate(albumNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
    }
    
    func configure(with viewModel: RecommendedTrackCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }    
}
