//
//  MusicReactor.swift
//  PineApple
//
//  Created by seongjun cho on 7/31/25.
//

import Foundation

import ReactorKit
import Moya
import Then

final class MusicReactor: Reactor {
    let initialState: State = State()
    let popularSongsUseCase: DefaultPopularSongsUseCase
    let searchSongsUseCase: DefaultSearchUseCase

    enum Season: String {
        case spring = "봄"
        case summer = "여름"
        case autumn = "가을"
        case winter = "겨울"
    }

    enum Action {
        case fetchPopularSongs
        case fetchSeasonSongs(Season)
    }

    enum Mutation {
        case setPopularSongs(SongList?)
        case setSeasonSongs(Contents?, Season)
    }

    struct State: Then {
        var popularSongs = [Song]()
        var springSongs = [Content]()
        var summerSongs = [Content]()
        var atumnSongs = [Content]()
        var winterSongs = [Content]()
    }

    init(popularSongsUseCase: DefaultPopularSongsUseCase, searchSongsUseCase: DefaultSearchUseCase) {
        self.popularSongsUseCase = popularSongsUseCase
        self.searchSongsUseCase = searchSongsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPopularSongs:
            return popularSongsUseCase.fetchData()
                .map { Mutation.setPopularSongs($0) }
                .asObservable()
        case .fetchSeasonSongs(let season):
            return searchSongsUseCase.fetchData(term: season.rawValue, offset: 0, mediaType: .music)
                .map { Mutation.setSeasonSongs($0, season) }
                .asObservable()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setPopularSongs(let songList):
            return state.with {
                $0.popularSongs = songList?.songs ?? []
            }
        case .setSeasonSongs(let contents, let season):
            return state.with {
                switch season {
                case .spring:
                    $0.springSongs = contents?.results.filter { $0.kind == "song" } ?? []
                case .summer:
                    $0.summerSongs = contents?.results.filter { $0.kind == "song" } ?? []
                case .autumn:
                    $0.atumnSongs = contents?.results.filter { $0.kind == "song" } ?? []
                case .winter:
                    $0.winterSongs = contents?.results.filter { $0.kind == "song" } ?? []
                }
            }
        }
    }

    func transform(state: Observable<State>) -> Observable<State> {
        state.observe(on: MainScheduler.instance)
    }
}
