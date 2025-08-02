//
//  MusicViewController.swift
//  PineApple
//
//  Created by seongjun cho on 8/1/25.
//

import UIKit

import RxSwift
import RxCocoa
import ReactorKit
import Moya

final class MusicViewController: UIViewController, View {

    enum MusicItem: Hashable {
        case popular(Song)
        case season(Content)
    }

    // MARK: - properties
    var disposeBag = DisposeBag()
    let musicView = MusicView()
    private lazy var dataSource = makeCollectionViewDataSource(musicView.musicCollectionView)
    let musicReactor: MusicReactor

    // MARK: - init

    init(musicReactor: MusicReactor) {
        self.musicReactor = musicReactor
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - lifeCycle

    override func loadView() {
        view = musicView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        bind(reactor: musicReactor)
        musicReactor.action.onNext(.fetchPopularSongs)
        musicReactor.action.onNext(.fetchSeasonSongs(.spring))
        musicReactor.action.onNext(.fetchSeasonSongs(.summer))
        musicReactor.action.onNext(.fetchSeasonSongs(.autumn))
        musicReactor.action.onNext(.fetchSeasonSongs(.winter))
    }

    // MARK: - method

    private func makeCollectionViewDataSource(
        _ collectionView: UICollectionView) -> UICollectionViewDiffableDataSource<Int, MusicItem> {

            // 인기 노래 셀 설정
            let popularCellRegistration = UICollectionView.CellRegistration<PopularSongCell, Song> { cell, _, item in
                cell.configure(song: item)
            }

            // 계절 별 노래 설정
            let seasonCellRegistration = UICollectionView.CellRegistration<HorizonCell, Content> { cell, _, item in
                cell.confugureContetns(content: item)
            }

            // 해더 이름 설정
            let headerRegistration = UICollectionView.SupplementaryRegistration<SectionHeaderView>(elementKind: UICollectionView.elementKindSectionHeader) { (supplementaryView, string, indexPath) in
                switch indexPath.section {
                case 0:
                    supplementaryView.configure(with: "인기 노래")
                case 1:
                    supplementaryView.configure(with: "봄에 어울리는 노래")
                case 2:
                    supplementaryView.configure(with: "여름에 어울리는 노래")
                case 3:
                    supplementaryView.configure(with: "가을에 어울리는 노래")
                case 4:
                    supplementaryView.configure(with: "겨울에 어울리는 노래")
                default:
                    supplementaryView.configure(with: "노래 목록")
                }
            }

            // 아이템별 데이터 소스 등록
            let dataSource = UICollectionViewDiffableDataSource<Int, MusicItem>(
                collectionView: collectionView) { collectionView, indexPath, item in

                switch item {
                case .popular(let song):
                    return collectionView
                        .dequeueConfiguredReusableCell(
                            using: popularCellRegistration,
                            for: indexPath,
                            item: song
                        )
                case .season(let song):
                    return collectionView
                        .dequeueConfiguredReusableCell(
                            using: seasonCellRegistration,
                            for: indexPath,
                            item: song
                        )
                }
            }

            // 헤더 뷰 등록
            dataSource.supplementaryViewProvider = { (view, kind, index) in
                return view.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: index)
            }
            
            return dataSource
        }

    func bind(reactor: MusicReactor) {
        reactor
            .state
            .bind { [dataSource] item in
                var snapshot = NSDiffableDataSourceSnapshot<Int, MusicItem>()
                snapshot.appendSections([0, 1, 2, 3, 4])
                snapshot.appendItems(item.popularSongs.map { .popular($0) }, toSection: 0)
                snapshot.appendItems(item.springSongs.map { .season($0) }, toSection: 1)
                snapshot.appendItems(item.summerSongs.map { .season($0) }, toSection: 2)
                snapshot.appendItems(item.atumnSongs.map { .season($0) }, toSection: 3)
                snapshot.appendItems(item.winterSongs.map { .season($0) }, toSection: 4)

                dataSource.apply(snapshot, animatingDifferences: true)
            }
            .disposed(by: disposeBag)
    }
}

@available(iOS 18.0, *)
#Preview {
    let popularUsecase = DefaultPopularSongsUseCase(provider: MoyaProvider<ItunesAPI>())
    let searchUseCase = DefaultSearchUseCase(provider: MoyaProvider<ItunesAPI>())
    let reactor = MusicReactor(popularSongsUseCase: popularUsecase, searchSongsUseCase: searchUseCase)

    MusicViewController(musicReactor: reactor)
}
