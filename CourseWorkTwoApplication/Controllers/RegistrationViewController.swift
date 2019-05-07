//
//  RegistrationViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 16/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var surenameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var registrationButton: UIButton!
    @IBOutlet weak var testResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpTestResultLabel()
        testResultLabel.sizeToFit()
        testResultLabel.numberOfLines = 0
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        testResultLabel.text = ""
        nameTextField.text = ""
        surenameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
    }

    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        if (allFieldsAreFilled()) {
            registrateUser()
            
        }
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setUpTestResultLabel() {
        testResultLabel.textColor = UIColor.red
        testResultLabel.text = emptyString
    }
    
    func presentMainTabBar() {
        let mainTabBar = UIStoryboard(name: storyBoardNameString, bundle: nil).instantiateViewController(withIdentifier: mainTabBarIdentifier) as! MainTabBarController
       
        self.present(mainTabBar, animated: true, completion: nil)
    }
    
    func allFieldsAreFilled() -> Bool {
        guard let nameText = nameTextField.text, let surenameText = surenameTextField.text,
              let emailText = emailTextField.text, let passwordText = passwordTextField.text,
              let repeatPasswordText = repeatPasswordTextField.text else { return false }
        
        if  (nameText.isEmpty || surenameText.isEmpty || emailText.isEmpty ||
            passwordText.isEmpty || repeatPasswordText.isEmpty) {
            testResultLabel.text = allFieldArentFilled
            return false
        }else if (passwordText == repeatPasswordText) {
            if (checkEmailValidation(testStr: emailText)) {
                if (checkPasswordValidation(passwordText)) {
                    return true
                } else {
                    testResultLabel.text = passwordFieldIsntValid
                    return false
                }
            } else {
                testResultLabel.text = emailFieldIsntValid
                return false
            }
            
            } else {
                testResultLabel.text = passwordIsNotCorrect
                self.reloadInputViews()
                return false
            }
        }
    
    func checkEmailValidation(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    func checkPasswordValidation(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    
    func registrateUser() {
        guard let name = nameTextField.text, let surename = surenameTextField.text,
              let email = emailTextField.text, let password = passwordTextField.text,
              let repeatPassword = repeatPasswordTextField.text else { return }
        let emailObject = email as AnyObject
        let nameObject = name as AnyObject
        let surenameObject = surename as AnyObject
        let passwordObject = password as AnyObject
        let repeatPasswordObject = repeatPassword as AnyObject
        
        let parameters = ["email":emailObject ,"first_name":nameObject,"last_name":surenameObject, "password1":passwordObject,"password2":repeatPasswordObject]
        guard let url = URL(string: BASE_URL + "/auth/registration/") else { return }
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

            if let error = error {
                print(error)
            }
        }.resume()
        
    }
    
}
