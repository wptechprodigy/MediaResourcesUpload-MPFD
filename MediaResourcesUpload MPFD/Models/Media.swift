//
//  Models.swift
//  MediaResourcesUpload MPFD
//
//  Created by waheedCodes on 20/02/2021.
//

import UIKit

struct Media {
    let key: String
    let filename: String
    let data: Data
    let mimeType: String // MimeType
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        self.mimeType = "image/jpeg"
        self.filename = "photo\(arc4random()).jpeg"
        
        guard let data = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        
        self.data = data
    }
}

//enum MimeType {
//
//}
