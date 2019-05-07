//
//  TagsListViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 26/12/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class TagsListViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    var tagsString:String = ""
    var usersTags:[String] = []
    var check:Bool = false
    var countCheck:Int = 0
    var tagName: String = ""
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getUsersTags()
    }
    override func viewWillAppear(_ animated: Bool) {
            self.usersTags.removeAll()
            self.getUsersTags()
    }
    
    func getTagsArray(with tagsString: String) -> [String]{
        
        var tagsArray = tagsString.components(separatedBy: "#")
        tagsArray.removeFirst()
        return tagsArray
    }
    func getUsersTagsArray(with tagsString: String) -> [String]{
        
        var tagsArray = tagsString.components(separatedBy: " ")
        tagsArray.removeFirst()
        return tagsArray
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    func showAlert(with title: String, and message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            let rewritedTag = self.rewriteTagName(with: self.tagName)
            guard let url = URL(string: BASE_URL + "/api/tags/\(rewritedTag)/sub-name") else { return }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
            request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            let session = URLSession.shared
            session.dataTask(with: request) { (data, responce, error) in
                
                if let data = data {
                    
                    print(data)
                    
                }
                
                if let responce = responce {
                    print(responce)
                }
                
                if let error = error {
                    print(error)
                }
                }.resume()
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { (action) in
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    func subForTag(with tagName: String) {
    }
    
    func rewriteTagName(with tagString: String) -> String{
        let tagNameForDB = tagString.replacingOccurrences(of: "#", with: "%23")
        let withoutSpace = tagNameForDB.replacingOccurrences(of: " ", with: "")
        return withoutSpace
    }
    
    func getUsersTags() {
        usersTags.removeAll()
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
                    guard let dictionary = json as? Dictionary<String, Any> else { return }
                        for (key,value) in dictionary {
                            if (key == "profile") {
                                guard let profileValue = value as? Dictionary<String, Any> else { return }
                                for (key,value) in profileValue {
                                    if (key == "tags") {
                                        guard let tempArray = value as? NSArray else {return}
                                        for tagItem in tempArray {
                                            guard let tagDict = tagItem as? Dictionary<String, Any> else { return }
                                            self.usersTags.append(tagDict["name"] as! String)
                                        }
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
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return getTagsArray(with: tagsString).count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("ProfileTagsTableViewCell", owner: self, options: nil)?.first as! ProfileTagsTableViewCell
        cell.tagTextLabel.text = getTagsArray(with: tagsString)[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        countCheck = 0
        let cell = tableView.cellForRow(at: indexPath) as? ProfileTagsTableViewCell
        
        tagName = "#" + (cell?.tagTextLabel.text)!
        for i in usersTags {
            if (i + " ") == tagName {
                    countCheck += 1
                }
        }
        if (countCheck > 0) {
            showAlert(with: "Вы", and: "Уже подписаны на этот тэг")
        } else {
            showAlert(with: "Подписаться", and: "На этот тэг?")
        }
    }
    
}
