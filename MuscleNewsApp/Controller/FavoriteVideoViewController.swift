//
//  FavoriteVideoViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/09/14.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

class FavoriteVideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoriteVideoTableView: UITableView!
    
    // お気に入り動画の配列(受け取り用)
    var favoriteVideos = [Video]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "お気に入り動画"
        
        // tableViewデリゲート
        favoriteVideoTableView.dataSource = self
        favoriteVideoTableView.delegate = self
        
        let nib = UINib(nibName: "FavoriteVideoTableViewCell", bundle: nil)
        favoriteVideoTableView.register(nib, forCellReuseIdentifier: "FavVideoCell")

      print("受け取ったお気に入り動画の配列：\(favoriteVideos)")
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavVideoCell", for: indexPath) as! FavoriteVideoTableViewCell
        cell.setCell(favoriteVideos[indexPath.row])

        // セル内のボタン(お気に入り動画)のアクションをソースコードで設定する
        cell.tapVideoButton.addTarget(self, action:#selector(tapVideoButton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    // セル内のボタン(お気に入り動画)がタップされた時に呼ばれるメソッド
    @objc func tapVideoButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: 動画ボタンがタップされました")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.favoriteVideoTableView)
        let indexPath = favoriteVideoTableView.indexPathForRow(at: point)
        print("ここが場所です：\(indexPath!.row)")
        
        // safaliへ画面遷移し、URLをもとにYoutubeを表示
        if let url = URL(string: favoriteVideos[indexPath!.row].videoid) {
            UIApplication.shared.open(url)
        }
    }
    
    
}
