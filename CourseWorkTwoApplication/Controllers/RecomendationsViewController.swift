//
//  RecomendationsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 20/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class RecomendationsViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {
    
    @IBOutlet weak var newsSearchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!

    var newNews: News = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        newsArray.removeAll()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        view.endEditing(true)
        newsArray.removeAll()
        getNewsByTag()
        newsArray.removeAll()
    }
    
    func getTagNameForUrl() -> String {
        
        guard let tag = newsSearchBar.text else { return "" }
        let tempNames = tag.replacingOccurrences(of: " ", with: "&")
        let tagNames = tempNames.replacingOccurrences(of: "#", with: "tag=")
        return tagNames
        
    }
    
    func getNewsByTag() {
        guard let url = URL(string: BASE_URL + "/api/find?\(getTagNameForUrl())") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            do {
            if let data = data {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print(json)
                guard let array = json as? NSArray else { return }
                for i in 0..<array.count {
                    guard let tempDict = array[i] as? Dictionary<String,Any> else { return }
                    for (key,value) in tempDict {
                        if (key == "id") {
                            let id = value as! Int
                            UserDefaults.standard.set(id, forKey: "\(i)news")
                            
                        }
                        if (key == "text") {
                            self.newNews.text = value as? String
                        }
                        if (key == "author") {
                            if let authorDict = value as? Dictionary<String,Any> {
                                for (key,value) in authorDict {
                                    if (key == "first_name") {
                                        self.newNews.authorName = value as? String
                                    }
                                    if (key == "last_name") {
                                        self.newNews.authorSurename = value as? String
                                    }
                                    if (key == "profile") {
                                        if let authorsProfileDict = value as? Dictionary<String,Any> {
                                            for (key,value) in authorsProfileDict {
                                                if (key == "photo_url") {
                                                    self.newNews.authorPhoroUrl = value as? String
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                        if (key == "created") {
                            self.newNews.date = value as? String
                        }
                        if (key == "tags") {
                            if let tempTagsArray = value as? NSArray {
                                for item in tempTagsArray {
                                    if let tagDict = item as? Dictionary<String,Any> {
                                        for (key,value) in tagDict {
                                            if (key == "name") {
                                                self.newNews.tags?.append(value as! String)
                                                self.newNews.tags?.append(" ")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    newsArray.append(self.newNews)
                    self.newNews = News()
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                }
            }catch {
                print(error)
            }
        }.resume()
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
                cell.ownerNameLabel.text = newsArray[indexPath.row].authorName
                cell.ownerSurenameLabel.text = newsArray[indexPath.row].authorSurename
                cell.newsTextView.text = newsArray[indexPath.row].text
                cell.tagsLabel.text = "Тэги " + newsArray[indexPath.row].tags!
        cell.newsDateLabel.text = localizeDateFormat(with: newsArray[indexPath.row].date!)
        
        if let authorPhotoString = newsArray[indexPath.row].authorPhoroUrl {
            if authorPhotoString == "" {
                cell.ownerAvatarImageView.image = #imageLiteral(resourceName: "ic_profile")
            } else {
                cell.ownerAvatarImageView.loadImageUsingCache(with: authorPhotoString)
            }
            
        }
        return cell
    }
}
