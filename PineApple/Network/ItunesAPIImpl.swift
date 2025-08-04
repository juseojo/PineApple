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
                string: "https://rss.marketingtools.apple.com") else {
                fatalError("⚠️ popularSongs URL 잘못 넣었음")
            }
            return url
        case .popularMovie, .search:
            guard let url = URL(
                string: "https://itunes.apple.com") else {
                fatalError("⚠️ popularMovie URL 잘못 넣었음")
            }
            return url
        case .popularPodcast:
            guard let url = URL(
                string: "https://rss.marketingtools.apple.com") else {
                fatalError("⚠️ popularPodcast URL 잘못 넣었음")
            }
            return url
        }
    }

    var path: String {
        switch self {
        case .popularMovie:
            return "/kr/rss/topmovies/limit=10/json"
        case .popularSongs:
            return "/api/v2/kr/music/most-played/10/songs.json"
        case .popularPodcast:
            return "/api/v2/kr/podcasts/top/25/podcasts.json"
        case .search:
            return "/search"
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
