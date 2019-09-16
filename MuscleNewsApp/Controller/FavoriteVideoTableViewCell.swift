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
    
    // Video インスタンス の内容をセル内に配置したラベルなどに反映させる
    // Realmから取得するため、Data型からFavorite型に変更
    func setCell(_ favorite: Favorite) {
        self.titleTextField.text = favorite.title as String
        self.channelNameTextField.text = favorite.name as String
        // 画像を表示させるために、pngData型からUIImage型に変更
        self.thumbnailImage.image = UIImage(data: favorite.image)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }
    
}
