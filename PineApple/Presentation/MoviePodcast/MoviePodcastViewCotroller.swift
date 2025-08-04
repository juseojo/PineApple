//
//  MoviePodcastViewCotroller.swift
//  PineApple
//
//  Created by seongjun cho on 8/3/25.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import Moya
import Hero

class MoviePodcastViewCotroller: UIViewController, View {

    enum MoviePodcastItem: Hashable {
        case popularMovie(Movie)
        case popularPodcast(Podcast)
        case search(Content)
    }

    // MARK: - 프로퍼티
    var disposeBag = DisposeBag()
    let moviePodcastView = MoviePodcastView()
    let moviePodcastReactor: MoviePodcastReactor
    private lazy var moviePodcastDataSource = makeMoviePodcastCollectionViewDataSource(
        moviePodcastView.moviePodcastCollectionView)
    private lazy var searchListDataSource = makeSearchListCollectionViewDataSource(
        moviePodcastView.searchListCollectionView)

    // MARK: - 이니셜라이징
    init(reactor: MoviePodcastReactor) {
        self.moviePodcastReactor = reactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - 라이프 사이클
    override func loadView() {
        self.view = moviePodcastView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind(reactor: moviePodcastReactor)
        moviePodcastView.searchBar.hero.id = "searchBar"
        moviePodcastView.searchBar.becomeFirstResponder()
    }

    // MARK: - 메소드

    // 인기 영화, 팟캐스트 데이터소스 생성
    private func makeMoviePodcastCollectionViewDataSource(
        _ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, MoviePodcastItem> {

        let movieCellRegistration = UICollectionView.CellRegistration<PopularMovieCell, Movie> { cell, _, item in
            cell.configure(movie: item)
        }

        let podcastCellRegistration = UICollectionView.CellRegistration<HorizonCell, Podcast> { cell, _, item in
            cell.configurePodcast(podcast: item)
        }

        let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (supplementaryView, string, indexPath) in
            switch indexPath.section {
            case 0:
                supplementaryView.configure(with: "인기 영화")
            case 1:
                supplementaryView.configure(with: "인기 팟캐스트")
            default:
                print("section error")
            }
        }

        let dataSource = UICollectionViewDiffableDataSource<Int, MoviePodcastItem>(
            collectionView: collectionView) { collectionView, indexPath, item in

            switch item {
            case .popularMovie(let movie):
                return collectionView
                    .dequeueConfiguredReusableCell(
                        using: movieCellRegistration,
                        for: indexPath,
                        item: movie
                    )
            case .popularPodcast(let podcast):
                return collectionView
                    .dequeueConfiguredReusableCell(
                        using: podcastCellRegistration,
                        for: indexPath,
                        item: podcast
                    )
            default:
                return UICollectionViewCell()
            }
        }

        dataSource.supplementaryViewProvider = { (view, kind, index) in
            return view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
        }

        return dataSource
    }

    // 검색 내용 리스트 데이터소스 생성
    private func makeSearchListCollectionViewDataSource(
        _ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, MoviePodcastItem> {

        let searchCellRegistration = UICollectionView.CellRegistration<HorizonCell, Content> { cell, _, item in
            cell.confugureContetns(content: item)
        }

        let dataSource = UICollectionViewDiffableDataSource<Int, MoviePodcastItem>(
            collectionView: collectionView) { collectionView, indexPath, item in

            switch item {
            case .search(let content):
                return collectionView
                    .dequeueConfiguredReusableCell(
                        using: searchCellRegistration,
                        for: indexPath,
                        item: content
                    )
            default:
                return UICollectionViewCell()
            }
        }
            
        return dataSource
    }


    func bind(reactor: MoviePodcastReactor) {
        // 서치바 텍스트 검색
        moviePodcastView.searchBar.rx.text.orEmpty
            .debounce(.milliseconds(500), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .map { .searchContents($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        // 검색 내용 있을 시 영화, 팟캐스트 추천 히든
        reactor.state.map { $0.searchContents.isEmpty == false }
            .distinctUntilChanged()
            .bind(to: moviePodcastView.moviePodcastCollectionView.rx.isHidden)
            .disposed(by: disposeBag)

        // 검색 내용 없을 시 검색 리스트 히든
        reactor.state.map { $0.searchContents.isEmpty }
            .distinctUntilChanged()
            .bind(to: moviePodcastView.searchListCollectionView.rx.isHidden)
            .disposed(by: disposeBag)

        // 검색 내용 데이터소스에 바인딩
        reactor.state.map { $0.searchContents }
            .distinctUntilChanged()
            .subscribe(onNext: { [weak searchListDataSource] contents in
                var snapshot = NSDiffableDataSourceSnapshot<Int, MoviePodcastItem>()
                snapshot.appendSections([0])
                snapshot.appendItems(contents.map { .search($0) }, toSection: 0)
                searchListDataSource?.apply(snapshot, animatingDifferences: true)
            })
            .disposed(by: disposeBag)

        // 인기 영화, 팟캐스트 바인딩
        reactor
            .state
            .bind { [weak moviePodcastDataSource] item in
                var snapshot = NSDiffableDataSourceSnapshot<Int, MoviePodcastItem>()
                snapshot.appendSections([0, 1])
                snapshot.appendItems(item.popularMovies.map { .popularMovie($0) }, toSection: 0)
                snapshot.appendItems(item.popularPodcasts.map { .popularPodcast($0) }, toSection: 1)
                moviePodcastDataSource?.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)

        // 백 버튼 액션 바인딩
        moviePodcastView.backButton.rx.tap
            .subscribe(onNext: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .disposed(by: disposeBag)

        reactor.action.onNext(.fetchPopularMovies)
        reactor.action.onNext(.fetchPopularPodcasts)
    }
}

@available(iOS 18.0, *)
#Preview {
    let popularMoviesUseCase = DefaultPopularMovieUseCase(provider: MoyaProvider<ItunesAPI>())
    let popularPodcastsUseCase = DefaultPopularPodcastUseCase(provider: MoyaProvider<ItunesAPI>())
    let searchContentsUseCase = DefaultSearchUseCase(provider: MoyaProvider<ItunesAPI>())
    let reactor = MoviePodcastReactor(popularMoviesUseCase: popularMoviesUseCase, popularPodcastsUseCase: popularPodcastsUseCase, searchContentsUseCase: searchContentsUseCase)

    return MoviePodcastViewCotroller(reactor: reactor)
}
