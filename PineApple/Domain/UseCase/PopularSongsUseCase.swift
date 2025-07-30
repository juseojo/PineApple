//
//  PopularSongsUseCase.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

import Moya
import RxSwift
import RxMoya


protocol PopularSongsUseCase {
    func fetchData() -> Single<Song>
}

final class DefaultPopularSongsUseCase: PopularSongsUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI> = .init()) {
        self.provider = provider
    }

    func fetchData() -> Single<Song> {
        return provider.rx.request(.popularSongs).map(Song.self)
    }
}
