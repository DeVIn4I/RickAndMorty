//
//  RMEpisode.swift
//  RickAndMorty
//
//  Created by Razumov Pavel on 14.04.2025.
//

import Foundation

struct RMEpisode: Codable {
    let id: Int
    let name: String
    let air_date: String
    let epsode: String
    let characters: [String]
    let url: String
    let created: String
}
