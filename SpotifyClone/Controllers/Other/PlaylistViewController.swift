//
//  PlaylistViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit

class PlaylistViewController: UIViewController {

    private let audioTracksDisplayStrategy = TracksPlaylistDisplayDefaultStrategy()
    private var audioTracksDataSource: PlaylistTracksDataSource?
    private var audioTracksAlbumsDataSource: AlbumsTracksDataSource?
    
    private let tracksCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            return createLayout()
        }))
        return collectionView
    }()
    
    init(playlist: Playlist) {
        audioTracksDataSource = PlaylistTracksDataSource(model: playlist)
        super.init(nibName: nil, bundle: nil)
    }
    
    init(album: Album) {
        audioTracksAlbumsDataSource = AlbumsTracksDataSource(model: album)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = audioTracksDataSource?.title ?? ""
        view.backgroundColor = .systemBackground
        view.addSubview(tracksCollectionView)
        
        audioTracksDisplayStrategy.registerCells(in: tracksCollectionView)
        
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        fetchData()
    }
    
    private func fetchData() {
        showLoadingIndicator()
        audioTracksDataSource?.fetchTracks {[unowned self] result in
            switch result {
            case .success():
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    self.tracksCollectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
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
        if let track = audioTracksDataSource?.tracks[index] {
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        audioTracksDataSource?.viewModels.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let viewModel = audioTracksDataSource?.viewModels[indexPath.row] {
            return audioTracksDisplayStrategy.cellToDisplay(at: indexPath, in: collectionView, viewModel: viewModel)
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionViewCell()
        }
        if let playlist = audioTracksDataSource?.model {
            let viewModel = PlaylistHeaderCollectionViewModel(
                name: playlist.name,
                description: playlist.description,
                owner: playlist.owner.display_name,
                poster_URL: playlist.images.isEmpty ? nil : URL(string: playlist.images[0].url)
            )
            guard let cell = audioTracksDisplayStrategy.headerViewToDisplay(at: indexPath, in: collectionView, viewModel: viewModel) as? PlaylistHeaderCollectionReusableView else {
                return UICollectionViewCell()
            }
            cell.delegate = self
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
}

extension PlaylistViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        if let tracks = audioTracksDataSource?.tracks {
            PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
        }
    }
}
