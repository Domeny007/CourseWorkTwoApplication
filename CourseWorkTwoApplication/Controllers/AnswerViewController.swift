//
//  AnswerViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 28/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class AnswerViewController: UIViewController {
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    @IBAction func backButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func makeAnswerButtonPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
