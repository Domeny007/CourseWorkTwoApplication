//
//  NewsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 16/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit


struct newsData {
    let authorName: String!
    let authorSurename: String!
    let newsText: String!
    let authorImage: UIImage!
}

class NewsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var arrayOfNewsData = [newsData]()
    
    @IBOutlet weak var newsNavigationBar: UINavigationBar!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayOfNewsData = [newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),
        newsData(authorName: "Azat", authorSurename: "Alekbaev", newsText: "Much evil soon high in hope do view. Out may few northward believing attempted. Yet timed being songs marry one defer men our. Although finished blessing do of. Consider speaking me prospect whatever if. Ten nearer rather hunted six parish indeed number. Allowance repulsive sex may contained can set suspected abilities cordially. Do part am he high rest that. So fruit to ready it being views match. ", authorImage: #imageLiteral(resourceName: "twitterIcon")),]
    }
    

    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return arrayOfNewsData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
        cell.ownerNameLabel.text = arrayOfNewsData[indexPath.row].authorName
        cell.ownerSurenameLabel.text = arrayOfNewsData[indexPath.row].authorSurename
        cell.newsTextView.text = arrayOfNewsData[indexPath.row].newsText
        cell.ownerAvatarImageView.image = arrayOfNewsData[indexPath.row].authorImage
        return cell
        
    }
}
