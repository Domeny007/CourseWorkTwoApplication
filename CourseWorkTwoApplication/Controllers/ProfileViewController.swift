//
//  ProfileViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 30/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var surenameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var avatarImageView: UIImageView!
    
    var user: User?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUserInformation(with: getInformationAboutUser())
    }
    func getInformationAboutUser() -> User {
        let authorizedUser = User()
        // get information from database
        
        authorizedUser.id = "1"
        authorizedUser.email = "hello@yandex.ru"
        authorizedUser.name = "Azat"
        authorizedUser.surename = "Alekbaev"
        authorizedUser.password = "one two three"
        authorizedUser.avatarImage = #imageLiteral(resourceName: "twitterIcon")
        return authorizedUser
    }
    
    func setUpUserInformation(with user: User) {
        guard let userName = user.name, let userSurename = user.surename, let userEmail = user.email else { return }
        nameLabel.text = userName
        surenameLabel.text = userSurename
        emailLabel.text = userEmail
        avatarImageView.image = user.avatarImage
    }
    
}
