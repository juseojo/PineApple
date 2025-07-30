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
    func fetchData() -> Single<Movie>
}

final class DefaultMovieUseCase: PopularMovieUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI> = .init()) {
        self.provider = provider
    }

    func fetchData() -> Single<Movie> {
        return provider.rx.request(.popularMovie).map(Movie.self)
    }
}

