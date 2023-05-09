//
//  CarouselViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit
import Combine

final class CarouselViewController: UIViewController {
    private let cellWidth: CGFloat = 200
    
    private lazy var carouselCollectionView: UICollectionView = {
        let layout = CarouselFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
        
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.layer.masksToBounds = false
        collectionView.backgroundColor = UIColor.mainGray
        view.addSubview(collectionView)
        return collectionView
    }()
    
    private lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl(frame: .zero)
        pageControl.currentPage = 0
        pageControl.backgroundStyle = .minimal
        pageControl.pageIndicatorTintColor = UIColor.secondaryGray
        pageControl.transform = CGAffineTransform(scaleX: 0.6, y: 0.6)
        pageControl.currentPageIndicatorTintColor = UIColor.black
        view.addSubview(pageControl)
        return pageControl
    }()
    
    private var data = [CarouselMoviePresentable]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupCollectionViewConstraints()
        setupPageControlConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    func configure(with newData: [CarouselMoviePresentable]) {
        guard !newData.isEmpty else { return }
        data = newData
        pageControl.numberOfPages = newData.count
        carouselCollectionView.reloadData()
    }
}

// MARK: - private

private extension CarouselViewController {
    func setupCollectionViewConstraints() {
        carouselCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            carouselCollectionView.topAnchor.constraint(equalTo: view.topAnchor),
            carouselCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            carouselCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            carouselCollectionView.bottomAnchor.constraint(equalTo: pageControl.topAnchor)
        ])
    }
    
    func setupPageControlConstraints() {
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
    }
    
    func updateCurrentPage(_ page: Int) {
        pageControl.currentPage = page
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource

extension CarouselViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CarouselCell.identifier,
                                                            for: indexPath) as? CarouselCell else {
            return UICollectionViewCell()
        }
        
        let movieData = data[indexPath.row]
        let image = movieData.image ?? UIImage(systemName: "trash") ?? UIImage()
        cell.configure(image: image, title: movieData.title, genres: movieData.genres, score: movieData.score)
        cell.layer.setDefaultShadow()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CarouselCell else {
            return
        }
        
        cell.onSelect()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let center = view.convert(carouselCollectionView.center, to: carouselCollectionView)
        guard let indexPath = carouselCollectionView.indexPathForItem(at: center) else { return }
        
        if indexPath.row != pageControl.currentPage {
            updateCurrentPage(indexPath.row)
        }
    }
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth * 1.5)
    }
}
