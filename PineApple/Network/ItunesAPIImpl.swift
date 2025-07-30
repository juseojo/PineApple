//
//  ItunesAPI.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

import Moya

extension ItunesAPI: TargetType {
    var headers: [String: String]? { nil }
    
    var baseURL: URL {
        switch self {
        case .popularSongs:
            guard let url = URL(
                string: "https://rss.marketingtools.apple.com/api/v2/kr/") else {
                fatalError("⚠️ popularSongs URL 잘못 넣었음")
            }
            return url
        case .popularMovie:
            guard let url = URL(
                string: "https://itunes.apple.com/kr/rss/topmovies/limit=10/json") else {
                fatalError("⚠️ popularMovie URL 잘못 넣었음")
            }
            return url
        case .popularPodcast:
            guard let url = URL(
                string: "https://rss.marketingtools.apple.com/api/v2/kr/") else {
                fatalError("⚠️ popularPodcast URL 잘못 넣었음")
            }
            return url
        case .search(let title):
            guard let url = URL(
                string: "https://itunes.apple.com/search") else {
                fatalError("⚠️ search URL 잘못 넣었음")
            }
            return url
        }
    }

    var path: String {
        switch self {
        case .popularMovie:
            return "music/most-played/10/songs.json"
        case .popularSongs:
            return ""
        case .popularPodcast:
            return "podcasts/top/25/podcasts.json"
        case .search(title: let title):
            return ""
        }
    }

    var method: Moya.Method { .get }

    var task: Task {
        switch self {
        case .popularSongs:
            return .requestPlain
        case .popularMovie:
            return .requestPlain
        case .popularPodcast:
            return .requestPlain
        case .search(let title):
            return .requestParameters(
                parameters: ["term" : title,
                             "country" : "KR",
                            ],
                encoding: URLEncoding.queryString
            )
        }
    }

    var sampleData: Data { Data() }   // 테스트용 stub 데이터
}
