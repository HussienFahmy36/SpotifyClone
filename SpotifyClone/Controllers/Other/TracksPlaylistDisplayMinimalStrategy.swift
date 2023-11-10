//
//  TracksPlaylistDisplayMinimalStrategy.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 09/11/2023.
//

import UIKit

class TracksPlaylistDisplayMinimalStrategy: TracksPlaylistDisplayStrategy {

    var viewModels: [AlbumCellViewModel] = []

    func registerCells(in collectionView: UICollectionView) {
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: AlbumCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
    }
    
    func cellToDisplay(at indexPath: IndexPath, in collectionView: UICollectionView, viewModel: Any) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as? AlbumCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let viewModel = viewModel as? AlbumCellViewModel {
            cell.configure(with: viewModel)
        }
        return cell
    }
     
    func headerViewToDisplay(at indexPath: IndexPath, in collectionView: UICollectionView,  viewModel: Any) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier, for: indexPath) as? PlaylistHeaderCollectionReusableView,
        let viewModel = viewModel as? PlaylistHeaderCollectionViewModel else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel)
        return cell
    }
}
