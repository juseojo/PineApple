//
//  SectionHeaderView.swift
//  PineApple
//
//  Created by seongjun cho on 8/2/25.
//

import UIKit
import SnapKit

class SectionHeaderView: UICollectionReusableView {
    let titleLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
    }

    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 20, weight: .bold)
        titleLabel.textColor = .label

        titleLabel.snp.makeConstraints {
            $0.directionalEdges.equalToSuperview()
        }
    }

    func configure(with title: String) {
        titleLabel.text = title
        if title == "인기 노래" {
            titleLabel.font = .systemFont(ofSize: 32, weight: .bold)
        }
    }
}
