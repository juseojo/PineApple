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


protocol SearchUseCase {
    func fetchData(term: String) -> Single<Contents>
}

final class DefaultSearchUseCase: SearchUseCase {

    private let provider: MoyaProvider<ItunesAPI>

    init(provider: MoyaProvider<ItunesAPI>) {
        self.provider = provider
    }

    func fetchData(term: String) -> Single<Contents> {
        return provider.rx.request(.search(title: term)).map(Contents.self)
    }
}
