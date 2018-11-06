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
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    
    func setUpTestResultLabel() {
        testResultLabel.textColor = UIColor.red
        testResultLabel.text = emptyString
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func registrationButtonPressed(_ sender: UIButton) {
        if (allFieldsAreFilled()) {
            saveData()
            presentMainTabBar()
        }
        
    }
    func presentMainTabBar() {
        let mainTabBar = UIStoryboard(name: storyBoardNameString, bundle: nil).instantiateViewController(withIdentifier: mainTabBarIdentifier) as! MainTabBarController
        testResultLabel.text = ""
        nameTextField.text = ""
        surenameTextField.text = ""
        emailTextField.text = ""
        passwordTextField.text = ""
        repeatPasswordTextField.text = ""
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
            if (isValidEmail(testStr: emailText)) {
                if (isPasswordValid(passwordText)) {
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
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", passwordRegEx)
        return passwordTest.evaluate(with: password)
    }
    func checkThatEmailNeverUsed() {
        //request to database with users email
    }
    
    func saveData() {
        
        guard let name = nameTextField.text, let surename = surenameTextField.text,
              let email = emailTextField.text, let password = passwordTextField.text
        else { return }
        //saving information to database
    }
    
}
