//
//  PostData.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/20.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import Foundation
import Firebase

class PostData: NSObject {
    var id: String?
    var image: UIImage?
    var imageString: String?
    var name: String?
    var caption: String?
    var category: String?
    var url: String?
    var date: Date?
    var likes: [String] = []
    var isLiked: Bool = false
    var comment: [String] = []
    var poster: [String] = []
    
    init(snapshot: DataSnapshot, myId: String) {
        self.id = snapshot.key
        
        let valueDictionary = snapshot.value as! [String: Any]
        
        imageString = valueDictionary["image"] as? String
        image = UIImage(data: Data(base64Encoded: imageString!, options: .ignoreUnknownCharacters)!)
        
        self.name = valueDictionary["name"] as? String
        
        self.caption = valueDictionary["caption"] as? String
        
        self.category = valueDictionary["category"] as? String
        
        self.url = valueDictionary["url"] as? String
        
        let time = valueDictionary["time"] as? String
        self.date = Date(timeIntervalSinceReferenceDate: TimeInterval(time!)!)
        
        if let comment = valueDictionary["comment"] as? [String] {
            self.comment = comment
        }
        
        if let poster = valueDictionary["poster"] as? [String] {
            self.poster = poster
        }
        
        if let likes = valueDictionary["likes"] as? [String] {
            self.likes = likes
        }
        
        for likeId in self.likes {
            if likeId == myId {
                self.isLiked = true
                break
            }
        }
    }
}
