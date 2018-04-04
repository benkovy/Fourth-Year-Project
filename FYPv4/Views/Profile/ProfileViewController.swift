//
//  ProfileViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, CanSwitchTabBarViewControllers, CollectionViewDelegatable {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var profilePicContainer: UIView!
    @IBOutlet weak var profileImageMask: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var userDescription: UITextView!
    
    var content: [WebWorkout] = []
    var images: [UIImage?] = []
    
    let webservice: WebService
    var user: User
    
    init(user: User, webService: WebService) {
        self.user = user
        self.webservice = webService
        super.init(nibName: ProfileViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureViews()
        delegateCollectionView()
        collectionView.alwaysBounceVertical = true
        collectionView.register(HomeCollectionViewCell.self)
        let barButtonRight = UIBarButtonItem(image: #imageLiteral(resourceName: "menu"), style: .plain, target: self, action: #selector(handleUserMenu))
        self.navigationItem.setRightBarButton(barButtonRight, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.configureUI(.regularWhite)
        self.getUserContent()
    }
    
    func getUserContent() {
        guard let token = user.token else { return }
        webservice.load(User.userCreatedWorkouts(token: token), completion: { res in
            guard let result = res else { return }
            switch result {
            case .error(_):
                print("There was an error")
            case .success(let workouts):
                self.content = workouts
                self.images = self.imagesForWorkouts(workouts: workouts)
                self.collectionView.reloadData()
            }
        })
    }
}

extension ProfileViewController {
    
    func configureViews() {
        profilePicContainer.layer.applySketchShadow(color: .black, alpha: 0.15, x: -2, y: 9, blur: 22, spread: 0)
        profilePicContainer.roundCorners(by: 15)
        if let img = user.image, let data = Data(base64Encoded: img), let image = UIImage(data: data) {
            profileImageView.image = image
        } else {
            profileImageView.image = UIImage(named: "t4")
        }
        profileImageView.contentMode = .scaleAspectFill
        profileImageMask.roundCorners(by: 15)
        nameLabel.text = user.fullName
        nameLabel.setFontTo(style: .title)
        userDescription.setFontTo(style: .paragraph)
        userDescription.text = user.description
    }
    
    @objc func handleUserMenu() {
        let vc = ProfileMenuViewController(user: user)
        vc.didLogout = {
            UserDefaultsStore.delete(withKey: User.self)
            UserDefaultsStore.delete(withKey: Routine.self)
            self.switchTo(tabBarState: .noUser)
        }
        
        vc.didUpdateUser = {
            guard let user = UserDefaultsStore.retrieve(User.self) else {
                return
            }
            self.user = user
            self.configureViews()
        }
        navigationController?.pushViewController(vc, animated: true)
        
    }
}

extension ProfileViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return content.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: HomeCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.configureCellWithMovements(workout: content[indexPath.row], image: images[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 170)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width, height: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = WorkoutDetailView(workout: content[indexPath.row], canAdd: false, day: 0, image: self.images[indexPath.row])
        navigationController?.present(vc, animated: true, completion: nil)
    }
}
