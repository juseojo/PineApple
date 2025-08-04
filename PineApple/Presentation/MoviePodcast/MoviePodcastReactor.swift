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
        case loadNextPage
    }

    enum Mutation {
        case setPopularMovies(MovieList)
        case setPopularPodcasts(PodcastList)
        case setSearchContents(Contents?, term: String)
        case appendSearchContents(Contents?)
        case setLoading(Bool)
    }

    struct State: Then {
        var popularMovies = [Movie]()
        var popularPodcasts = [Podcast]()
        var searchContents = [Content]()
        var searchTerm: String = ""
        var isLoading: Bool = false
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
                .map { .setPopularMovies($0) }
                .asObservable()
        case .fetchPopularPodcasts:
            return popularPodcastsUseCase.fetchData()
                .map { .setPopularPodcasts($0) }
                .asObservable()
        case .searchContents(let term):
            let movieSearch = searchContentsUseCase.fetchData(term: term, offset: 0, mediaType: .movie)
                .asObservable()
                .catchAndReturn(Contents(resultCount: 0, results: []))
            let podcastSearch = searchContentsUseCase.fetchData(term: term, offset: 0, mediaType: .podcast)
                .asObservable()
                .catchAndReturn(Contents(resultCount: 0, results: []))

            return Observable.zip(movieSearch, podcastSearch)
                .map { movieContents, podcastContents -> Contents in
                    let combinedResults = movieContents.results + podcastContents.results
                    return Contents(resultCount: combinedResults.count, results: combinedResults)
                }
                .map { .setSearchContents($0, term: term) }

        case .loadNextPage:
            if currentState.isLoading {
                return .empty()
            }

            let term = currentState.searchTerm
            let movieOffset = currentState.searchContents.filter { $0.kind == "feature-movie" }.count
            let podcastOffset = currentState.searchContents.filter { $0.kind == "podcast" }.count

            let movieSearch = searchContentsUseCase.fetchData(term: term, offset: movieOffset, mediaType: .movie)
                .asObservable()
                .catchAndReturn(Contents(resultCount: 0, results: []))
            let podcastSearch = searchContentsUseCase.fetchData(term: term, offset: podcastOffset, mediaType: .podcast)
                .asObservable()
                .catchAndReturn(Contents(resultCount: 0, results: []))

            return .concat([
                .just(.setLoading(true)),
                Observable.zip(movieSearch, podcastSearch)
                    .map { movieContents, podcastContents -> Contents in
                        let combinedResults = movieContents.results + podcastContents.results
                        return Contents(resultCount: combinedResults.count, results: combinedResults)
                    }
                    .map { .appendSearchContents($0) },
                .just(.setLoading(false))
            ])
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
        case .setSearchContents(let contents, let term):
            return state.with {
                $0.searchContents = contents?.results ?? []
                $0.searchTerm = term
            }
        case .appendSearchContents(let contents):
            let newContents = contents?.results ?? []
            return state.with {
                $0.searchContents.append(contentsOf: newContents)
                print(newContents.map { $0.trackName })
            }
        case .setLoading(let isLoading):
            return state.with {
                $0.isLoading = isLoading
            }
        }
    }

    func transform(state: Observable<State>) -> Observable<State> {
        state.observe(on: MainScheduler.instance)
    }
}
