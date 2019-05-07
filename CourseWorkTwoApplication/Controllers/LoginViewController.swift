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


    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailPasswordChecingLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        emailPasswordChecingLabel.sizeToFit()
        emailPasswordChecingLabel.adjustsFontSizeToFitWidth = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkIfUserLoggedIn()
    }
    
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        guard let email = emailTextField.text,
              let password = passwordTextField.text else { return }
        
        if !email.isEmpty && !password.isEmpty {
            
            loginWithDatabase(with: email, and: password)
        } else {
            emailPasswordChecingLabel.textColor = UIColor.red
            emailPasswordChecingLabel.text = allFieldArentFilled
        }
        
    }
    /* present main window after login */
    func presentMainTabBar() {
        emailTextField.text = ""
        passwordTextField.text = ""
        
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let mainTabBarController = storyboard.instantiateViewController(withIdentifier: mainTabBarIdentifier) as! MainTabBarController
        self.present(mainTabBarController, animated: true, completion: nil)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    func checkIfUserLoggedIn() {
        if UserDefaults.standard.string(forKey: userDefaultTokenKey) != nil {
            presentMainTabBar()
        }
    }
    
    func loginWithDatabase(with email: String, and password: String) {
        let parameters = ["email":email,"password":password]
        guard let url = URL(string: BASE_URL + "/auth/login/") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("", forHTTPHeaderField: "Cookie")
        let session = URLSession.shared
        session.dataTask(with: request) { (data, responce, error) in
            if let responce = responce {
                print(responce)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    print("JSON\n")
                    print(json)
                    if let dictionary = json as? [String:Any] {
                        if let token = dictionary["token"] {
                            UserDefaults.standard.set(token, forKey: userDefaultTokenKey)
                            DispatchQueue.main.async {
                                self.presentMainTabBar()
                            }
                        }
                        
                    }
                } catch {
                    print(error)
                }
            }
            }.resume()
    }
    
}
