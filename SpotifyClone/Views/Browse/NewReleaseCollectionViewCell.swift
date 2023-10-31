//
//  NewReleaseCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 22/10/2023.
//

import UIKit
import SDWebImage

class NewReleaseCollectionViewCell: UICollectionViewCell {
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
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        return label
    }()

    private let numberOfTracksLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .light)
        return label
    }()

    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .regular)
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = .secondarySystemBackground
        
        contentView.addSubview(albumCoverImageView)
        contentView.addSubview(albumNameLabel)
        contentView.addSubview(numberOfTracksLabel)
        contentView.addSubview(artistNameLabel)
        
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        albumNameLabel.text = nil
        artistNameLabel.text = nil
        numberOfTracksLabel.text = nil
        albumCoverImageView.image = nil
    }
    
    private func addConstraints() {
        let albumCoverImageViewConstraints = [
            albumCoverImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            albumCoverImageView.topAnchor.constraint(greaterThanOrEqualTo: contentView.topAnchor),
            albumCoverImageView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor),
            albumCoverImageView.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.4)
        ]
        
        let albumNameLabelConstraints = [
            albumNameLabel.leadingAnchor.constraint(equalTo: albumCoverImageView.trailingAnchor, constant: 3),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            albumNameLabel.topAnchor.constraint(equalTo: albumCoverImageView.topAnchor)
        ]
        
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 3),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
        ]
        
        let numberOfTracksLabelConstraints = [
            numberOfTracksLabel.leadingAnchor.constraint(equalTo: artistNameLabel.leadingAnchor),
            numberOfTracksLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            numberOfTracksLabel.topAnchor.constraint(equalTo: artistNameLabel.bottomAnchor, constant: 3),
            numberOfTracksLabel.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -3)
        ]
        NSLayoutConstraint.activate(albumCoverImageViewConstraints)
        NSLayoutConstraint.activate(albumNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
        NSLayoutConstraint.activate(numberOfTracksLabelConstraints)
    }
    
    func configure(with viewModel: NewReleasesCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
        numberOfTracksLabel.text = "Tracks: \(viewModel.numberOfTracks)"
        albumCoverImageView.sd_setImage(with: viewModel.artworkURL)
    }
}
