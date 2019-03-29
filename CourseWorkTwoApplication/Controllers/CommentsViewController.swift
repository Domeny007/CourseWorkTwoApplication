//
//  CommentsViewController.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 20/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit



class CommentsViewController: UIViewController,UITableViewDataSource, UITableViewDelegate , AnswerProtocol{
    
    @IBOutlet weak var commentsSegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func segmentedViewControllerTapped(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }
    
    func loadAnswerWindow() {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardNameString, bundle: nil)
        let answerVC = storyboard.instantiateViewController(withIdentifier: answerViewControllerIdentifier) as! AnswerViewController
        self.present(answerVC, animated: true, completion: nil)
    }
    
    // working with table view controller
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if commentsSegmentedControl.selectedSegmentIndex == 0 {
            return 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CommentTableViewCell", owner: self, options: nil)?.first as! CommentTableViewCell
        cell.answerDelegate = self
        
        if commentsSegmentedControl.selectedSegmentIndex == 0 {
            cell.answerButton.isHidden = true
        } else {
            cell.answerButton.isHidden = false
        }
        
        return cell
    }
    
}
