//
//  PlaybackPresenter.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 31/10/2023.
//

import Foundation
import UIKit

final class PlaybackPresenter {
    static let shared = PlaybackPresenter()
    
    private init() {
    }
    
    func startPlayback(
        from viewController: UIViewController,
        track: AudioTrack
    ) {
        let vc = PlayerViewController()
        vc.title = track.name
        viewController.present(UINavigationController(rootViewController: vc), animated: true)
    }
    
    func startPlayback(
        from viewController: UIViewController,
        tracks: [AudioTrack]
    ) {
        let vc = PlayerViewController()
        viewController.present(vc, animated: true)
    }
}
