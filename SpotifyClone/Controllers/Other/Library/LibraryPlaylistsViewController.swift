//
//  LibraryPlaylistsViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 02/11/2023.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {

    private var playlists: [Playlist] = []
    private var viewModels: [SearchResultSubtitleTableViewCellViewModel] = []
    private let actionView: ActionView = {
        let actionView = ActionView()
        actionView.isHidden = false
        actionView.translatesAutoresizingMaskIntoConstraints = false
        return actionView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.isHidden = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(
            SearchResultSubtitleTableViewCell.self,
            forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier
        )
        return tableView
    }()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        setupNoPlaylistsView()
        addConstraints()
        fetchData()
    }
    
    private func setupNoPlaylistsView() {
        actionView.delegate = self
        view.addSubview(actionView)
        actionView.config(
            with: ActionViewModel(
                actionTitle: "You don't have any playlists yet.",
                actionButtonTitle: "Create")
        )
    }

    private func fetchData() {
        DispatchQueue.main.async { [unowned self] in
            self.parent?.showLoadingIndicator()
        }
        APICaller.shared.getCurrentUserPlaylists {[unowned self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    self.playlists = model
                    self.configureViewModels()
                    self.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self.parent?.hideLoadingIndicator()
            }
        }
    }
    
    func configureViewModels() {
        guard !playlists.isEmpty else {
            return
        }
        viewModels = playlists.map { SearchResultSubtitleTableViewCellViewModel(title: $0.name, subtitle: $0.owner.display_name, imageURL: nil)}
    }
    private func addConstraints() {
        let actionViewConstraints = [
            actionView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            actionView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            actionView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            actionView.heightAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5)
        ]
        
        let tableViewConstraints = [
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ]
        NSLayoutConstraint.activate(actionViewConstraints)
        NSLayoutConstraint.activate(tableViewConstraints)
    }
    
    private func updateUI() {
        actionView.isHidden = !playlists.isEmpty
        tableView.isHidden = playlists.isEmpty
        tableView.reloadData()
    }
}

extension LibraryPlaylistsViewController: ActionViewDelegate {
    func actionViewDidTapActionButton(_ actionView: ActionView) {
        print("Create button clicked!.")
        showCreatePlaylistAlert()
    }
    
    func showCreatePlaylistAlert(){
        let alert = UIAlertController(title: "New Playlist", message: "Enter playlists name.", preferredStyle: .alert)
        
        alert.addTextField { textfield in
            textfield.placeholder = "Playlist name..."
        }
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default) { _ in
            guard let field = alert.textFields?[0],
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty
            else {
                return
            }
            
            APICaller.shared.createPlaylists(with: text) {[unowned self] success in
                if success {
                    self.fetchData()
                } else {
                    print("Failed to create playlist")
                }
            }
        })
        present(alert, animated: true)
    }
}


extension LibraryPlaylistsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        playlists.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        70
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell, !viewModels.isEmpty else {
            return UITableViewCell()
        }
        cell.configure(with: viewModels[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let playlistVC = PlaylistViewController(playlist: playlists[indexPath.row])
        playlistVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(playlistVC, animated: true)

    }
}
