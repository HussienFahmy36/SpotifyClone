//
//  AlbumViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 28/10/2023.
//

import UIKit

class AlbumViewController: UIViewController {

    private var albumDetailsResponse: AlbumDetailsResponse?
    
    private let tracksCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            return createLayout()
        }))
        return collectionView
    }()
    
    private var viewModels: [AlbumCellViewModel] = []
    private let album: Album
    private var tracks: [AudioTrack] = []
    
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = album.name
        view.backgroundColor = .systemBackground
        
        view.addSubview(tracksCollectionView)
        tracksCollectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        tracksCollectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
        tracksCollectionView.dataSource = self
        tracksCollectionView.delegate = self
        
        fetchData()

    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tracksCollectionView.frame = view.bounds
    }
    
    private func fetchData() {
        showLoadingIndicator()
        APICaller.shared.getAlbumDetails(for: album) {[unowned self] result in
            switch result {
            case .success(let model):
                self.tracks = model.tracks.items
                self.albumDetailsResponse = model
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
        guard let albumDetailsResponse else {
            return
        }
        viewModels = albumDetailsResponse.tracks.items.map { AlbumCellViewModel(name: $0.name, artistName: $0.artists[0].name)}
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

extension AlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
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
        cell.configure(with: PlaylistHeaderCollectionViewModel(name: album.name, description: "Release date: \(album.release_date.toFormattedDate())", owner: album.artists[0].name, poster_URL: URL(string: album.images[0].url)))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        PlaybackPresenter.shared.startPlayback(from: self, track: tracks[indexPath.row])
    }
}

extension AlbumViewController: PlaylistHeaderCollectionReusableViewDelegate {
    func playlistHeaderCollectionReusableViewDidTapPlayAll(_ header: PlaylistHeaderCollectionReusableView) {
        PlaybackPresenter.shared.startPlayback(from: self, tracks: tracks)
    }
}
