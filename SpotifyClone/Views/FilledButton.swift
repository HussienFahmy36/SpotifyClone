//
//  FilledButton.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class FilledButton: UIButton {
    init(
        frame: CGRect = .zero,
        title: String,
        titleColor: UIColor,
        backgroundColor: UIColor
    ) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        setTitle(title, for: .normal)
        setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        layer.cornerRadius = 16
        layer.masksToBounds = true

    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
