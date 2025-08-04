//
//  MoviePodcastView.swift
//  PineApple
//
//  Created by seongjun cho on 8/3/25.
//

import UIKit

import SnapKit
import Then

class MoviePodcastView: UIView {

    // MARK: - 프로퍼티
    let titleLabel = UILabel().then {
        $0.text = "영화, 팟캐스트"
        $0.font = .systemFont(ofSize: 40, weight: .bold)
    }

    let backButton = UIButton().then {
        $0.setImage(UIImage(systemName: "arrow.left", withConfiguration: UIImage.SymbolConfiguration(pointSize: 24)), for: .normal)
        $0.tintColor = .label
    }

    let searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
    }

    lazy var moviePodcastCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeMoviePodcastCollectionViewLayout()
    )

    lazy var searchListCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: makeSearchListCollectionViewLayout()
    ).then {
        $0.isHidden = true
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        backgroundColor = .systemBackground

        addSubview(titleLabel)
        addSubview(backButton)
        addSubview(searchBar)
        addSubview(moviePodcastCollectionView)
        addSubview(searchListCollectionView)

        titleLabel.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.equalTo(backButton.snp.trailing).offset(8)
            $0.trailing.equalTo(self.safeAreaLayoutGuide).inset(16)
        }

        backButton.snp.makeConstraints {
            $0.centerY.equalTo(searchBar)
            $0.leading.equalTo(self.safeAreaLayoutGuide).offset(16)
        }

        moviePodcastCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.bottom.equalToSuperview()
        }

        searchListCollectionView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(12)
            $0.leading.trailing.equalTo(self.safeAreaLayoutGuide).offset(16)
            $0.bottom.equalToSuperview()
        }
    }

    func makeMoviePodcastCollectionViewLayout() -> UICollectionViewCompositionalLayout {
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
                    layoutSize: .init(widthDimension: .fractionalWidth(0.9),
                                      heightDimension: .absolute(160)))
                let group = NSCollectionLayoutGroup.horizontal(
                    layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .absolute(160)),
                    subitems: [item])
                let section = NSCollectionLayoutSection(group: group)
                section.boundarySupplementaryItems = [header]
                section.orthogonalScrollingBehavior = .groupPaging
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

    func makeSearchListCollectionViewLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                              heightDimension: .absolute(60))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}
