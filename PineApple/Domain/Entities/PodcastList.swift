//
//  PodcastList.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

// MARK: - API 응답의 최상위 구조
struct PodcastList: Decodable {
    let podcasts: [Podcast]

    // JSON 구조를 탐색하기 위한 코딩 키
    private enum CodingKeys: String, CodingKey {
        case feed
    }

    private enum FeedKeys: String, CodingKey {
        case results
    }

    // 중첩된 구조에서 팟캐스트 목록을 추출하기 위한 커스텀 디코더
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let feedContainer = try container.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
        self.podcasts = try feedContainer.decode([Podcast].self, forKey: .results)
    }
}

// MARK: - Podcast (Result) 구조
struct Podcast: Decodable, Hashable {
    let artistName: String
    let id: String
    let name: String
    let kind: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String

    var artworkUrl600: String {
        return artworkUrl100.replacingOccurrences(of: "100x100", with: "600x600")
    }
}

// MARK: - Genre 구조
struct Genre: Decodable, Hashable {
    let genreId: String
    let name: String
    let url: String
}
