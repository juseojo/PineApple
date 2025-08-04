//
//  SearchUseCase.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

import Moya
import RxSwift
import RxMoya

enum MediaType: String {
    case music = "music"
    case movie = "movie"
    case podcast = "podcast"
}

protocol SearchUseCase {
    func fetchData(term: String, offset: Int, mediaType: MediaType) -> Single<Contents>
}

final class DefaultSearchUseCase: SearchUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI>) {
        self.provider = provider
    }

    func fetchData(term: String, offset: Int = 0, mediaType: MediaType) -> Single<Contents> {
        switch mediaType {
        case .music:
            return provider.rx.request(.search(title: term, offset: offset, media: .music)).map(Contents.self)
        case .movie:
            return provider.rx.request(.search(title: term, offset: offset, media: .movie)).map(Contents.self)
        case .podcast:
            return provider.rx.request(.search(title: term, offset: offset, media: .podcast)).map(Contents.self)
        }
    }
}
