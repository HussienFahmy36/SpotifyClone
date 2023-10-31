//
//  PlaylistHeaderCollectionReusableView.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 29/10/2023.
//

import UIKit
import SDWebImage

protocol PlaylistHeaderCollectionReusableViewDelegate: AnyObject {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView)
}

class PlaylistHeaderCollectionReusableView: UICollectionViewCell {
    private let playAllButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "play.fill"), for: .normal)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill

        button.tintColor = .systemGreen
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        return label
    }()
    
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 19, weight: .semibold)
        label.textColor = .secondaryLabel
        return label
    }()

    
    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 18, weight: .thin)
        label.textColor = .black
        return label
    }()

    private let playListCoverImage: UIImageView = {
        let imageView = UIImageView(image: UIImage(systemName: "photo"))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        imageView.layer.cornerRadius = 4
        imageView.layer.shadowRadius = 4
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    public weak var delegate: PlaylistHeaderCollectionReusableViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playListCoverImage)
        contentView.addSubview(nameLabel)
        contentView.addSubview(descriptionLabel)
        contentView.addSubview(ownerNameLabel)
        contentView.addSubview(playAllButton)
        playAllButton.addTarget(self, action: #selector(playAll), for: .touchUpInside)
        addConstraints()
    }
    
    func configure(with viewModel: PlaylistHeaderCollectionViewModel) {
        nameLabel.text = viewModel.name
        descriptionLabel.text = viewModel.description
        ownerNameLabel.text = viewModel.owner
        playListCoverImage.sd_setImage(with: viewModel.poster_URL)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

        
    private func addConstraints() {
        let playListCoverImageConstraints = [
            playListCoverImage.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            playListCoverImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            playListCoverImage.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5),
            playListCoverImage.heightAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.5)
        ]
        
        let nameLabelConstraints = [
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: playListCoverImage.bottomAnchor, constant: 10)
        ]
        
        let descriptionLabelConstraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 10)
        ]
        
        let ownerLabelConstraints = [
            ownerNameLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            ownerNameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 10),
            ownerNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ]
        
        let playAllButtonConstraints = [
            playAllButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            playAllButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            playAllButton.widthAnchor.constraint(equalToConstant: 30),
            playAllButton.heightAnchor.constraint(equalToConstant: 30)
        ]
        NSLayoutConstraint.activate(playListCoverImageConstraints)
        NSLayoutConstraint.activate(nameLabelConstraints)
        NSLayoutConstraint.activate(descriptionLabelConstraints)
        NSLayoutConstraint.activate(ownerLabelConstraints)
        NSLayoutConstraint.activate(playAllButtonConstraints)
    }
    
    @objc private func playAll() {
        delegate?.playlistHeaderCollectionReusableViewDidTapPlayAll(self)
    }
}
