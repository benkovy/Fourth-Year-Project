//
//  RoutineTableViewCell.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-03-07.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class RoutineTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionviewOffset: CGFloat {
        get {
            return collectionView.contentOffset.x
        }
        
        set {
            collectionView.contentOffset.x = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(HomeCollectionViewCell.self)
        collectionView.showsHorizontalScrollIndicator = false
        self.layer.masksToBounds = false
        self.clipsToBounds = false
        self.collectionView.layer.masksToBounds = false
        self.collectionView.clipsToBounds = false
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension RoutineTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(dataSourceDelegate: D, forRow row: Int) {
        collectionView.delegate = dataSourceDelegate
        collectionView.dataSource = dataSourceDelegate
        collectionView.tag = row
        collectionView.reloadData()
    }
}
