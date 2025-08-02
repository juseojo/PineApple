//
//  Contents.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

// MARK: - APIResult
struct Contents: Decodable {
    let resultCount: Int
    let results: [Content]
}

// MARK: - Content
struct Content: Decodable, Hashable, Identifiable {
    let id = UUID()
    let wrapperType: String
    let kind: String
    let artistName: String
    let collectionName: String?
    let trackName: String
    let trackViewURL: String
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String
    let collectionPrice, trackPrice, trackRentalPrice: Double?
    let releaseDate: String
    let primaryGenreName: String
    let shortDescription, longDescription: String?
    let contentAdvisoryRating: String?
    let trackTimeMillis: Int?
    let isStreamable: Bool?

    var artworkUrl600: String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "600x600")
    }
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind, artistName, collectionName, trackName
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, trackRentalPrice, releaseDate, primaryGenreName, shortDescription, longDescription, contentAdvisoryRating, trackTimeMillis, isStreamable
    }
}
