//
//  CarouselCell.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit

final class CarouselCell: UICollectionViewCell {
    
    private(set) var isExpanded = false
    private let cornerRadius = 10.0
    
    // MARK: - views
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView(image: nil)
        view.contentMode = .scaleAspectFit
        view.clipsToBounds = true
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    
    private lazy var imageViewContainer: UIView = {
        let view = UIView(frame: .zero)
        view.layer.masksToBounds = false
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 14, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var genresLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 10, weight: .regular)
        label.textColor = UIColor.secondaryGray
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    private lazy var detailsView: UIView = {
        let view = UIView(frame: .zero)
        view.backgroundColor = .white
        view.layer.cornerRadius = cornerRadius
        return view
    }()
    
    // MARK: - animated constraints
    
    private lazy var imageViewContainerTopConstraint =
        imageViewContainer.topAnchor.constraint(equalTo: contentView.topAnchor)
    private lazy var imageViewContainerBottomConstraint =
        imageViewContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    private lazy var detailsViewTopConstraint =
        detailsView.topAnchor.constraint(equalTo: contentView.topAnchor)
    private lazy var detailsViewLeadingConstraint =
        detailsView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
    private lazy var detailsViewTrailingConstraint =
        detailsView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
    private lazy var detailsViewBottomConstraint =
        detailsView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
    
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
        
        imageView.image = nil
        titleLabel.text = ""
        genresLabel.text = ""
    }
    
    // MARK: - public functions
    
    func configure(image: UIImage, title: String, genres: String, score: String) {
        imageView.image = image
        titleLabel.text = title
        genresLabel.text = "Genres: \(genres)"
        scoreLabel.text = score
    }
    
    func onSelect() {
        if !isExpanded {
            imageViewContainerTopConstraint.constant = -30
            imageViewContainerBottomConstraint.constant = -30
            detailsViewTopConstraint.constant = 20
            detailsViewBottomConstraint.constant = titleLabel.bounds.height + genresLabel.bounds.height
            detailsViewLeadingConstraint.constant = -30
            detailsViewTrailingConstraint.constant = 30
        } else {
            imageViewContainerTopConstraint.constant = 0
            imageViewContainerBottomConstraint.constant = 0
            detailsViewBottomConstraint.constant = 0
            detailsViewLeadingConstraint.constant = 0
            detailsViewTrailingConstraint.constant = 0
        }
        
        isExpanded.toggle()
        setShadow()
        
        UIView.animate(withDuration: 0.4) {
            self.contentView.layoutIfNeeded()
        }
    }
}

// MARK: - private

private extension CarouselCell {
    func setShadow() {
        imageViewContainer.layer.setDefaultShadow()
        imageViewContainer.layer.shadowOpacity = isExpanded ? 0.3 : 0
    }
    
    func setupUI() {
        contentView.addSubview(detailsView)
        contentView.addSubview(imageViewContainer)
        imageViewContainer.addSubview(imageView)
        
        imageViewContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageViewContainerTopConstraint,
            imageViewContainerBottomConstraint,
            imageViewContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageViewContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: imageViewContainer.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageViewContainer.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageViewContainer.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageViewContainer.trailingAnchor)
        ])
        
        detailsView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            detailsViewTopConstraint,
            detailsViewLeadingConstraint,
            detailsViewTrailingConstraint,
            detailsViewBottomConstraint
        ])
        
        let verticalStack = UIStackView(arrangedSubviews: [titleLabel, genresLabel])
        verticalStack.axis = .vertical
        verticalStack.alignment = .leading
        verticalStack.distribution = .fillEqually
        
        let horizontalStack = UIStackView(arrangedSubviews: [verticalStack, scoreLabel])
        detailsView.addSubview(horizontalStack)
        horizontalStack.axis = .horizontal
        horizontalStack.alignment = .center
        horizontalStack.distribution = .fill
        
        verticalStack.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.8).isActive = true
        scoreLabel.widthAnchor.constraint(equalTo: horizontalStack.widthAnchor, multiplier: 0.2).isActive = true
        
        horizontalStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            horizontalStack.heightAnchor.constraint(equalToConstant: 70),
            horizontalStack.leadingAnchor.constraint(equalTo: detailsView.leadingAnchor, constant: 10.0),
            horizontalStack.trailingAnchor.constraint(equalTo: detailsView.trailingAnchor, constant: -10.0),
            horizontalStack.bottomAnchor.constraint(equalTo: detailsView.bottomAnchor, constant: -10.0)
        ])
    }
}
