//
//  TracksDataSource.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 09/11/2023.
//

import Foundation

protocol TracksDataSource {
    associatedtype T
    associatedtype VM
    
    var title: String { get }
    var viewModels: [VM] { get set }
    var tracks: [AudioTrack] { get set }
    var model: T { get set }
    
    func fetchTracks(completion: @escaping (Result<Void, Error>) -> Void)

}
