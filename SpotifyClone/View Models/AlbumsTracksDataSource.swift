//
//  AlbumsTracksDataSource.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 09/11/2023.
//

import Foundation

class AlbumsTracksDataSource: TracksDataSource {
    
    typealias T = Album
    typealias VM = AlbumCellViewModel
    
    var tracks: [AudioTrack] = []
    var viewModels: [AlbumCellViewModel] = []
    var model: Album
    
    var title: String {
        model.name
    }

    init(model: Album) {
        self.model = model
    }
    
    func fetchTracks(completion: @escaping (Result<Void, Error>) -> Void) {
        APICaller.shared.getAlbumDetails(for: model) {[unowned self] result in
            switch result {
            case .success(let model):
                self.tracks = model.tracks.items
                self.configureViewModels()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    private func configureViewModels() {
        viewModels = tracks.map { AlbumCellViewModel(name: $0.name, artistName: $0.artists[0].name)}
    }

}
