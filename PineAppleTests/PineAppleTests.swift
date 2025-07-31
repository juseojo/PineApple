//
//  PineAppleTests.swift
//  PineAppleTests
//
//  Created by seongjun cho on 7/29/25.
//

import Testing
@testable import PineApple
import Moya
import RxSwift

struct PineAppleTests {

    @Test func fetchData_withSubscribe() async throws {
        // Given
        let usecase = DefaultPopularMovieUseCase(provider: MoyaProvider<ItunesAPI>())

        // When
        // withCheckedThrowingContinuation으로 subscribe 콜백을 감싸서 await 가능하게 만듭니다.
        let result: MovieList = try await withCheckedThrowingContinuation { continuation in
            usecase.fetchData()
                .subscribe(onSuccess: { value in
                    // 1. Single이 성공하면, 받은 값을 반환하며 대기를 재개합니다.
                    continuation.resume(returning: value)
                }, onFailure: { error in
                    // 2. Single이 실패하면, 에러를 던지며 대기를 재개합니다.
                    continuation.resume(throwing: error)
                })
        }

        // Then
        // continuation이 재개된 후에야 이 코드가 실행됩니다.
        print("✅ 성공적으로 데이터를 가져왔습니다.\(result.movies)")
        #expect(!result.movies.isEmpty)
    }

    @Test func fetchData_withSubscribe2() async throws {
        // Given
        let usecase = DefaultPopularPodcastUseCase(provider: MoyaProvider<ItunesAPI>())

        // When
        // withCheckedThrowingContinuation으로 subscribe 콜백을 감싸서 await 가능하게 만듭니다.
        let result: PodcastList = try await withCheckedThrowingContinuation { continuation in
            usecase.fetchData()
                .subscribe(onSuccess: { value in
                    // 1. Single이 성공하면, 받은 값을 반환하며 대기를 재개합니다.
                    continuation.resume(returning: value)
                }, onFailure: { error in
                    // 2. Single이 실패하면, 에러를 던지며 대기를 재개합니다.
                    continuation.resume(throwing: error)
                })
        }

        // Then
        // continuation이 재개된 후에야 이 코드가 실행됩니다.
        print("✅ 성공적으로 데이터를 가져왔습니다.: \(result.podcasts)")
        #expect(!result.podcasts.isEmpty)
    }

    @Test func fetchData_withSubscribe3() async throws {
        // Given
        let usecase = DefaultPopularSongsUseCase(provider: MoyaProvider<ItunesAPI>())

        // When
        // withCheckedThrowingContinuation으로 subscribe 콜백을 감싸서 await 가능하게 만듭니다.
        let result: SongList = try await withCheckedThrowingContinuation { continuation in
            usecase.fetchData()
                .subscribe(onSuccess: { value in
                    // 1. Single이 성공하면, 받은 값을 반환하며 대기를 재개합니다.
                    continuation.resume(returning: value)
                }, onFailure: { error in
                    // 2. Single이 실패하면, 에러를 던지며 대기를 재개합니다.
                    continuation.resume(throwing: error)
                })
        }

        // Then
        // continuation이 재개된 후에야 이 코드가 실행됩니다.
        print("✅ 성공적으로 데이터를 가져왔습니다.: \(result.songs)")
        #expect(!result.songs.isEmpty)
    }

    @Test func fetchData_withSubscribe4() async throws {
        // Given
        let usecase = DefaultSearchUseCase(provider: MoyaProvider<ItunesAPI>())

        // When
        // withCheckedThrowingContinuation으로 subscribe 콜백을 감싸서 await 가능하게 만듭니다.
        let result: Contents = try await withCheckedThrowingContinuation { continuation in
            usecase.fetchData(term: "박보영")
                .subscribe(onSuccess: { value in
                    // 1. Single이 성공하면, 받은 값을 반환하며 대기를 재개합니다.
                    continuation.resume(returning: value)
                }, onFailure: { error in
                    // 2. Single이 실패하면, 에러를 던지며 대기를 재개합니다.
                    continuation.resume(throwing: error)
                })
        }

        // Then
        // continuation이 재개된 후에야 이 코드가 실행됩니다.
        print("✅ 성공적으로 데이터를 가져왔습니다.: \(result.results)")
        #expect(!result.results.isEmpty)
    }

    @Test func reactorTest() async throws {
        let a = DefaultPopularSongsUseCase(provider: MoyaProvider<ItunesAPI>())
        let b = DefaultSearchUseCase(provider: MoyaProvider<ItunesAPI>())
        let reactor = MusicReactor(popularSongsUseCase: a, searchSongsUseCase: b)
        let disposeBag = DisposeBag()

        let result = try await withCheckedThrowingContinuation { continuation in
            reactor.state
                .map { $0.popularSongs }
                .filter { !$0.isEmpty } // Wait until popularSongs is populated
                .take(1) // Take only the first valid emission
                .subscribe(onNext: { songs in
                    continuation.resume(returning: songs)
                }, onError: { error in
                    continuation.resume(throwing: error)
                })
                .disposed(by: disposeBag)

            reactor.action.onNext(.fetchPopularSongs) // Trigger the action
        }

        print("✅ Reactor fetched popular songs: \(result)")
        #expect(!result.isEmpty)
    }

    @Test func reactorTest2() async throws {
        let a = DefaultPopularSongsUseCase(provider: MoyaProvider<ItunesAPI>())
        let b = DefaultSearchUseCase(provider: MoyaProvider<ItunesAPI>())
        let reactor = MusicReactor(popularSongsUseCase: a, searchSongsUseCase: b)
        let disposeBag = DisposeBag()

        let result = try await withCheckedThrowingContinuation { continuation in
            reactor.state
                .map { $0.springSongs }
                .filter { !$0.isEmpty } // Wait until popularSongs is populated
                .take(1) // Take only the first valid emission
                .subscribe(onNext: { songs in
                    continuation.resume(returning: songs)
                }, onError: { error in
                    continuation.resume(throwing: error)
                })
                .disposed(by: disposeBag)

            reactor.action.onNext(.fetchSeasonSongs(.spring)) // Trigger the action
        }

        print("✅ Reactor fetched popular songs: \(result)")
        #expect(!result.isEmpty)
    }
}
