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
    func fetchData() -> Single<PodcastList>
}

final class DefaultPopularPodcastUseCase: PopularPodcastUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI>) {
        self.provider = provider
    }

    func fetchData() -> Single<PodcastList> {
        return provider.rx.request(.popularPodcast).map(PodcastList.self)
    }
}
