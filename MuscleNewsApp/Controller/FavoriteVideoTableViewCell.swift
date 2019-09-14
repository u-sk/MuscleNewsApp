//
//  FavoriteVideoTableViewCell.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/09/14.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

class FavoriteVideoTableViewCell: UITableViewCell {

    @IBOutlet weak var tapVideoButton: UIButton!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var channelNameTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
    

    func setCell(_ video: Video) {
        self.titleTextField.text = video.title as String
        self.channelNameTextField.text = video.name as String
        self.thumbnailImage.image = video.image
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
