//
//  Media.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 07/01/2019.
//  Copyright © 2019 Азат Алекбаев. All rights reserved.
//

import UIKit

struct Media {
    let key: String
    let fileName: String
    let data: Data
    let mimeType: String
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.fileName = "photo\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else { return nil}
        self.data = data
    }
}


