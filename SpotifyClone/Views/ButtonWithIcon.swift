//
//  WhiteBorderedButton.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class ButtonWithIcon: UIButton {
    private let iconImageView: UIImageView
    private let buttonLabel: UILabel
    
    init(
        frame: CGRect = .zero,
        title: String,
        icon: UIImage?
    ) {
        iconImageView = UIImageView()
        buttonLabel = UILabel()
        super.init(frame: frame)

        addSubview(iconImageView)
        addSubview(buttonLabel)

        self.layer.borderColor = UIColor.white.cgColor
        self.layer.borderWidth = 1
        layer.cornerRadius = 16
        layer.masksToBounds = true
        renderContent(title: title, icon: icon)
    }

    func renderContent(title: String, icon: UIImage?) {
        buttonLabel.numberOfLines = 1
        buttonLabel.textColor = .white
        buttonLabel.font = .systemFont(ofSize: 18, weight: .bold)
        buttonLabel.text = title
        buttonLabel.translatesAutoresizingMaskIntoConstraints = false
        
        iconImageView.image = icon
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        
        addConstraints()
    }
    
    private func addConstraints() {
        let iconImageViewConstraints = [
            iconImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0),
            iconImageView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
            iconImageView.heightAnchor.constraint(equalTo: widthAnchor, multiplier: 0.05),
        ]
        
        let buttonLabelConstraints = [
            buttonLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            buttonLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            buttonLabel.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            buttonLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ]
        
        NSLayoutConstraint.activate(iconImageViewConstraints)
        NSLayoutConstraint.activate(buttonLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        iconImageView = UIImageView()
        buttonLabel = UILabel()
        super.init(coder: coder)
    }

}
