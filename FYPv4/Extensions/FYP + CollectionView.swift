//
//  FYP + CollectionView.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-06.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionView {
    func sizeCell(forImage image: UIImage) -> CGSize {
        
        let itemWidth = self.bounds.width
        let imageView = UIImageView()
        var ratio: CGFloat = 1.0
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit
        
        guard let iWidth = imageView.image?.size.width else {
            fatalError("This should never happen wtf")
        }
        
        guard let iHeight = imageView.image?.size.height else {
            fatalError("This should never happen :)")
        }
        
        if iWidth >  itemWidth {
            ratio = iWidth / itemWidth
        } else {
            ratio = itemWidth / iWidth
        }
        
        let height = (iHeight * ratio) + 80
        return CGSize(width: itemWidth, height: height)
    }
}
