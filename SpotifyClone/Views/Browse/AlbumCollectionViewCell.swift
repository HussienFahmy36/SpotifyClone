//
//  AlbumCollectionViewCell.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 29/10/2023.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {
    
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
        albumNameLabel.text = ""
        artistNameLabel.text = ""
    }
    
    private func addConstraints() {
        let albumNameLabelConstraints = [
            albumNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 3),
            albumNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            albumNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 3),
        ]
                
        let artistNameLabelConstraints = [
            artistNameLabel.topAnchor.constraint(equalTo: albumNameLabel.bottomAnchor, constant: 3),
            artistNameLabel.leadingAnchor.constraint(equalTo: albumNameLabel.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -3),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -3)
        ]
        
        NSLayoutConstraint.activate(albumNameLabelConstraints)
        NSLayoutConstraint.activate(artistNameLabelConstraints)
    }
    
    func configure(with viewModel: AlbumCellViewModel) {
        albumNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
    
}
