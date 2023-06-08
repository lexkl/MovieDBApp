//
//  ShadowImageView.swift
//  MovieDBApp
//
//  Created by Aleksey Klyonov on 28.05.2023.
//

import Foundation
import UIKit

class ShadowImageView: UIView {
    let imageView = UIImageView(image: nil)
    private let cornerRadius: CGFloat = 10.0
  
    override init(frame: CGRect) {
        super.init(frame: frame)

        layoutView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(image: UIImage?) {
        imageView.image = image
    }

    private func layoutView() {
        layer.backgroundColor = UIColor.clear.cgColor
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 20)
        layer.shadowOpacity = 0.8
        layer.shadowRadius = 40.0
        
        imageView.layer.cornerRadius = cornerRadius
        imageView.layer.masksToBounds = true
        
        addSubview(imageView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}
