//
//  Video.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/22.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

class Video: NSObject {
    var title: String
    var name: String
    var image: UIImage

    init(title: String, name:String, image: UIImage) {
        self.title = title as String
        self.name = name as String
        self.image = image
    }
}
