//
//  CarouselFlowLayout.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 08.05.2023.
//

import Foundation
import UIKit

final class CarouselFlowLayout: UICollectionViewFlowLayout {
    private let activeDistance: CGFloat = 200
    private let scaleFactor: CGFloat = 0.1
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 60
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let collectionView = collectionView,
              let superAttributes = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        
        let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
        let attributes = superAttributes.compactMap { $0.copy() as? UICollectionViewLayoutAttributes }
        
        attributes.forEach { layoutAttribute in
            let distance = visibleRect.midX - layoutAttribute.center.x
            let normalizedDistance = distance / activeDistance
            let zoom = 1 + scaleFactor * (1 - abs(normalizedDistance))
            let transform = CATransform3DMakeScale(zoom, zoom, 1)
            layoutAttribute.transform3D = transform
            
            let alpha = (1 - abs(normalizedDistance)) * 0.5 + 0.5
            layoutAttribute.alpha = alpha
        }
        
        return attributes
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint,
                                      withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offset = proposedContentOffset
        guard let collectionView = collectionView else { return offset }
        let centerX = offset.x + collectionView.bounds.width / 2
        if let closestAttrs = super.layoutAttributesForElements(in: collectionView.bounds)?.min(by: {
            abs($0.center.x - centerX) < abs($1.center.x - centerX)
        }) {
            offset.x = closestAttrs.center.x - collectionView.bounds.width / 2
        }
        return offset
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
