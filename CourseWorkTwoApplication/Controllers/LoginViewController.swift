//
//  LoginViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 16/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import VK_ios_sdk

class LoginViewController: UIViewController, VKSdkDelegate, VKSdkUIDelegate {
    
    
    
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
        let sdkInstance = VKSdk.initialize(withAppId: "6723456")
        sdkInstance!.register(self)
        sdkInstance?.uiDelegate = self
        let bundleID = Bundle.main.bundleIdentifier!
        print(bundleID)
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    @IBAction func forgetPasswordPressed(_ sender: UIButton) {
        
    }
    
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let emailTextFieldText = emailTextField.text,
              let passwordTextFieldText = passwordTextField.text else { return }
        
        if !emailTextFieldText.isEmpty && !passwordTextFieldText.isEmpty {
            
            let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: mainTabBarIdentifier) as! MainTabBarController
            self.present(mainTabBarController, animated: true, completion: nil)
        } else {
            emailPasswordChecingLabel.textColor = UIColor.red
            emailPasswordChecingLabel.text = allFieldArentFilled
        }
        
    }
    
//    func getWebkitViewController(with string: String, and button: UIButton) {
//    
//        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
//        let webKitViewController = storyboard.instantiateViewController(withIdentifier: webkitViewControllerIdentifier) as! WebKitViewController
//        webKitViewController.string = string
//        self.present(webKitViewController, animated: true, completion: nil)
//        button.isHighlighted = true
//        
//    }
    
    @IBAction func vkAuthButtonPressed(_ sender: UIButton) {
        VKSdk.wakeUpSession([VK_API_LONG]) { (state, error) in
            switch(state) {
            case VKAuthorizationState.authorized:
                let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
                let mainTabBarController = storyboard.instantiateViewController(withIdentifier: mainTabBarIdentifier) as! MainTabBarController
                self.present(mainTabBarController, animated: true, completion: nil)
                break
            case VKAuthorizationState.initialized:
                VKSdk.authorize([VK_PER_EMAIL])
                break
            default:
                break
            }
        }
        
//        getWebkitViewController(with: vkString, and: vkAuthButton)

    }
    
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        self.present(controller, animated: true, completion: nil)
    }
    
    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {}
    
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        if (result.token != nil) {
            // User successfully authorized, you may start working with VK API
            print("successfully authorized", result.token)
            let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
            let mainTabBarController = storyboard.instantiateViewController(withIdentifier: mainTabBarIdentifier) as! MainTabBarController
            self.present(mainTabBarController, animated: true, completion: nil)
            
        } else if (result.error != nil) {
            // User canceled authorization, or occured unresolving networking error. Reset your UI to initial state and try authorize user later
            print("authorization unsuccessfull")
        }
    }
    
    func vkSdkUserAuthorizationFailed() {
        print("Failed")
    }
    @IBAction func googleAuthButtonPressed(_ sender: UIButton) {
        
    }
    @IBAction func twitterAuthButtonPressed(_ sender: UIButton) {
        
    }

    
    
}
