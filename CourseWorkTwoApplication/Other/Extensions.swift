//
//  Extensions.swift
//  CourseWorkTwoApplication
//
//  Created by Азат Алекбаев on 28/04/2019.
//  Copyright © 2019 Азат Алекбаев. All rights reserved.
//

import Foundation
import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()
extension UIImageView {
    func loadImageUsingCache(with urlString: String) {
        
        self.image = nil
        
        if let cachedImage = imageCache.object(forKey: urlString as AnyObject) as? UIImage {
            self.image = cachedImage
        }
        
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with:url) { (data, response, error) in
                if error != nil {
                    print(error as Any)
                    return
                }
                DispatchQueue.main.async {
                    guard let downloadedImage = UIImage(data: data!) else { return }
                    imageCache.setObject(downloadedImage, forKey: urlString as AnyObject)
                    self.image = downloadedImage
                }
                }.resume()
        }
    }
    
}

extension String {
    
    
    func convertDateString() -> String? {
        return convert(dateString: self + "Z", fromDateFormat: "yyyy-MM-dd'T'HH:mm:ss.SZ", toDateFormat: "MM-dd-yyyy HH:mm")
    }
    
    
    func convert(dateString: String, fromDateFormat: String, toDateFormat: String) -> String? {
        
        let fromDateFormatter = DateFormatter()
        fromDateFormatter.dateFormat = fromDateFormat
        
        if let fromDateObject = fromDateFormatter.date(from: dateString) {
            
            let toDateFormatter = DateFormatter()
            toDateFormatter.dateFormat = toDateFormat
            
            let newDateString = toDateFormatter.string(from: fromDateObject)
            return newDateString
        }
        
        return nil
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
            
        }
    }
}

extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.data(using: String.Encoding.utf8, allowLossyConversion: true)
        append(data!)
}
}

