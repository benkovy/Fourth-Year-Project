//
//  HomeViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-18.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, CollectionViewDelegatable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    let webservice: WebService
    var refreshControl: UIRefreshControl
    
    var content: [Workout] = []
    
    init(webservice: WebService) {
        self.webservice = webservice
        self.refreshControl = UIRefreshControl()
        super.init(nibName: HomeViewController.nibName, bundle: nil)
        self.refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        self.refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(.homeStyle)
        self.delegateCollectionView()
        collectionView.register(HomeCollectionViewCell.self)
        self.collectionView.addSubview(refreshControl)
        requestContent()
    }
    
    @objc func refresh(sender: AnyObject) {
        requestContent()
        refreshControl.endRefreshing()
        
    }
    
    func requestContent() {
        webservice.load(Workout.createWorkoutRequest()) { (result) in
            guard let result = result else { return }
            switch result {
            case .error(let error):
                print(error)
            case .success(let workouts):
                self.content = workouts.reversed()
                DispatchQueue.main.async {
                    self.updateContent()
                }
            }
        }
    }
    
    func updateContent() {
        collectionView.reloadData()
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCell(workout: content[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.sizeCell(forImage: #imageLiteral(resourceName: "ImageDefault"))
    }
}
