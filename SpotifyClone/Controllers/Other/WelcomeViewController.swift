//
//  WelcomeViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit
import SwiftUI

final class WelcomeViewController: UIViewController {
    
    private let signInButton: UIButton = {
       let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Sign in to Spotify", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 4
        return button
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGreen
        view.addSubview(signInButton)
        signInButton.addTarget(self, action: #selector(didSignIn), for: .touchUpInside)
        
        addConstraints()
    }
    
    private func addConstraints() {
        let signInButtonConstraints = [
            signInButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signInButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            signInButton.heightAnchor.constraint(equalToConstant: 50),
            signInButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ]
        
        NSLayoutConstraint.activate(signInButtonConstraints)

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    @objc private func didSignIn() {
         let vc = AuthViewController()
        vc.completion = {[weak self] status in
            guard let self else { return }
            DispatchQueue.main.async {
                self.handleSignIn(success: status)
            }
        }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func handleSignIn(success: Bool) {
        guard success else {
            let alert = UIAlertController(title: "Something went wrong", message: "Failed to sign in.!", preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Dismiss", style: .cancel)
            alert.addAction(alertAction)
            present(alert, animated: true)
            return
        }
        let mainAppVC = TabViewController()
        mainAppVC.modalPresentationStyle = .fullScreen
        present(mainAppVC, animated: true)
    }
}

struct WelcomeViewControllerRepresentable: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }

    func makeUIViewController(context: Context) -> some UIViewController {
        WelcomeViewController()
    }
}

struct WelcomeViewController_Preview: PreviewProvider {
    static var previews: some View {
        WelcomeViewControllerRepresentable()
            .ignoresSafeArea()
    }
}
