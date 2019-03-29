//
//  NewNewsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 20/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

class NewNewsViewController: UIViewController {
    
    @IBOutlet weak var attachVideoButton: UIButton!
    @IBOutlet weak var attachPhotoButton: UIButton!
    @IBOutlet weak var newNewsTextView: UITextView!
    @IBOutlet weak var newNewsTagsTextField: UITextField!
    @IBOutlet weak var createButton: UIBarButtonItem!
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    var newsViewController = NewsViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func createNewsButtonPressed(_ sender: UIButton) {
        guard let tags = newNewsTagsTextField.text else { return }
        let tagsArray = tags.components(separatedBy: " ")
        
        createNewNews(with: newNewsTextView.text, and: tagsArray)
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func createNewNews(with text: String,and tags: [String]) {
        let parameters = ["text": text,"add_tags": tags] as [String : Any]
        guard let url = URL(string: BASE_URL + "/api/news/")  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else { return }
        request.httpBody = httpBody
        guard let userToken = UserDefaults.standard.string(forKey: userDefaultTokenKey) else { return }
        request.addValue("JWT \(userToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let session = URLSession.shared
        session.dataTask(with: request) { (_, _, error) in
            if let error = error {
                print(error)
            }
        }.resume()
    }
    
    @IBAction func backButtonPressed(_ sender: UIButton) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
}
