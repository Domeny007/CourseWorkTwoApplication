//
//  NewsCommentsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 28/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class NewsCommentsViewController: UIViewController, UITabBarDelegate, UITableViewDataSource {
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var userSurenameLabel: UILabel!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var newsTagsLabel: UILabel!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var answerButton: UIButton!
    
    var commentsArray = [Comment]()
    var newComment:Comment = Comment()
    var cellId:Int = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getComments()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
        
        @objc func keyboardWillShow(notification: NSNotification) {
            if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
                if self.view.frame.origin.y == 0 {
                    self.view.frame.origin.y -= keyboardSize.height
                }
            }
        }
        
        @objc func keyboardWillHide(notification: NSNotification) {
            if self.view.frame.origin.y != 0 {
                self.view.frame.origin.y = 0
            }
        }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return commentsArray.count
    }
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        guard let commentText = commentTextField.text else { return }
        let commnentObject = commentText as AnyObject
        
        let paramener = ["text":commnentObject]
        let newsId = UserDefaults.standard.integer(forKey: "\(cellId)news")
        guard let url = URL(string: BASE_URL + "/api/news/\(newsId)/add-comment"),
              let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: paramener, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            if let responce = responce {
                print(responce)
            }
            if let data = data {
                do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
            }
                catch {
                    print(error)
                }
            }
            if let error = error {
                print(error)
            }
            DispatchQueue.main.async {
                self.commentTextField.text = ""
                self.commentsArray.removeAll()
                self.getComments()
            }
        }.resume()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
        cell.authorNameLabel.text = commentsArray[indexPath.row].ownerName
        cell.authorSurenameLabel.text = commentsArray[indexPath.row].ownerSurename
        cell.authorDataLabel.text = commentsArray[indexPath.row].date
        cell.commentsTextView.text = commentsArray[indexPath.row].text
        cell.authorImageView.image = commentsArray[indexPath.row].ownerImage
        cell.answerButton.isHidden = false
        return cell
    }

    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func getComments() {
        let newsId = UserDefaults.standard.integer(forKey: "\(cellId)news")
        guard let url = URL(string: BASE_URL + "/api/news/\(newsId)")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            if let responce = responce {
                print(responce)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    guard let dictionary = json as? Dictionary<String,Any> else { return }
                    print(dictionary)
                    for (key,value) in dictionary {
                        if (key == "text") {
                            DispatchQueue.main.async {
                                self.newsTextView.text = value as? String
                            }
                        }
                        if (key == "author") {
                            if let authorDict = value as? Dictionary<String,Any> {
                                for (key,value) in authorDict {
                                    if (key == "first_name") {
                                        DispatchQueue.main.async {
                                            self.userNameLabel.text = value as? String
                                        }
                                    }
                                    if (key == "last_name") {
                                        DispatchQueue.main.async {
                                            self.userSurenameLabel.text = value as? String
                                        }
                                    }
                                    
                                }
                            }
                        }
                        if (key == "comments") {
                            if let tempArray = value as? NSArray {
                                for i in 0..<tempArray.count {
                                    if let commentDict = tempArray[i] as? Dictionary<String,Any>{
                                        for (key,value) in commentDict {
                                            if (key == "text") {
                                                self.newComment.text = value as? String
                                            }
                                            if (key == "author") {
                                                if let commentAuthorDict = value as? Dictionary<String,Any> {
                                                    for (key,value) in commentAuthorDict {
                                                        if (key == "first_name") {
                                                            self.newComment.ownerName = value as? String
                                                        }
                                                        if (key == "last_name") {
                                                            self.newComment.ownerSurename = value as? String
                                                        }
                                                        
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    self.commentsArray.append(self.newComment)
                                    self.newComment = Comment()
                                }
                                
                            }
                        }
                    }
                } catch {
                    print(error)
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }.resume()
    }
    
}
