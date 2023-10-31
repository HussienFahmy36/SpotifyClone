//
//  ViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit
import SwiftUI

enum BrowseType {
    case newReleases(viewModels: [NewReleasesCellViewModel])
    case featuredPlaylists(viewModels: [FeaturedPlaylistCellViewModel])
    case recommendedTracks(viewModels: [RecommendedTrackCellViewModel])
    
    var title: String {
        switch self {
        case .newReleases: return "New releases"
        case .featuredPlaylists: return "Featured playlists"
        case .recommendedTracks: return "Recommended Tracks"
        }
    }
}

extension UICollectionViewCell {
    static var identifier: String {
        String(describing: self)
    }

}
class CollectionViewHeader: UICollectionViewCell {
    var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textColor = .label
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        contentView.backgroundColor = .clear
        addConstraints()
    }
  
    private func addConstraints() {
        let textLabelConstraints = [
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)

        ]
        NSLayoutConstraint.activate(textLabelConstraints)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

class CollectionViewFooter: UICollectionViewCell {
    var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .bold)
        label.numberOfLines = 0

        label.textColor = .white
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        contentView.backgroundColor = .red
        addConstraints()
    }
  
    private func addConstraints() {
        let textLabelConstraints = [
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ]
        NSLayoutConstraint.activate(textLabelConstraints)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
class CollectionViewCellItem: UICollectionViewCell {
    var textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(textLabel)
        contentView.backgroundColor = .lightGray
        addConstraints()
    }
  
    private func addConstraints() {
        let textLabelConstraints = [
            textLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            textLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -15),
            textLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            textLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
        ]
        NSLayoutConstraint.activate(textLabelConstraints)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
class HomeViewController: UIViewController {

    private var sections = [BrowseType]()
    private var newAlbums: [Album] = []
    private var playlists: [Playlist] = []
    private var tracks: [AudioTrack] = []
    
    var collectionView: UICollectionView = {
        let layout = UICollectionViewCompositionalLayout { section, _ -> NSCollectionLayoutSection in
            return createSectionLayout(section: section)
        }
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)

        collectionView.register(NewReleaseCollectionViewCell.self, forCellWithReuseIdentifier: NewReleaseCollectionViewCell.identifier)
        
        collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.identifier)

        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.identifier)

        collectionView.register(CollectionViewCellItem.self, forCellWithReuseIdentifier: CollectionViewCellItem.identifier)
       
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: CollectionViewHeader.identifier, withReuseIdentifier: CollectionViewHeader.identifier)
        
        collectionView.register(BrowseTitleHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: BrowseTitleHeaderCollectionReusableView.identifier)

        return collectionView
    }()
    
    private static func createSectionLayout(section: Int) -> NSCollectionLayoutSection {
        let supplementaryItems = [
            NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize:
                        .init(widthDimension:
                                .fractionalWidth(1.0),
                              heightDimension: .absolute(50)),
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top
            )
        ]
        switch section {
        case 0:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 8, trailing: 2)

            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), repeatingSubitem: item, count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)), repeatingSubitem: verticalGroup,
                                                                 count: 1)
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryItems
            return section
        case 1:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 8, trailing: 2)

            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .absolute(250), heightDimension: .absolute(250)), repeatingSubitem: item, count: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .absolute(250), heightDimension: .absolute(500)), repeatingSubitem: verticalGroup,
                                                                 count: 1)
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryItems
            return section
        case 2:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 8, trailing: 2)
            
            let horizontalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(80)), repeatingSubitem: item,
                                                                 count: 1)
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.boundarySupplementaryItems = supplementaryItems
            return section
      
        default:
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 8, trailing: 2)

            let verticalGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(130)), repeatingSubitem: item, count: 3)
            
            let horizontalGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.9), heightDimension: .absolute(390)), repeatingSubitem: verticalGroup,
                                                                 count: 1)
            let section = NSCollectionLayoutSection(group: horizontalGroup)
            section.orthogonalScrollingBehavior = .groupPaging
            section.boundarySupplementaryItems = supplementaryItems
            return section

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Browse"
        view.backgroundColor = .systemBackground
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .done, target: self, action: #selector(didTapSettings))
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        fetchData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
    
    func fetchData() {
        showLoadingIndicator()
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        dispatchGroup.enter()
        dispatchGroup.enter()
        
        var newReleases: NewReleasesResponse?
        var featuredPlaylist: FeaturedPlaylistsResponse?
        var recommendations: RecommendationsResponse?
        
        // New releases
        APICaller.shared.getNewReleases(fromMocks: true) { result in
            dispatchGroup.leave()
            switch result {
            case .success(let model):
                newReleases = model
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
        // Featured playlists
        APICaller.shared.getFeaturedPlaylists(fromMocks: true) { result in
            dispatchGroup.leave()
            switch result {
            case .success(let model):
                featuredPlaylist = model
            case .failure(let error):
                print(error.localizedDescription)

            }
        }
        // Recommended
        APICaller.shared.getRecommendedGenres(fromMocks: true) { result in
            switch result {
            case .success(let model):
                let genres = model.genres
                let maxNumberOfSeeds = 5
                var seeds = Set<String>()

                for _ in 1...5 {
                    if let randomElement = genres.randomElement() {
                        seeds.insert(randomElement)
                    }
                }

                APICaller.shared.getRecommendation(fromMocks: true, genres: seeds) { result in
                    dispatchGroup.leave()
                    switch result {
                    case .success(let model):
                        recommendations = model
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }

            case .failure(let error):
                print(error.localizedDescription)


            }
        }
        dispatchGroup.notify(queue: .main) {
            guard let newReleases = newReleases?.albums.items,
                  let featuredPlaylist = featuredPlaylist?.playlists.items,
                  let recommendations = recommendations?.tracks else {
                return
            }
            self.configureModels(newAlbums: newReleases, playlists: featuredPlaylist, tracks: recommendations)
            self.hideLoadingIndicator()
            self.collectionView.reloadData()
        }

    }
    
    private func configureModels(
        newAlbums: [Album],
        playlists: [Playlist],
        tracks: [AudioTrack]
    ) {
        self.newAlbums = newAlbums
        self.playlists = playlists
        self.tracks = tracks
        let newReleasesViewModels = newAlbums.map { NewReleasesCellViewModel(artworkURL: URL(string: $0.images[0].url), name: $0.name, numberOfTracks: $0.total_tracks, artistName: $0.artists[0].name) }
        sections.append(.newReleases(viewModels: newReleasesViewModels))
        
        let featuredViewModels = playlists.map {
            FeaturedPlaylistCellViewModel(
                name: $0.name,
                artworkURL: URL(string:  $0.images[0].url),
                creatorName: $0.owner.display_name)
        }
        sections.append(.featuredPlaylists(viewModels: featuredViewModels))
        
        let recommendedViewModels = tracks.map { RecommendedTrackCellViewModel(name: $0.name, artistName: $0.album?.artists[0].name ?? "", artworkURL: URL(string: $0.album?.images[0].url ?? ""))}
        sections.append(.recommendedTracks(viewModels: recommendedViewModels))
    }
    
    @objc private func didTapSettings() {
        let vc = SettingsViewController()
        vc.title = "Settings"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: BrowseTitleHeaderCollectionReusableView.identifier, for: indexPath) as? BrowseTitleHeaderCollectionReusableView , kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionViewCell()
        }
        cell.configure(with: sections[indexPath.section].title)
        return cell
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        sections.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionItem = sections[section]
        switch sectionItem {
        case .newReleases(let viewModels):
            return viewModels.count
        case .featuredPlaylists(let viewModels):
            return viewModels.count
        case .recommendedTracks(let viewModels):
            return viewModels.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let section = sections[indexPath.section]
        switch section {
        case .featuredPlaylists:
            let playlist = playlists[indexPath.row]
            let playlistVC = PlaylistViewController(playlist: playlist)
            playlistVC.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(playlistVC, animated: true)
            
        case .newReleases:
            let album = newAlbums[indexPath.row]
            let albumVC = AlbumViewController(album: album)
            albumVC.navigationItem.largeTitleDisplayMode = .never
            self.navigationController?.pushViewController(albumVC, animated: true)
            
        case .recommendedTracks:
            break
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sectionItem = sections[indexPath.section]
        switch sectionItem {
        case .newReleases(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewReleaseCollectionViewCell.identifier, for: indexPath) as? NewReleaseCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell

        case .featuredPlaylists(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, for: indexPath) as? FeaturedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell

        case .recommendedTracks(let viewModels):
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.identifier, for: indexPath) as? RecommendedCollectionViewCell else {
                return UICollectionViewCell()
            }
            let viewModel = viewModels[indexPath.row]
            cell.configure(with: viewModel)
            return cell

        }

    }
}

struct HomeViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        UINavigationController(
            rootViewController:
                HomeViewController()
        )
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}

struct HomeViewController_Previews: PreviewProvider {
    static var previews: some View {
        HomeViewControllerRepresentable()
    }
}
