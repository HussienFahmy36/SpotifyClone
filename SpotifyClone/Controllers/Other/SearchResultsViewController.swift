//
//  SearchResultsViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 29/10/2023.
//

import UIKit
struct SearchSection {
    let title: String
    let items: [SearchResult]
}

protocol SearchResultsViewControllerDelegate: AnyObject {
    func didTapResult(_ searchResult: SearchResult)
}
class SearchResultsViewController: UIViewController {

    weak var delegate: SearchResultsViewControllerDelegate?
    private var sections: [SearchSection] = []
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.register(SearchResultDefaultTableViewCell.self, forCellReuseIdentifier: SearchResultDefaultTableViewCell.identifier)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .clear
        view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    

    public func update(with results: [SearchResult]) {
        let artists = results.filter {
            switch $0 {
            case .artist: return true
            default: return false
            }
        }
        let albums = results.filter {
            switch $0 {
            case .album: return true
            default: return false
            }
        }
        let playlists = results.filter {
            switch $0 {
            case .playlist: return true
            default: return false
            }
        }
        let audioTracks = results.filter {
            switch $0 {
            case .track: return true
            default: return false
            }
        }
        sections = [
            SearchSection(title: "Songs", items: audioTracks),
            SearchSection(title: "Artists", items: artists),
            SearchSection(title: "Playlists", items: playlists),
            SearchSection(title: "Albums", items: albums)
        ]
        DispatchQueue.main.async {[unowned self] in
            self.tableView.reloadData()
            self.tableView.isHidden = results.isEmpty
        }
    }
}

extension SearchResultsViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        sections[section].title
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var itemTitle = ""
        let searchItemToDisplay = sections[indexPath.section].items[indexPath.row]
        switch searchItemToDisplay {
        case .album(let album):
            guard let albumCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else { return UITableViewCell() }
            let posterURL = URL(string: album.images[0].url)
            albumCell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                title: album.name,
                subtitle: album.artists[0].name,
                imageURL: posterURL)
            )
            return albumCell
        case .artist(let artist):
            guard let artistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultDefaultTableViewCell.identifier, for: indexPath) as? SearchResultDefaultTableViewCell else { return UITableViewCell() }
            let imageURLString = (artist.images?.isEmpty ?? true) ? "" : artist.images?[0].url
            let posterURL = URL(string: imageURLString ?? "")
            artistCell.configure(with: SearchResultDefaultTableViewCellViewModel(title: artist.name, imageURL: posterURL))
            return artistCell
        case .playlist(let playlist):
            guard let playlistCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else { return UITableViewCell() }
            let posterURL = URL(string: playlist.images[0].url)
            playlistCell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                title: playlist.name,
                subtitle: playlist.description,
                imageURL: posterURL)
            )
            return playlistCell
        case .track(let track):
            guard let trackCell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else { return UITableViewCell() }
            let posterURL = URL(string: track.album?.images[0].url ?? "")
            trackCell.configure(with: SearchResultSubtitleTableViewCellViewModel(
                title: track.name,
                subtitle: track.artists[0].name,
                imageURL: posterURL)
            )
            return trackCell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 3 {
            return 70
        } else {
            return 60
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let result = sections[indexPath.section].items[indexPath.row]
        delegate?.didTapResult(result)
    }
}
