//
//  SearchResult.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 30/10/2023.
//

import Foundation
enum SearchResult {
    case track(audioTrack: AudioTrack)
    case playlist(playlist: Playlist)
    case album(album: Album)
    case artist(artist: Artist)
}
