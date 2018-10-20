//
//  LoginViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 16/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var vkAuthButton: UIButton!
    @IBOutlet weak var googleAuthButton: UIButton!
    @IBOutlet weak var twitterAuthButton: UIButton!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var loginWithAnotherButton: UIButton!
    @IBOutlet weak var forgetPasswordButton: UIButton!
    
    @IBOutlet weak var emailPasswordChecingLabel: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
    }
    
    @IBAction func forgetPasswordPressed(_ sender: UIButton) {
        
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let emailTextFieldText = emailTextField.text,
              let passwordTextFieldText = passwordTextField.text else { return }
        
        if !emailTextFieldText.isEmpty && !passwordTextFieldText.isEmpty {
            
            let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
            let newsViewController = storyboard.instantiateViewController(withIdentifier: newsViewControllerIdentifier) as! NewsViewController
            self.present(newsViewController, animated: true, completion: nil)
        } else {
            emailPasswordChecingLabel.textColor = UIColor.red
            emailPasswordChecingLabel.text = allFieldArentFilled
        }
        
    }
    
    func getWebkitViewController(with string: String, and button: UIButton) {
    
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let webKitViewController = storyboard.instantiateViewController(withIdentifier: webkitViewControllerIdentifier) as! WebKitViewController
        webKitViewController.string = string
        self.present(webKitViewController, animated: true, completion: nil)
        button.isHighlighted = true
        
    }
    
    @IBAction func vkAuthButtonPressed(_ sender: UIButton) {
        
        getWebkitViewController(with: vkString, and: vkAuthButton)

    }
    @IBAction func googleAuthButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func twitterAuthButtonPressed(_ sender: UIButton) {
        
    }
    
    
}
