//
//  PopularMovieUseCase.swift
//  PineApple
//
//  Created by seongjun cho on 7/30/25.
//

import Foundation

import Moya
import RxSwift
import RxMoya


protocol PopularMovieUseCase {
    func fetchData() -> Single<MovieList>
}

final class DefaultPopularMovieUseCase: PopularMovieUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI>) {
        self.provider = provider
    }

    func fetchData() -> Single<MovieList> {
        return provider.rx.request(.popularMovie).map(MovieList.self)
    }
}

