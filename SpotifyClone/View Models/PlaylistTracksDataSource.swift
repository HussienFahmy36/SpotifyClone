//
//  PlaylistTracksDataSource.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 09/11/2023.
//

import Foundation

class PlaylistTracksDataSource: TracksDataSource {
    
    
    var tracks: [AudioTrack] = []
    var viewModels: [RecommendedTrackCellViewModel] = []
    var model: Playlist
    
    var title: String {
        model.name
    }

    init(model: Playlist) {
        self.model = model
    }
    
    func fetchTracks(completion: @escaping (Result<Void, Error>) -> Void) {
        APICaller.shared.getPlaylistDetails(for: model) {[unowned self] result in
            switch result {
            case .success(let model):
                self.tracks = model.tracks.items.map { $0.track }
                self.configureViewModels()
                completion(.success(()))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func configureViewModels() {
        viewModels = tracks.map { RecommendedTrackCellViewModel(name: $0.name, artistName: $0.artists[0].name, artworkURL: URL(string: $0.album?.images[0].url ?? ""))}
    }

}
