//
//  PopularPodcastUseCase.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

import Moya
import RxSwift
import RxMoya


protocol PopularPodcastUseCase {
    func fetchData() -> Single<Podcast>
}

final class DefaultPopularPodcastUseCase: PopularPodcastUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI> = .init()) {
        self.provider = provider
    }

    func fetchData() -> Single<Podcast> {
        return provider.rx.request(.popularPodcast).map(Podcast.self)
    }
}
