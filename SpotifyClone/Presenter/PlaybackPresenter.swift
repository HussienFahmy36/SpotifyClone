//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 31/10/2023.
//

import Foundation
import UIKit
import AVFoundation

protocol PlayerDataSource: AnyObject {
    var songName: String? { get }
    var subtitle: String? { get }
    var imageURL: URL? { get }
}

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    private var track: AudioTrack?
    private var tracks: [AudioTrack] = []
    var player: AVPlayer = AVPlayer()
    var currentTrackIndex = 0
    var playItems: [AVPlayerItem] = []

    private var currentTrack: AudioTrack? {
        tracks.isEmpty ? track : tracks[currentTrackIndex]
    }
    
    private init() {
    }
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        guard let url = URL(string: track.preview_url ?? "") else {
            return
        }
        let item = AVPlayerItem(url: url)
        player = AVPlayer(playerItem: item)
        player.volume = 0.5
        self.track = track
        self.tracks = []
        let vc = PlayerViewController()
        vc.delegate = self
        vc.title = track.name
        vc.dataSource = self
        viewController.present(UINavigationController(rootViewController: vc), animated: true){ [weak self] in
            self?.player.play()
        }
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        currentTrackIndex = 0
        let items: [AVPlayerItem] = tracks.compactMap {
            guard let url = URL(string: $0.preview_url ?? "") else {
                return nil
            }
            return AVPlayerItem(url: url)
        }
        self.playItems = items
        self.tracks = tracks
        self.track = nil
        let vc = PlayerViewController()
        vc.dataSource = self
        vc.delegate = self
        player = AVPlayer(playerItem: playItems[0])
        viewController.present(vc, animated: true) { [weak self] in
            self?.player.play()
        }
    }
}

extension PlaybackPresenter: PlayerDataSource {
    var songName: String? {
        currentTrack?.name
    }
    
    var subtitle: String? {
        currentTrack?.artists[0].name
    }
    
    var imageURL: URL? {
        URL(string: currentTrack?.album?.images[0].url ?? "")
    }
}

extension PlaybackPresenter: PlayerViewControllerDelegate {
    func didTapForward() {
        player.pause()
        if !tracks.isEmpty,
           (currentTrackIndex + 1) < (playItems.count - 1) {
            currentTrackIndex += 1
            guard let url = URL(string: currentTrack?.preview_url ?? "") else { return }
            player = AVPlayer(url: url)
            player.play()
        } else if !tracks.isEmpty {
            currentTrackIndex = 0
            guard let url = URL(string: currentTrack?.preview_url ?? "") else { return }
            player = AVPlayer(url: url)
            player.play()
        }
    }
    
    func didTapBackward() {
        player.pause()
        if !tracks.isEmpty,
           (currentTrackIndex - 1) >= 0 {
            currentTrackIndex -= 1
            guard let url = URL(string: currentTrack?.preview_url ?? "") else { return }
            player = AVPlayer(url: url)
            player.play()
        } else if !tracks.isEmpty {
            player.seek(to: CMTime.zero)
            player.play()
        }
    }
    
    func didTapPlayPause() {
        if player.timeControlStatus == .playing {
            player.pause()
        } else if player.timeControlStatus == .paused {
            player.play()
        }
    }
    
    func didSlideSlider(_ value: Float) {
        player.volume = value
    }
}
