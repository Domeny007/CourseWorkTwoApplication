//
//  CommentTableViewCell.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 20/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit

protocol AnswerProtocol: class {
    func loadAnswerWindow()
}


class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var authorImageView: UIImageView!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var authorSurenameLabel: UILabel!
    @IBOutlet weak var commentDateLabel: UILabel!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var answerButton: UIButton!
    
     var answerDelegate: AnswerProtocol?
    
    @IBAction func answerButtonPressed(_ sender: UIButton) {
        answerDelegate?.loadAnswerWindow()
    }
}
