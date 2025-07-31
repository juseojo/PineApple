//
//  MovieList.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

// MARK: - API 응답의 최상위 구조
struct MovieList: Decodable {
    let movies: [Movie]

    // JSON 구조를 탐색하기 위한 코딩 키
    private enum CodingKeys: String, CodingKey {
        case feed
    }

    private enum FeedKeys: String, CodingKey {
        case entry
    }

    // 중첩된 구조에서 영화 목록을 추출하기 위한 커스텀 디코더
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let feedContainer = try container.nestedContainer(keyedBy: FeedKeys.self, forKey: .feed)
        self.movies = try feedContainer.decode([Movie].self, forKey: .entry)
    }
}

// MARK: - Movie (Entry) 구조
struct Movie: Decodable {
    let title: LabelWrapper
    let images: [ImageInfo]
    let summary: LabelWrapper
    let price: PriceInfo
    let artist: LabelWrapper
    let releaseDate: ReleaseDateInfo
    let category: CategoryInfo

    enum CodingKeys: String, CodingKey {
        case title = "im:name"
        case images = "im:image"
        case summary
        case price = "im:price"
        case artist = "im:artist"
        case releaseDate = "im:releaseDate"
        case category
    }

    var highResolutionImageURL: URL? {
        let sortedImages = images.sorted {
            (Int($0.attributes.height) ?? 0) > (Int($1.attributes.height) ?? 0)
        }
        return sortedImages.first?.url
    }
}

struct LabelWrapper: Decodable {
    let label: String
}

struct ImageInfo: Decodable {
    let label: String
    let attributes: ImageAttributes
    var url: URL? { URL(string: label) }
}

struct ImageAttributes: Decodable {
    let height: String
}

struct PriceInfo: Decodable {
    let label: String
    let attributes: PriceAttributes
}

struct PriceAttributes: Decodable {
    let amount: String
    let currency: String
}

struct ReleaseDateInfo: Decodable {
    let label: String
    let attributes: ReleaseDateAttributes
}

struct ReleaseDateAttributes: Decodable {
    let label: String
}

struct CategoryInfo: Decodable {
    let attributes: CategoryAttributes
}

struct CategoryAttributes: Decodable {
    let id: String
    let term: String
    let scheme: String
    let label: String

    enum CodingKeys: String, CodingKey {
        case id = "im:id"
        case term, scheme, label
    }
}
