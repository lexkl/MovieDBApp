//
//  CarouselCell.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit

final class CarouselCell: UICollectionViewCell {
    
    // MARK: - views
    
    lazy var shadowImageView: ShadowImageView = {
        return ShadowImageView(frame: .zero)
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.secondaryGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    // MARK: - init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    // MARK: - lifecycle
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        shadowImageView.setImage(image: nil)
        titleLabel.text = ""
        genresLabel.text = ""
    }
    
    // MARK: - public functions
    
    func configure(image: UIImage, title: String, genres: String, score: String) {
        shadowImageView.setImage(image: image)
        titleLabel.text = title
        genresLabel.text = genres
    }
}

// MARK: - private

private extension CarouselCell {
    func setupUI() {
        contentView.addSubview(shadowImageView)
        contentView.addSubview(titleLabel)
        
        shadowImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            shadowImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            shadowImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            shadowImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, genresLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .center

        contentView.addSubview(verticalStack)
        verticalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            verticalStack.topAnchor.constraint(equalTo: shadowImageView.bottomAnchor, constant: 60),
            verticalStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            verticalStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            verticalStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true

        genresLabel.translatesAutoresizingMaskIntoConstraints = false
        genresLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
