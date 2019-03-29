//
//  ProfileViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 30/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var changePhotoButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surenameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var changeButton: UIButton!
    
    var user: User?
    var tagsArray = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpFields()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tagsArray.removeAll()
        getInformationAboutUser()
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    func getUnsignedUser() -> User {
        let unsignedUser = User()
        unsignedUser.email = "-"
        unsignedUser.password = "-"
        unsignedUser.name = "-"
        unsignedUser.surename = "-"
        return unsignedUser
    }
    
    func getInformationAboutUser() {
        let authorizedUser = User()
        guard let url = URL(string: BASE_URL + "/auth/get-current-user/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, _, error) in
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
//                    print(json)
                    guard let dictionary = json as? Dictionary<String, Any> else { return }
                    DispatchQueue.main.async {
                        for (key,value) in dictionary {
                            if (key == "first_name") {
                                authorizedUser.name = value as? String
                                self.nameTextField.text = authorizedUser.name
                            }
                            if(key == "last_name") {
                                authorizedUser.surename = value as? String
                                self.surenameTextField.text = authorizedUser.surename
                            }
                            if (key == "email") {
                                authorizedUser.email = value as? String
                                self.emailTextField.text = authorizedUser.email
                            }
                            if (key == "profile") {
                                guard let profileValue = value as? Dictionary<String, Any> else { return }
                                for (key,value) in profileValue {
                                    if (key == "tags") {
                                        guard let tempArray = value as? NSArray else {return}
                                        for tagItem in tempArray {
                                            guard let tagDict = tagItem as? Dictionary<String, Any> else { return }
                                            self.tagsArray.append(tagDict["name"] as! String)
                                        }
                                        }
                                    if (key == "photo_url") {
                                        if let ownerPhotoString = value as? String, let url = URL(string: ownerPhotoString), let data = NSData(contentsOf: url) {
                                            let image = UIImage(data: ((data as Data)))
                                            self.avatarImageView.image = image
                                        }
                                    }
                                }
                                self.tableView.reloadData()
                                }
                                
                            }
                        }
                    
                } catch {
                    print(error)
                }
            }
        }.resume()
    }
    
    func setUpFields() {
        nameTextField.alpha = 0.3
        emailTextField.alpha = 0.3
        surenameTextField.alpha = 0.3
        changePhotoButton.alpha = 0
    }
    @IBAction func changeButtonPressed(_ sender: UIButton) {
        if changeButton.titleLabel?.text == "Изменить" {
            sender.setTitle("Готово", for: [])
            sender.titleLabel?.text = "Готово"
            changePhotoButton.alpha = 1
            emailTextField.isEnabled = true
            emailTextField.isUserInteractionEnabled = true
            nameTextField.isEnabled = true
            nameTextField.isUserInteractionEnabled = true
            surenameTextField.isEnabled = true
            surenameTextField.isUserInteractionEnabled = true
            nameTextField.alpha = 1
            emailTextField.alpha = 1
            surenameTextField.alpha = 1
            tableView.reloadData()
        } else {
            guard let email = emailTextField.text, let name = nameTextField.text, let surename = surenameTextField.text, let photo = avatarImageView.image else { return }
            changeUserInforamtion(with: email, and: name, and: surename)
            changeUsersAvatar(with: photo)
            sender.setTitle("Изменить", for: [])
            sender.titleLabel?.text = "Изменить"
            emailTextField.isEnabled = false
            nameTextField.isEnabled = false
            surenameTextField.isEnabled = false
            nameTextField.alpha = 0.3
            emailTextField.alpha = 0.3
            surenameTextField.alpha = 0.3
            changePhotoButton.alpha = 0
            tableView.reloadData()
        }
    }
    
    func changeUsersAvatar(with photo: UIImage) {
        let avatar = photo
        guard let mediaImage = Media(withImage: avatar, forKey: "image") else { return }
        guard let url = URL(string: BASE_URL + "/auth/get-current-user/change-photo/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        let boundary = generateBoundary()
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        
        let httpBody = createDataBody(withParameters: nil, media: [mediaImage], boundary: boundary)
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            if let responce = responce {
                print(responce)
            }
            
            if let error = error {
                print(error)
            }
            }.resume()
    }
    
    func generateBoundary() -> String{
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters params: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = params {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.fileName)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
                
            }
        }
        body.append("--\(boundary)--\(lineBreak)")
        return body
    }
    
    func changeUserInforamtion(with email: String, and name: String, and surename: String) {
        let parameters = ["email": email,"first_name": name, "last_name": surename]
        guard let url = URL(string: BASE_URL + "/auth/get-current-user/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print(error)
            }
        }.resume()
    }
    
    
    @IBAction func changePhotoButtonPressed(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
   @objc func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[.originalImage] as? UIImage {
            selectedImageFromPicker = editedImage
            
        } else if let originalImage = info[.editedImage] as? UIImage {
            selectedImageFromPicker = originalImage
            
        }
        if let selectedImage = selectedImageFromPicker {
            avatarImageView.image = selectedImage
        }
    
       picker.dismiss(animated: true, completion: nil)
    }
    
    func unsubFromTag(with tagName: String) {
        guard let url = URL(string: BASE_URL + "/api/tags/\(rewriteTagName(with: tagName))/unsub-name") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (_, responce, error) in
            if let responce = responce {
                print(responce)
            }
            }.resume()
    }
    
    func rewriteTagName(with tagString: String) -> String{
        let tagNameForDB = tagString.replacingOccurrences(of: "#", with: "%23")
        print(tagNameForDB)
        return tagNameForDB
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProfileTagsTableViewCell", owner: self, options: nil)?.first as! ProfileTagsTableViewCell
        if (changeButton.titleLabel?.text == "Изменить") {
            cell.alpha = 0.3
            tableView.alpha = 0.3
            cell.backgroundColor = .clear
            cell.isUserInteractionEnabled = false
        } else if (changeButton.titleLabel?.text == "Готово"){
            cell.alpha = 1
            tableView.alpha = 0.8
            cell.isUserInteractionEnabled = true
        }
        cell.tagTextLabel.text = String(describing: tagsArray[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if (changeButton.titleLabel?.text == "Готово") {
            let delete = UITableViewRowAction(style: .destructive, title: "Отписаться") { (action, indexPath) in
                self.unsubFromTag(with: self.tagsArray[indexPath.row] )
                self.tagsArray.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
            }
            return [delete]
        } else {
            return []
        }
    }

}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
        append(data)
            
        }
    }
}
