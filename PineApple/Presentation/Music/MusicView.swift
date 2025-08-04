//
//  MusicView.swift
//  PineApple
//
//  Created by seongjun cho on 8/1/25.
//

import UIKit

import SnapKit
import Then

class MusicView: UIView {

    // MARK: - 프로퍼티
    let titleLabel = UILabel().then {
        $0.text = "음악"
        $0.font = .systemFont(ofSize: 40, weight: .bold)
    }

    let searchBar = UISearchBar().then {
        $0.placeholder = "영화, 팟캐스트 검색"
        $0.searchBarStyle = .minimal
    }

    lazy var musicCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeCollectionViewLayout()
    )

    // MARK: - init

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        [titleLabel, searchBar, musicCollectionView].forEach {
            self.addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }

        musicCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.bottom.equalToSuperview()
        }
    }

    // MARK: - method

    func makeCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(44)
        )
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )

        return UICollectionViewCompositionalLayout { (sectionIndex, env) -> NSCollectionLayoutSection? in

            switch sectionIndex {
            case 0:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .absolute(150),
                                      heightDimension: .absolute(195)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .absolute(150),
                                      heightDimension: .absolute(195)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .continuous
                section.interGroupSpacing = 12
                section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)

                return section
            default:
                let item = NSCollectionLayoutItem(
                    layoutSize: .init(widthDimension: .fractionalWidth(0.95),
                                      heightDimension: .absolute(60)))

                let pageGroup = NSCollectionLayoutGroup
                    .vertical(
                        layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                          heightDimension: .absolute(60 * 3 + 8 * 2)),
                        subitems: [item, item, item])

                pageGroup.interItemSpacing = .fixed(8)

                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(60 * 3 + 8 * 2)),
                    subitems: [pageGroup])

                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .groupPaging
                section.contentInsets = .init(top: 16, leading: 0, bottom: 16, trailing: 0)

                return section
            }
        }
    }
}
