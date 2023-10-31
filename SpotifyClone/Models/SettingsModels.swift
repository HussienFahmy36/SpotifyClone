//
//  SettingsModels.swift
//  SpotifyClone
//
//  Created by Hussien Gamal Mohammed on 17/10/2023.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> ()
}
