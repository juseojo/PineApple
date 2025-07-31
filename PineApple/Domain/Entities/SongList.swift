//
//  SongList.swift
//  PineApple
//
//  Created by seongjun cho on 7/31/25.
//

import Foundation

// MARK: - API 응답의 최상위 구조
struct SongList: Decodable {
    let songs: [Song]

    // JSON 구조를 탐색하기 위한 코딩 키
    private enum CodingKeys: String, CodingKey {
        case feed
    }

    private enum FeedKeys: String, CodingKey {
        case results
    }

    // 중첩된 구조에서 노래 목록을 추출하기 위한 커스텀 디코더
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let feedContainer = try container.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
        self.songs = try feedContainer.decode([Song].self, forKey: .results)
    }
}

// MARK: - Song (Result) 구조
struct Song: Decodable {
    let artistName: String
    let id: String
    let name: String
    let releaseDate: String
    let kind: String
    let artistId: String
    let artistUrl: String
    let artworkUrl100: String
    let genres: [Genre]
    let url: String
}

