//
//  NewsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 16/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

var newsArray = [News]()

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AddToCalendarButtonPressedProtocol, NewsCommentsProtocol, TagsListProtocol {
    
    @IBOutlet weak var newsTabBarItem: UITabBarItem!
    @IBOutlet weak var newsNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    var newNews: News = News()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let customTabBarItem:UITabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "ic_search-4").withRenderingMode(.alwaysOriginal), selectedImage: #imageLiteral(resourceName: "ic_search-3"))
        newsTabBarItem = customTabBarItem
        newsArray.removeAll()
        getNews()
        self.tableView.addSubview(self.refreshControl)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        UserDefaults.standard.removeObject(forKey: userDefaultTokenKey)
        self.dismiss(animated: true, completion: nil)
    }
    
    func getNews() {
        guard let url = URL(string: BASE_URL + "/api/news/")  else { return }
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
                    //print(json)
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
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        
    }
    
    
    func loadTagsListWindow(cell: NewsTableViewCell) {
        
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let tagsListVC = storyboard.instantiateViewController(withIdentifier: tagsListVCIdentifier) as! TagsListViewController
        
        guard let cellId = cell.id, let tags = newsArray[cellId].tags else { return }
        tagsListVC.tagsString = tags
        self.present(tagsListVC, animated: true, completion: nil)
        
    }
    
    func loadCreatingEventWindow(cell: NewsTableViewCell) {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let creatingEventVC = storyboard.instantiateViewController(withIdentifier: creatingEventVCIdentifier) as! CreatingEventViewController
        self.present(creatingEventVC, animated: true, completion: nil)
        
    }
    
    func loadNewsCommentWindow(cell: NewsTableViewCell) {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let newsCommentsVC = storyboard.instantiateViewController(withIdentifier: newsCommentsViewControllerIdentifier) as! NewsCommentsViewController
        newsCommentsVC.cellId = cell.id!
        
        self.present(newsCommentsVC, animated: true, completion: nil)
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(NewsViewController.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = .black
        
        return refreshControl
    }()
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
            newsArray.removeAll()
            getNews()
            refreshControl.endRefreshing()
    }
    

    //working with table view controller
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return newsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed(newsTableViewCellNibName, owner: self, options: nil)?.first as! NewsTableViewCell
        cell.eventDelegate = self
        cell.commentDelegate = self
        cell.tagsListDelegate = self
        if newsArray.count != 0 {
            if let authorPhotoString = newsArray[indexPath.row].authorPhoroUrl {
                if authorPhotoString == "" {
                    cell.ownerAvatarImageView.image = #imageLiteral(resourceName: "ic_profile-5")
                } else {
                     cell.ownerAvatarImageView.loadImageUsingCache(with: authorPhotoString)
                }
               
            }
            cell.ownerNameLabel.text = newsArray[indexPath.row].authorName
            cell.ownerSurenameLabel.text = newsArray[indexPath.row].authorSurename
            cell.newsTextView.text = newsArray[indexPath.row].text
            cell.id = indexPath.row
            cell.newsDateLabel.text = localizeDateFormat(with: newsArray[indexPath.row].date!)
            if let tags = newsArray[indexPath.row].tags {
                cell.tagsLabel.text = "Тэги: " + tags
            }
        }
        
        return cell
    }
    
}

func localizeDateFormat(with string: String) -> String {
    let formatter = DateFormatter()
    formatter.dateStyle = DateFormatter.Style.long
    formatter.timeStyle = .medium
    let dateFormatter = DateFormatter()
    let createdDate = dateFormatter.date(fromSwapiString: string)
    let dateString = formatter.string(from: createdDate!)
    return dateString
}

let imageCache = NSCache<AnyObject, AnyObject>()

extension UIImageView {
    
    func loadImageUsingCache(with urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
        }
        
        if let url = URL(string: urlString) {
        URLSession.shared.dataTask(with:url) { (data, response, error) in
            if error != nil {
                print(error as Any)
                return
            }
            DispatchQueue.main.async {
                guard let downloadedImage = UIImage(data: data!) else { return }
                imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                self.image = downloadedImage
            }
            }.resume()
    }
    }
    
}

extension DateFormatter {
    func date(fromSwapiString dateString: String) -> Date? {
        // SWAPI dates look like: "2014-12-10T16:44:31.486000Z"
        self.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SZ"
        self.timeZone = TimeZone(abbreviation: "UTC")
        self.locale = Locale(identifier: "ru")
        return self.date(from: dateString)
    }
}
