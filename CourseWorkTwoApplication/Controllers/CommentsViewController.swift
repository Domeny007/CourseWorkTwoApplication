//
//  CommentsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 20/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit



class CommentsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , AnswerProtocol{
    
    @IBOutlet weak var commentsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    var myCommentsArray = [Comment]()
    var newComment:Comment = Comment()
    var myAnswersArray = [Comment]()
    var newAnswer: Comment = Comment()
    
    override func viewDidLoad() {
        super.viewDidLoad()
         fetchMyCommnets()
    }
    
    @IBAction func segmentedViewControllerTapped(_ sender: UISegmentedControl) {
        if commentsSegmentedControl.selectedSegmentIndex == 0 {
            myCommentsArray.removeAll()
            fetchMyCommnets()
        } else {
            myAnswersArray.removeAll()
            fetchAnswersToMyCommments()
        }
    }
    
    
    func loadAnswerWindow() {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let answerVC = storyboard.instantiateViewController(withIdentifier: answerViewControllerIdentifier) as! AnswerViewController
        self.present(answerVC, animated: true, completion: nil)
    }
    
    // working with table view controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if commentsSegmentedControl.selectedSegmentIndex == 0 {
           
            return myCommentsArray.count
        } else {
            
            return myAnswersArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(commentsCellIdentifier, owner: self, options: nil)?.first as! CommentTableViewCell
        cell.answerDelegate = self
        if commentsSegmentedControl.selectedSegmentIndex == 0 {
            cell.answerButton.isHidden = true
            let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
            cell.authorNameLabel.text = myCommentsArray[indexPath.row].ownerName
            cell.authorSurenameLabel.text = myCommentsArray[indexPath.row].ownerSurename
            cell.commentDateLabel.text = myCommentsArray[indexPath.row].date
            cell.commentsTextView.text = myCommentsArray[indexPath.row].text
            cell.commentDateLabel.text = myCommentsArray[indexPath.row].date?.convertDateString()
            if (myCommentsArray[indexPath.row].ownerImage == nil) {
                cell.authorImageView.image = #imageLiteral(resourceName: "ic_profile-5")
            } else {
                cell.authorImageView.image = myCommentsArray[indexPath.row].ownerImage
            }
            return cell
        } else {
            cell.answerButton.isHidden = false
            let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
            cell.authorNameLabel.text = myAnswersArray[indexPath.row].ownerName
            cell.authorSurenameLabel.text = myAnswersArray[indexPath.row].ownerSurename
            cell.commentDateLabel.text = myAnswersArray[indexPath.row].date
            cell.commentsTextView.text = myAnswersArray[indexPath.row].text
            cell.commentDateLabel.text = myAnswersArray[indexPath.row].date?.convertDateString()
            if (myAnswersArray[indexPath.row].ownerImage == nil) {
                cell.authorImageView.image = #imageLiteral(resourceName: "ic_profile-5")
            } else {
                cell.authorImageView.image = myAnswersArray[indexPath.row].ownerImage
            }
            return cell
        }
    }
    
    func fetchMyCommnets() {
        guard let url = URL(string: BASE_URL + "/api/comments/my") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            if let data = data {
            do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    guard let array = json as? NSArray else { return }
                    for i in 0..<array.count {
                        guard let tempDict = array[i] as? Dictionary<String,Any> else { return }
                        for (key,value) in tempDict {
                            if (key == "text") {
                                self.newComment.text = value as? String
                            }
                            if (key == "created") {
                                self.newComment.date = value as? String
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
                        self.myCommentsArray.append(self.newComment)
                        self.newComment = Comment()
                    }
            } catch {
                print("error")
                }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }.resume()
    }
    
    func fetchAnswersToMyCommments() {
        guard let url = URL(string: BASE_URL + "/api/answers") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
             if let data = data {
            do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print(json)
                    guard let array = json as? NSArray else { return }
                    for i in 0..<array.count {
                        guard let tempDict = array[i] as? Dictionary<String,Any> else { return }
                        for (key,value) in tempDict {
                            if (key == "text") {
                                print(value)
                                self.newAnswer.text = value as? String
                            }
                            if (key == "created") {
                                self.newAnswer.date = value as? String
                                print(value)
                            }
                            if (key == "author") {
                                if let commentAuthorDict = value as? Dictionary<String,Any> {
                                    for (key,value) in commentAuthorDict {
                                        if (key == "first_name") {
                                            print(value)
                                            self.newAnswer.ownerName = value as? String
                                        }
                                        if (key == "last_name") {
                                            print(value)
                                            self.newAnswer.ownerSurename = value as? String
                                        }
                                    }
                                }
                            }
                        }
                        self.myAnswersArray.append(self.newAnswer)
                        self.newAnswer = Comment()
                    }
            } catch {
                print("error")
            }
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            }.resume()
        
    }
    
}
