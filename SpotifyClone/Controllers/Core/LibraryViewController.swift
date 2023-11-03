//
//  LibraryViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class LibraryViewController: UIViewController {

    private let playlistsVC = LibraryPlaylistsViewController()
    private let albumsVC = LibraryAlbumsViewController()
    private let libraryToggleView: LibraryToggleView = {
        let toggleView = LibraryToggleView()
        toggleView.translatesAutoresizingMaskIntoConstraints = false
        return toggleView
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Library"
        view.backgroundColor = .systemBackground
        scrollView.contentSize = CGSize(width: view.frame.width * 2, height: view.frame.height)
        view.addSubview(scrollView)
        view.addSubview(libraryToggleView)
        libraryToggleView.delegate = self
        scrollView.delegate = self
        addConstraints()
        addChildren()
        configureNavigationBarItems()
    }
    
    private func configureNavigationBarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .done, target: self, action: #selector(addToLibrary))
    }
    
    @objc private func addToLibrary() {
        if libraryToggleView.getState() == .album {
            
        } else {
            playlistsVC.showCreatePlaylistAlert()
        }
    }
    
    private func addConstraints() {
        let libraryToggleViewConstraints = [
            libraryToggleView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            libraryToggleView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 3),
            libraryToggleView.heightAnchor.constraint(equalToConstant: 33),
            libraryToggleView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ]

        let scrollViewConstraints = [
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: libraryToggleView.bottomAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -55)
        ]
        NSLayoutConstraint.activate(libraryToggleViewConstraints)
        NSLayoutConstraint.activate(scrollViewConstraints)
    }
    
    private func addChildren() {
        addChild(playlistsVC)
        scrollView.addSubview(playlistsVC.view)
        playlistsVC.view.frame = CGRect(x: 0, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        playlistsVC.didMove(toParent: self)
        
        addChild(albumsVC)
        scrollView.addSubview(albumsVC.view)
        albumsVC.view.frame = CGRect(x: view.frame.width, y: 0, width: scrollView.frame.width, height: scrollView.frame.height)
        albumsVC.didMove(toParent: self)

    }
}

extension LibraryViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > (view.frame.width - 100) {
            libraryToggleView.set(.album)
        } else {
            libraryToggleView.set(.playlist)
        }
    }
}

extension LibraryViewController: LibraryToggleViewDelegate {
    
    func libraryToggleViewDidTapAlbums(_ toggleView: LibraryToggleView) {
        scrollView.scrollRectToVisible(
            CGRect(
                x: view.frame.width,
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height),
            animated: true)
    }
    
    func libraryToggleViewDidTapPlaylists(_ toggleView: LibraryToggleView) {
        scrollView.scrollRectToVisible(
            CGRect(
                x: 0,
                y: 0,
                width: scrollView.frame.width,
                height: scrollView.frame.height),
            animated: true)
    }
}
