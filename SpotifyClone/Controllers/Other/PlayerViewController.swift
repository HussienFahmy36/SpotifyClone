//
//  PlayerViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class PlayerViewController: UIViewController {

    private let imageView: UIImageView = {
        let imageView  = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.backgroundColor = .systemBlue
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private let controlsView: PlayerControlsView = {
        let controlsView = PlayerControlsView()
        controlsView.translatesAutoresizingMaskIntoConstraints = false
        return controlsView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(imageView)
        view.addSubview(controlsView)
        addConstraints()
        configureBarButtons()
        
        controlsView.delegate = self
    }
    
    private func configureBarButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(didTapAction))

    }
    private func addConstraints() {
        let imageViewConstraints = [
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ]
        
        let controlsViewConstraints = [
            controlsView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            controlsView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            controlsView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10),
            controlsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ]
        
        NSLayoutConstraint.activate(imageViewConstraints)
        NSLayoutConstraint.activate(controlsViewConstraints)
    }
    
    @objc private func didTapAction() {
    }
    
    @objc private func didTapClose() {
        dismiss(animated: true)
    }
}

extension PlayerViewController: PlayerControlsViewDelegate {
    func playerControlsViewDidTapPlayPause(_ playerControlsView: PlayerControlsView) {
        print("Pause/Play clicked")
    }
    
    func playerControlsViewDidTapForward(_ playerControlsView: PlayerControlsView) {
        print("Forward clicked")
    }
    
    func playerControlsViewDidTapBackward(_ playerControlsView: PlayerControlsView) {
        print("Backward clicked")
    }    
}
