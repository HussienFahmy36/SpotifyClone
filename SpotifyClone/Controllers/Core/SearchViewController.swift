//
//  SearchViewController.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 16/10/2023.
//

import UIKit
import SafariServices

class SearchViewController: UIViewController {

    private let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewCompositionalLayout(sectionProvider: { _, _ -> NSCollectionLayoutSection in
            let item = NSCollectionLayoutItem(
                layoutSize:
                        .init(widthDimension: .fractionalWidth(1.0),
                              heightDimension: .fractionalHeight(1.0))
            )
            
            item.contentInsets = NSDirectionalEdgeInsets(top: 2, leading: 7, bottom: 2, trailing: 7)
            let group = NSCollectionLayoutGroup.horizontal(
                layoutSize:
                        .init(widthDimension: .fractionalWidth(0.5),
                              heightDimension: .fractionalHeight(0.2)),
                repeatingSubitem: item,
                count: 2
            )
            
            group.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 5, trailing: 0)
            let section = NSCollectionLayoutSection(group: group)
            return section
            
        }))
        collectionView.register(CategoryCollectionViewCell.self, forCellWithReuseIdentifier: CategoryCollectionViewCell.identifier)
        return collectionView
    }()
    
    private let searchController: UISearchController = {
        let searchController = UISearchController(searchResultsController: SearchResultsViewController())
        searchController.searchBar.placeholder = "Songs, Artists, Albums"
        searchController.searchBar.searchBarStyle = .minimal
        searchController.definesPresentationContext = true
        return searchController
    }()
    
    private var viewModels: [CategoryCollectionViewCellViewModel] = []
    private var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        view.backgroundColor = .systemBackground
        navigationItem.searchController = searchController
        searchController.searchBar.delegate = self
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .systemBackground
        fetchData()
    }
    
    private func fetchData() {
        APICaller.shared.getCategories { [unowned self] result in
            switch result {
            case .success(let model):
                self.categories = model
                self.configureViewModels()
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func configureViewModels() {
        viewModels = categories.map { CategoryCollectionViewCellViewModel(title: $0.name, poster_ImageURL: URL(string: $0.icons[0].url))}
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

extension SearchViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CategoryCollectionViewCell.identifier, for: indexPath) as? CategoryCollectionViewCell else {
            return UICollectionViewCell()
        }
        let viewModel = viewModels[indexPath.row]
        cell.config(with: viewModel)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let item = categories[indexPath.row]
        
        let categoryViewController = CategoryViewController(category: item)
        self.navigationController?.pushViewController(categoryViewController, animated: true)
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let resultsController = searchController.searchResultsController as? SearchResultsViewController,
            let query = searchBar.text, !query.trimmingCharacters(in: .whitespaces).isEmpty else { return }
        resultsController.delegate = self
        APICaller.shared.search(with: query) { result in
            switch result {
            case .success(let results):
                resultsController.update(with: results)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension SearchViewController: SearchResultsViewControllerDelegate {
    func didTapResult(_ searchResult: SearchResult) {
        var resultViewController: UIViewController?
        switch searchResult {
        case .album(let album):
            let vc = AlbumViewController(album: album)
            resultViewController = vc
        case .artist(let artist):
            guard let urlString = artist.external_urls["spotify"],
                let url = URL(string: urlString) else {
                return
            }
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true)
        case .playlist(let playlist):
            let vc = PlaylistViewController(playlist: playlist)
            resultViewController = vc
        case .track(let track):
            PlaybackPresenter.shared.startPlayback(from: self, track: track)
        }
        guard let resultViewController else { return }
        resultViewController.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(resultViewController, animated: true)
    }
}
