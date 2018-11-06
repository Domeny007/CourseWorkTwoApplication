//
//  NewsTableViewCell.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 02/11/2018.
//  Copyright © 2018 Азат Алекбаев. All rights reserved.
//

import UIKit


class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var ownerNameLabel: UILabel!
    @IBOutlet weak var ownerSurenameLabel: UILabel!
    @IBOutlet weak var ownerAvatarImageView: UIImageView!
    @IBOutlet weak var newsTextView: UITextView!
    @IBOutlet weak var newsCollectionView: UICollectionView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
