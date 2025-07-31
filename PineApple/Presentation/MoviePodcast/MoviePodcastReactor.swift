//
//  MoviePodcastReactor.swift
//  PineApple
//
//  Created by seongjun cho on 7/31/25.
//

import Foundation

import ReactorKit
import Moya
import Then

final class MoviePodcastReactor: Reactor {
    let initialState: State = State()

    let popularMoviesUseCase: DefaultPopularMovieUseCase
    let popularPodcastsUseCase: DefaultPopularPodcastUseCase
    let searchContentsUseCase: DefaultSearchUseCase

    enum Action {
        case fetchPopularMovies
        case fetchPopularPodcasts
        case searchContents(String)
    }

    enum Mutation {
        case setPopularMovies(MovieList)
        case setPopularPodcasts(PodcastList)
        case setSearchContents(Contents?)
    }

    struct State: Then {
        var popularMovies = [Movie]()
        var popularPodcasts = [Podcast]()
        var searchContents = [Content]()
    }

    init(popularMoviesUseCase: DefaultPopularMovieUseCase,
        popularPodcastsUseCase: DefaultPopularPodcastUseCase,
        searchContentsUseCase: DefaultSearchUseCase) {
        self.popularMoviesUseCase = popularMoviesUseCase
        self.searchContentsUseCase = searchContentsUseCase
        self.popularPodcastsUseCase = popularPodcastsUseCase
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchPopularMovies:
            return popularMoviesUseCase.fetchData()
                .map { Mutation.setPopularMovies($0) }
                .asObservable()
        case .fetchPopularPodcasts:
            return popularPodcastsUseCase.fetchData()
                .map { Mutation.setPopularPodcasts($0) }
                .asObservable()
        case .searchContents(let term):
            return searchContentsUseCase.fetchData(term: term)
                .map { Mutation.setSearchContents($0) }
                .asObservable()
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        switch mutation {
        case .setPopularMovies(let movieList):
            return state.with {
                $0.popularMovies = movieList.movies
            }
        case .setPopularPodcasts(let podcastList):
            return state.with {
                $0.popularPodcasts = podcastList.podcasts
            }
        case .setSearchContents(let contents):
            return state.with {
                $0.searchContents = contents?.results ?? []
            }
        }
    }

    func transform(state: Observable<State>) -> Observable<State> {
        state.observe(on: MainScheduler.instance)
    }
}
