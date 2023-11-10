//
//  AudioTracksDisplayBehaviorPlaylists.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 09/11/2023.
//

import UIKit

class TracksPlaylistDisplayDefaultStrategy: TracksPlaylistDisplayStrategy {

    var viewModels: [RecommendedTrackCellViewModel] = []
    func registerCells(in collectionView: UICollectionView) {
        collectionView.register(RecommendedCollectionViewCell.self, forCellWithReuseIdentifier: RecommendedCollectionViewCell.identifier)
        collectionView.register(PlaylistHeaderCollectionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: PlaylistHeaderCollectionReusableView.identifier)
    }
    
    func cellToDisplay(at indexPath: IndexPath, in collectionView: UICollectionView, viewModel: Any) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecommendedCollectionViewCell.identifier, for: indexPath) as? RecommendedCollectionViewCell else {
            return UICollectionViewCell()
        }
        if let viewModel = viewModel as? RecommendedTrackCellViewModel {
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
