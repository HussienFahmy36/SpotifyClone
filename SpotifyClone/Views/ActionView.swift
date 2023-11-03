//
//  NoPlaylistsActionView.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 03/11/2023.
//

import UIKit
struct ActionViewModel {
    let actionTitle: String
    let actionButtonTitle: String
}

protocol ActionViewDelegate: AnyObject {
    func actionViewDidTapActionButton(_ actionView: ActionView)
}

class ActionView: UIView {

    private let actionTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.label, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    weak var delegate: ActionViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(actionTitle)
        addSubview(actionButton)
        addConstraints()
        actionButton.addTarget(self, action: #selector(actionButtonDidTapped), for: .touchUpInside)
    }
    
    @objc private func actionButtonDidTapped() {
        delegate?.actionViewDidTapActionButton(self)
    }
    
    private func addConstraints() {
        let actionTitleConstraints = [
            actionTitle.leadingAnchor.constraint(equalTo: leadingAnchor),
            actionTitle.trailingAnchor.constraint(equalTo: trailingAnchor),
            actionTitle.topAnchor.constraint(equalTo: topAnchor)
        ]
        
        let actionButtonConstraints = [
            actionButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionButton.topAnchor.constraint(equalTo: actionTitle.bottomAnchor, constant: 8)
        ]
        
        NSLayoutConstraint.activate(actionTitleConstraints)
        NSLayoutConstraint.activate(actionButtonConstraints)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    public func config(with viewModel: ActionViewModel) {
        actionTitle.text = viewModel.actionTitle
        actionButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        actionButton.setTitle(viewModel.actionButtonTitle, for: .selected)
    }
}
