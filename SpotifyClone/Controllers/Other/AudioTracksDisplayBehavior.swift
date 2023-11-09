//
//  AudioTracksDisplayBehavior.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 09/11/2023.
//

import UIKit
protocol TracksPlaylistDisplayStrategy {
    
    func registerCells(in collectionView: UICollectionView)

    func cellToDisplay(at indexPath: IndexPath, in collectionView: UICollectionView, viewModel: Any) -> UICollectionViewCell
    
    func headerViewToDisplay(at indexPath: IndexPath, in collectionView: UICollectionView,  viewModel: Any) -> UICollectionViewCell
        
}
