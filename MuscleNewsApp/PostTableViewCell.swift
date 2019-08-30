//
//  PostTableViewCell.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/20.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
//    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var makeCommentButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setPostData(_ postData: PostData) {
        self.postImageView.image = postData.image
        
        self.captionLabel.text = "\(postData.name!) : \(postData.caption!)"
        
        let likeNumber = postData.likes.count
        likeLabel.text = "\(likeNumber)"
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        let dateString = formatter.string(from: postData.date!)
        self.dateLabel.text = dateString
        
        self.categoryLabel.text = "カテゴリー : \(postData.category!)"
        
        // コメント作成者・コメント追加
        var setComment: String = ""
        for index in 0 ..< postData.poster.count {
            let poster = postData.poster[index]
            let comment = postData.comment[index]
            setComment += "\(poster)さんのコメント: \(comment) \n"
        }
        self.commentLabel.text = setComment
        print("\(postData.id!) : \(self.commentLabel.text!)")
        
        
        if postData.isLiked {
            let buttonImage = UIImage(named: "like_exist")
            self.likeButton.setImage(buttonImage, for: .normal)
        } else {
            let buttonImage = UIImage(named: "like_none")
            self.likeButton.setImage(buttonImage, for: .normal)
        }
    }
}
