//
//  CategoryViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 30/10/2023.
//

import UIKit

class CategoryViewController: UIViewController {

    private let category: Category
    private var playlists: [Playlist] = []
    private var viewModels: [FeaturedPlaylistCellViewModel] = []
    
    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            
            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 2, bottom: 2, trailing: 2)
            
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.5), heightDimension: .absolute(250)), repeatingSubitem: item, count: 2)
            
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 4, bottom: 0, trailing: 4)
            return section
        }))
        
        collectionView.register(FeaturedCollectionViewCell.self, forCellWithReuseIdentifier: FeaturedCollectionViewCell.identifier)
        
        return collectionView
    }()
    
    init(category: Category) {
        self.category = category
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.name
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchData()
    }
    
    private func fetchData() {
        showLoadingIndicator()
        APICaller.shared.getCategoryPlaylists(categoryId: category.id) {[unowned self] result in
            switch result {
            case .success(let playlists):
                self.playlists = playlists
                self.configureViewModels()
                DispatchQueue.main.async {
                    self.hideLoadingIndicator()
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureViewModels() {
        viewModels = playlists.map { FeaturedPlaylistCellViewModel(name: $0.name, artworkURL: URL(string: $0.images[0].url), creatorName: $0.owner.display_name)}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        playlists.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FeaturedCollectionViewCell.identifier, for: indexPath) as? FeaturedCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = viewModels[indexPath.row]
        cell.configure(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let playlist = playlists[indexPath.row]
        let playlistVC = PlaylistViewController(playlist: playlist)
        playlistVC.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(playlistVC, animated: true)
    }
}
