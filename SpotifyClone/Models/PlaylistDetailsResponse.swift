//
//  PlaylistDetailsResponse.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 28/10/2023.
//

import Foundation

struct PlaylistDetailsResponse: Codable {
    let description: String
    let external_urls: [String: String]
    let href: String
    let id: String
    let images: [APIImage]
    let tracks: PlaylistTrackResponse
}
struct PlaylistTrackResponse: Codable {
    let items: [PlaylistItem]
}
struct PlaylistItem: Codable {
    let track: AudioTrack
}
