//
//  CollectionViewDelegatable.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-06.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

protocol CollectionViewDelegatable {
    var collectionView: UICollectionView! { get set }
}

extension CollectionViewDelegatable where Self: UICollectionViewDataSource & UICollectionViewDelegate {
    func delegateCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func layoutCollectionView() {
        
    }
}
