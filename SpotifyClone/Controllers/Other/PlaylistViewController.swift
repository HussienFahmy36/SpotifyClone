//
//  PlaylistViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let playlist: Playlist
    private var tracks = [AudioTrack]()
    private var playlistDetailsResponse: PlaylistDetailsResponse?
    private var viewModels: [RecommendedTrackCellViewModel] = []
    
    private let tracksCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            return createLayout()
        }))
        return collectionView
    }()
    
    init(playlist: Playlist) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = playlist.name
        view.backgroundColor = .systemBackground
        view.addSubview(tracksCollectionView)
        tracksCollectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.identifier)
        tracksCollectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        fetchData()
    }
    
    private func fetchData() {
        showLoadingIndicator()
        APICaller.shared.getPlaylistDetails(for: playlist) {[unowned self] result in
            switch result {
            case .success(let model):
                self.tracks = model.tracks.items.map { $0.track }
                self.playlistDetailsResponse = model
                self.configureViewModels()
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    self.tracksCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureViewModels() {
        guard let playlistDetailsResponse else {
            return
        }
        viewModels = playlistDetailsResponse.tracks.items.map { RecommendedTrackCellViewModel(name: $0.track.name, artistName: $0.track.artists[0].name, artworkURL: URL(string: $0.track.album?.images[0].url ?? ""))}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tracksCollectionView.frame = view.bounds
    }
    
    private static func createLayout() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
        
        let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), repeatingSubitem: item,
                                                             count: 1)
        let section = NSCollectionLayoutSection(group: horizontalGroup)
        section.boundarySupplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
        ]
        return section
    }
}

extension PlaylistViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let index = indexPath.row
        let track = tracks[index]
        PlaybackPresenter.shared.startPlayback(from: self, track: track)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.identifier, for: indexPath) as? RecommendedCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionViewCell()
        }
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView else {
            return UICollectionViewCell()
        }
        cell.delegate = self
        cell.configure(with: PlaylistHeaderCollectionViewModel(name: playlist.name, description: playlist.description, owner: playlist.owner.display_name, poster_URL:
                                                                playlist.images.isEmpty ?
                                                                nil :
                                                                URL(string: playlist.images[0].url)
                                                                ))
        return cell
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
