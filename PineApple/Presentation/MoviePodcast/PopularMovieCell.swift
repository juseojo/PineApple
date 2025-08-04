//
//  PopularMovieCell.swift
//  PineApple
//
//  Created by seongjun cho on 8/4/25.
//

import UIKit

import SnapKit
import Then
import Kingfisher

class PopularMovieCell: UICollectionViewCell {
    let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
    }

    let titleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
        $0.textColor = .black
    }

    let genreLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .systemGray
    }

    let releaseDateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .regular)
        $0.textColor = .systemGray
    }

    let amountLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 12, weight: .bold)
        $0.textColor = .systemGray
    }

    let stackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 10
    }

    let spacerView = UIView().then {
        $0.setContentHuggingPriority(.defaultLow, for: .vertical)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor(red: 0.84, green: 0.94, blue: 0.97, alpha: 1)
        self.layer.cornerRadius = 10
        addSubview(imageView)
        addSubview(stackView)

        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(genreLabel)
        stackView.addArrangedSubview(releaseDateLabel)
        stackView.addArrangedSubview(amountLabel)
        stackView.addArrangedSubview(spacerView)


        imageView.snp.makeConstraints {
            $0.top.leading.bottom.equalToSuperview()
            $0.width.equalTo(106)
        }

        stackView.snp.makeConstraints {
            $0.top.trailing.bottom.equalToSuperview().inset(8)
            $0.leading.equalTo(imageView.snp.trailing).offset(8)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(movie: Movie) {
        imageView.kf.setImage(with: movie.highResolutionImageURL)
        titleLabel.text = movie.title.label
        genreLabel.text = movie.category.attributes.label
        releaseDateLabel.text = movie.releaseDate.label
        amountLabel.text = movie.price.label
    }
}
