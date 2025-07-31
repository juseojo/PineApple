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
    func fetchData() -> Single<SongList>
}

final class DefaultPopularSongsUseCase: PopularSongsUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI>) {
        self.provider = provider
    }

    func fetchData() -> Single<SongList> {
        return provider.rx.request(.popularSongs).map(SongList.self)
    }
}
