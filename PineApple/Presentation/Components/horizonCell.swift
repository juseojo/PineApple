//
//  horizonCell.swift
//  PineApple
//
//  Created by seongjun cho on 8/2/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

final class HorizonCell: UICollectionViewCell {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }

    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .bold)
        $0.textColor = .label
    }

    let subLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .secondaryLabel
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        addSubview(imageView)
        addSubview(titleLabel)
        addSubview(subLabel)

        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(imageView.snp.height)
        }

        titleLabel.snp.makeConstraints {
            $0.top.trailing.equalToSuperview().inset(8)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
        }

        subLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalTo(titleLabel)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureSong(song: Song) {
        imageView.kf.setImage(with: URL(string: song.artworkUrl600))
        titleLabel.text = song.name
        subLabel.text = song.artistName
    }

    func configurePodcast(podcast: Podcast) {
        imageView.kf.setImage(with: URL(string: podcast.artworkUrl600))
        titleLabel.text = podcast.name
        subLabel.text = podcast.artistName
    }

    func confugureContetns(content: Content) {
        imageView.kf.setImage(with: URL(string: content.artworkUrl600))
        titleLabel.text = content.trackName
        subLabel.text = content.artistName
    }
}
