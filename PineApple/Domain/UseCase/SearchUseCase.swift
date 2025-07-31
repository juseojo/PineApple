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
    func fetchData() -> Single<Contents>
}

final class DefaultSearchUseCase: SearchUseCase {

    private let provider: MoyaProvider<ItunesAPI>
    private let term: String

    init(provider: MoyaProvider<ItunesAPI>, term: String) {
        self.provider = provider
        self.term = term
    }

    func fetchData() -> Single<Contents> {
        if term.isEmpty {
            return Single<Contents>.error("term is nil" as! Error)
        }

        return provider.rx.request(.search(title: term)).map(Contents.self)
    }
}
