//
//  CarouselViewController.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit
import Combine

final class CarouselViewController: MVVMGenericViewController<CarouselViewModel, CarouselView> {
    private let cellWidth: CGFloat = 200
    
    private var data = [CarouselMoviePresentable]()
    
    var currentCell: CarouselCell?
    
    override func bindUI() {
        rootView.carouselCollectionView.delegate = self
        rootView.carouselCollectionView.dataSource = self
        rootView.carouselCollectionView.register(CarouselCell.self, forCellWithReuseIdentifier: CarouselCell.identifier)
    }
    
    func configure(with newData: [CarouselMoviePresentable]) {
        guard !newData.isEmpty else { return }
        data = newData
        rootView.pageControl.numberOfPages = newData.count
        rootView.carouselCollectionView.reloadData()
    }
}

// MARK: - private

private extension CarouselViewController {
    func updateCurrentPage(_ page: Int) {
        rootView.pageControl.currentPage = page
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
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = (collectionView.frame.width - cellWidth) / 2
        return UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CarouselCell,
              let image = cell.shadowImageView.imageView.image else {
            return
        }
        
        let movieId = data[indexPath.item].movieId
        
        currentCell = cell
        viewModel.selectMovie(image: image, movieId: movieId)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let collectionViewCenter = view.convert(rootView.carouselCollectionView.center,
                                                to: rootView.carouselCollectionView)
        guard let indexPath = rootView.carouselCollectionView.indexPathForItem(at: collectionViewCenter) else { return }
        
        if indexPath.row != rootView.pageControl.currentPage {
            updateCurrentPage(indexPath.row)
        }
    }
}

extension CarouselViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: cellWidth, height: cellWidth * 2)
    }
}
