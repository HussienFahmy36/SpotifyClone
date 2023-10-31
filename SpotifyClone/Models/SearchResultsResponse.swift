//
//  SearchResultsResponse.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 30/10/2023.
//

import Foundation

struct SearchResultsResponse: Codable {
    let albums: SearchAlbumResponse
    let artists: SearchArtistsResponse
    let playlists: SearchPlaylistsResponse
    let tracks: SearchTracksResponse
    
}

struct SearchAlbumResponse: Codable {
    let items: [Album]
}

struct SearchArtistsResponse: Codable {
    let items: [Artist]

}

struct SearchPlaylistsResponse: Codable {
    let items: [Playlist]

}

struct SearchTracksResponse: Codable {
    let items: [AudioTrack]

}
