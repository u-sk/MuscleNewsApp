//
//  VideoTableViewCell.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/22.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

class VideoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tapVideoButton: UIButton!
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleTextField: UILabel!
    @IBOutlet weak var channelNameTextField: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setCell(_ video: Video) {
        self.titleTextField.text = video.title as String
        self.channelNameTextField.text = video.name as String
        self.thumbnailImage.image = video.image 
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
