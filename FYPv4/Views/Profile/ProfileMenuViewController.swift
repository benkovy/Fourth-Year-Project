//
//  ProfileMenuViewController.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-04-03.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import UIKit

class ProfileMenuViewController: UIViewController, TableViewDelegatable {

    let webservice = WebService()
    var didLogout: (() -> ())?
    var didUpdateUser: (() -> ())?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageView: UIImageView!
    var imagePicker: UIImagePickerController!
    var fn: String?
    var ln: String?
    var bio: String?
    let user: User
    var imageDidChange = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegateTableView()
        self.hideKeyboard()
        tableView.register(InputTableViewCell.self)
        showImage()
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        let button = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImageFirst))
        navigationItem.setRightBarButton(button, animated: true)
    }
    
    init(user: User) {
        self.user = user
        super.init(nibName: ProfileMenuViewController.nibName, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func showImage() {
        imageView.roundCorners(by: 15)
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        if let imgString = user.image, let data = Data(base64Encoded: imgString) {
            self.imageView.image = UIImage(data: data)
        } else {
            self.imageView.image = UIImage(named: "t1")
        }
        
    }
    
    func nameFor(indexPath: IndexPath) -> String {
        switch indexPath.row {
        case 0: return "First Name"
        case 1: return "Last Name"
        case 2: return "Bio"
        case 3: return "Image"
        default: return ""
        }
    }
}

extension ProfileMenuViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleImagePicker() {
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
            imageDidChange = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileMenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.row {
        case 0, 1:
            let cell: InputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.textView.textColor = .black
            if indexPath.row == 0 { // First Name
                cell.textView.text = user.firstname
                cell.didFinishEditing = { result in
                    if !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if result != "First Name" {
                            self.fn = result
                        }
                    }
                }
            } else if indexPath.row == 1 { // First Name
                cell.textView.text = user.lastname
                cell.didFinishEditing = { result in
                    if !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                        if result != "Last Name" {
                            self.ln = result
                        }
                    }
                }
            }
            cell.didRequestPlaceholder = { return self.nameFor(indexPath: indexPath)}
            cell.textView.textContainer.maximumNumberOfLines = 1
            cell.textView.textContainer.lineBreakMode = .byTruncatingTail
            return cell
        case 2:
            let cell: InputTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.textView.text = user.description
            cell.textView.textColor = .black
            cell.didFinishEditing = { result in
                if !result.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    if result != "Bio" {
                        self.bio = result
                    }
                }
            }
            cell.didRequestPlaceholder = { return self.nameFor(indexPath: indexPath)}
            cell.textView.textContainer.maximumNumberOfLines = 2
            cell.textView.textContainer.lineBreakMode = .byTruncatingTail
            return cell
        case 3:
            let cell2 = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell2.textLabel?.text = nameFor(indexPath: indexPath)
            cell2.detailTextLabel?.text = "Choose"
            return cell2
        case 4:
            let cell2 = UITableViewCell(style: .value1, reuseIdentifier: nil)
            cell2.textLabel?.text = "Logout"
            cell2.textLabel?.textColor = .red
            return cell2
        default:
            let def = UITableViewCell(style: .value1, reuseIdentifier: nil)
            return def
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 2:
            return 64
        default:
            return 44
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 3 {
            present(imagePicker, animated: true)
        } else if indexPath.row == 4 {
            print("Logout")
            navigationController?.popViewController(animated: true)
            didLogout?()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    @objc func saveImageFirst() {
        self.view.endEditing(true)
        navigationItem.rightBarButtonItem?.isEnabled = false
        if imageDidChange {
            if let img = self.imageView.image, let id = user.id {
                webservice.postProfileImage(image: img, forUserID: id, completion: { data in
                    DispatchQueue.main.async {
                        self.handleSave()
                    }
                })
            }
        } else {
            handleSave()
        }
    }
    
    func handleSave() {
        guard let oldUser = UserDefaultsStore.retrieve(User.self) else { return }
        var img: String?
        if let image = self.imageView.image {
            img = UIImageJPEGRepresentation(image, 1)?.base64EncodedString()
        }
        
        let user = User(firstname: self.fn ?? oldUser.firstname,
                        lastname: self.ln ?? oldUser.lastname,
                        email: oldUser.email,
                        password: oldUser.password,
                        description: self.bio ?? oldUser.description,
                        dateofbirth: oldUser.dateofbirth,
                        type: oldUser.type,
                        id: oldUser.id,
                        token: oldUser.token,
                        image: img)
        
        guard let id = user.id else { return }
        webservice.load(User.updateUser(user: user, id: id), completion: { res in
            guard let result = res else { return }
            switch result {
            case .error(_):
                print("Error: Update profile failed")
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            case .success(var user):
                DispatchQueue.main.async {
                    self.navigationItem.rightBarButtonItem?.isEnabled = true
                    user.token = self.user.token
                    UserDefaultsStore.store(persistables: user)
                    self.didUpdateUser?()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        })
    }
}
