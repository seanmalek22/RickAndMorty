//
//  RMCharacter.swift
//  RickAndMorty
//
//  Created by Sean Malek on 9/18/26.
//

import Foundation

struct RMCharactersResponse: Codable {
    let results: [RMCharacter]
}

struct RMCharacter: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
    let status: String
    let species: String
    let type: String
    let origin: Origin
    let image: String
    let created: String

    var formattedCreatedDate: String {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        guard let date = isoFormatter.date(from: created) else { return created }

        let displayFormatter = DateFormatter()
        displayFormatter.dateStyle = .medium
        displayFormatter.timeStyle = .short
        return displayFormatter.string(from: date)
    }
}

struct Origin: Codable, Equatable, Hashable {
    let name: String
}
