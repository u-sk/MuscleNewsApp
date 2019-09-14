//
//  Favorite.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/09/14.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import RealmSwift

class Favorite: Object {
    // 管理用 ID。プライマリーキー
    @objc dynamic var id = 0
    
    // タイトル
    @objc dynamic var title = ""
    
    // チャンネル名
    @objc dynamic var name = ""
    
    // サムネイル
    @objc dynamic var image = Data()
    
    // 動画ID
    @objc dynamic var videoid = ""
    
    // お気に入り動画
//    @objc dynamic var favoriteVideo = [Video]()
    
    /**
     id をプライマリーキーとして設定
     */
    override static func primaryKey() -> String? {
        return "id"
    }
}
