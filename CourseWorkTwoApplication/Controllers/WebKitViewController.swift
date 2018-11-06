//
//  WebKitViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 17/10/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var interactionWebView: WKWebView!
    
    var string: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let string = string, let url = URL(string: string) else { return }
        
        let request = URLRequest(url: url)
        interactionWebView.load(request)
    }
    
    @IBAction func backButtonPressed(_ sender: UIBarButtonItem) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    

}
