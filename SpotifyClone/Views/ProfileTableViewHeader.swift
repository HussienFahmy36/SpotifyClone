//
//  ProfileTableViewHeader.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 17/10/2023.
//

import UIKit
import SDWebImage

class ProfileTableViewHeader: UIView {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .systemBackground
        addSubview(profileImageView)
        addConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addConstraints() {
        let profileImageViewConstraints = [
            profileImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            profileImageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ]
        
        NSLayoutConstraint.activate(profileImageViewConstraints)
    }
    
    public func setProfileImage(url: URL) {
        profileImageView.sd_setImage(with: url)
    }

}
