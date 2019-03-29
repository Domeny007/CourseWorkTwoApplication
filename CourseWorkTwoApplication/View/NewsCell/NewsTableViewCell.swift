//
//  NewsTableViewCell.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 02/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit
import EventKit


protocol AddToCalendarButtonPressedProtocol: class {
    func loadCreatingEventWindow(cell: NewsTableViewCell)
}

protocol NewsCommentsProtocol:class {
    func loadNewsCommentWindow(cell: NewsTableViewCell)
}

protocol TagsListProtocol:class {
    func loadTagsListWindow(cell: NewsTableViewCell)
}

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerSurenameLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var commentsButton: UIButton!
    @IBOutlet weak var calendarButton: UIButton!
    @IBOutlet weak var newsDateLabel: UILabel!
    
    var eventDelegate: AddToCalendarButtonPressedProtocol?
    
    var commentDelegate: NewsCommentsProtocol?
    
    var tagsListDelegate: TagsListProtocol?
    var id:Int?
    
    
    
    
    @IBAction func addToCalendarButtonPressed(_ sender: UIButton) {
        eventDelegate?.loadCreatingEventWindow(cell: self)
    }
    
    @IBAction func commentsButtonPressed(_ sender: Any) {
        commentDelegate?.loadNewsCommentWindow(cell: self)
    }
    
    @IBAction func tagsListPressed(_ sender: UIButton) {
        tagsListDelegate?.loadTagsListWindow(cell: self)
    }
    
    
    
}
    
    
