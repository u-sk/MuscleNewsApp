//
//  FavoriteVideoViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/09/14.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import RealmSwift
import SVProgressHUD

class FavoriteVideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var favoriteVideoTableView: UITableView!

    // Realmインスタンスを取得
    let realm = try! Realm()
    
    // お気に入り動画の配列(受け取り用) → Realmから取得するため、不要になった
//    var favoriteVideos = [Video]()
    
    // Realmに保存している情報を全件取得する値を入れる変数
    var favoriteVideos: Results<Favorite>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "お気に入り動画"
        
        // Realmに保存している情報を全件取得する
        favoriteVideos = realm.objects(Favorite.self).sorted(byKeyPath: "id", ascending: true)

        // tableViewデリゲート
        favoriteVideoTableView.dataSource = self
        favoriteVideoTableView.delegate = self
        
        let nib = UINib(nibName: "FavoriteVideoTableViewCell", bundle: nil)
        favoriteVideoTableView.register(nib, forCellReuseIdentifier: "FavVideoCell")
        
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoriteVideos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FavVideoCell", for: indexPath) as! FavoriteVideoTableViewCell
        cell.setCell(favoriteVideos![indexPath.row])

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
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // データベースから削除する
            try! realm.write {
                self.realm.delete(self.favoriteVideos[indexPath.row])
                // 選択した投稿のデータの配列をテーブルビュー上から削除
                tableView.deleteRows(at: [indexPath], with: .fade)
                favoriteVideos = try! Realm().objects(Favorite.self).sorted(byKeyPath: "id", ascending: true)
                tableView.reloadData()
                // HUDで削除完了を表示する
                SVProgressHUD.showSuccess(withStatus: "お気に入り動画を削除しました")
            }
        } else {
            print("削除できませんでした")
            return
        }
    }
    
}
