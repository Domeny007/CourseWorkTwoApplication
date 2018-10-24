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
            //transition to another controller
        }
        
    }
    
    func allFieldsAreFilled() -> Bool {
        guard let nameText = nameTextField.text, let surenameText = surenameTextField.text,
              let emailText = emailTextField.text, let passwordText = passwordTextField.text,
              let repeatPasswordText = repeatPasswordTextField.text else { return false }
        
        if  (nameText.isEmpty && surenameText.isEmpty && emailText.isEmpty &&
            passwordText.isEmpty && repeatPasswordText.isEmpty) {
            
            testResultLabel.text = allFieldArentFilled
            return false
        }else {
            return true
        }
    }
    func checkThatEmailNeverUsed() {
        //request to database with users email
    }
    
}
