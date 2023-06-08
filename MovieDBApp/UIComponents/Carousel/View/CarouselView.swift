//
//  CarouselView.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 01.06.2023.
//

import Foundation
import UIKit

final class CarouselView: UIView {
    
    lazy var carouselCollectionView: UICollectionView = {
        let layout = CarouselFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false
        collectionView.backgroundColor = UIColor.mainGray
        addSubview(collectionView)
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.currentPage = 0
        pageControl.backgroundStyle = .minimal
        pageControl.pageIndicatorTintColor = UIColor.secondaryGray
        pageControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        pageControl.currentPageIndicatorTintColor = UIColor.black
        addSubview(pageControl)
        return pageControl
    }()
    
    init() {
        super.init(frame: .zero)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    private func setup() {
        setupCollectionViewConstraints()
        setupPageControlConstraints()
    }
}

// MARK: - private

private extension CarouselView {
    func setupCollectionViewConstraints() {
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            carouselCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor)
        ])
    }
    
    func setupPageControlConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50)
        ])
    }
}
