//
//  VideoViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import AVFoundation
import RealmSwift



class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var videoList: UITableView!

    // APIで取得した動画データ一覧
    var videos:[Video] = []
    
    // URLを入れる変数
    var videoID:String = ""
     // URLを入れる配列
    var videoIDArray = [String ]()

    // お気に入り動画の配列
//    var favoriteVideos:[Video] = []
    
    // Realmインスタンスを取得
    let realm = try! Realm()
    
    // 以降内容をアップデートするとリスト内は自動的に更新される。
//    var favoriteVideoArray = try! Realm().objects(Favorite.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // tableViewデリゲート
        videoList.dataSource = self
        videoList.delegate = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        videoList.register(nib, forCellReuseIdentifier: "VideoCell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
         self.setupVideo()
    }

    
    
    func setupVideo() {
            SVProgressHUD.show()
        Alamofire.request("https://www.googleapis.com/youtube/v3/search?part=snippet&maxResults=10&order=date&q=%E7%AD%8B%E3%83%88%E3%83%AC%0D%0A&type=video&key=APIキー").responseJSON { response in
            // 通信結果のJSON (ここまでがAlamofire)
            if let jsonObject = response.result.value {
                // 使いやすいJSONにしてくれる(ここからSwiftyJSON)
                let json = JSON(jsonObject)
                // "items"を取得
                let Items = json["items"]
                print("ここで確認をする：\(Items)")
                var videoDatas: [Video] = []
                // Featureは10個の配列なのでループを回して取る
                // 第一引数のkeyは使わないので、_にする
                for (_ ,subJson):(String, JSON) in Items {

                    print("投稿日時：\(subJson["snippet"]["publishedAt"])")
                    print("ビデオID：\(subJson["id"]["videoId"])")
                    
                    // 動画データを作成する
                    guard let imageURLString = subJson["snippet"]["thumbnails"]["medium"]["url"].string,
                        let imageURL = URL(string: imageURLString) ,
                        let imageData = NSData(contentsOf: imageURL) as Data? else {
                            continue
                    }
                    let image: UIImage? = UIImage(data: imageData)

                    // 動画再生のためのURL完成および配列に格納
                    self.videoID = "https://www.youtube.com/watch?v=" + subJson["id"]["videoId"].string!
                    print("URLです！：\(self.videoID)")
                    self.videoIDArray.append(self.videoID)
                    print("URLの配列です！：\(self.videoIDArray)")
                    
                    let video: Video = Video.init(title: subJson["snippet"]["title"].string!, name: subJson["snippet"]["channelTitle"].string!, image: image!, videoid: self.videoID)
                    videoDatas.append(video)
                    print("ビデオです！：\(video)")
                    print("ビデオデータです！：\(videoDatas)")
                }
                self.videos = videoDatas
                self.videoList.reloadData()
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        cell.setCell(videos[indexPath.row])
        // セル内のボタン(動画)のアクションをソースコードで設定する
        cell.tapVideoButton.addTarget(self, action:#selector(tapVideoButton(_:forEvent:)), for: .touchUpInside)
        
        // セル内のボタン(お気に入り)のアクションをソースコードで設定する
        cell.tapFavoriteBUtton.addTarget(self, action:#selector(tapFavoriteBUtton(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    // セル内のボタン(動画)がタップされた時に呼ばれるメソッド
    @objc func tapVideoButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: 動画ボタンがタップされました")
        // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.videoList)
            let indexPath = videoList.indexPathForRow(at: point)
        print("ここが場所です：\(indexPath!.row)")
        print("これがURLです：\(videoIDArray[indexPath!.row])")
        
        // safaliへ画面遷移し、URLをもとにYoutubeを表示
        if let url = URL(string: videoIDArray[indexPath!.row]) {
            UIApplication.shared.open(url)
        }
    }
    
    // セル内のボタン(お気に入りに追加)がタップされた時に呼ばれるメソッド
    @objc func tapFavoriteBUtton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: 動画ボタンがタップされました")
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.videoList)
        let indexPath = videoList.indexPathForRow(at: point)
        
        // 選択されたお気に入り動画
//        let favoriteVideo = videos[indexPath!.row]
//        favoriteVideos.append(favoriteVideo)
        SVProgressHUD.showSuccess(withStatus: "お気に入りに追加しました")
        
        // Favorite()のインスタンスを生成
        let favorite = Favorite()
         // すでに存在しているタスクのidのうち最大のものを取得
        // IDに値を設定。タスクのidに1を足して他のIDと重ならない値に
        if realm.objects(Favorite.self).count != 0 {
            favorite.id = realm.objects(Favorite.self).max(ofProperty: "id")! + 1
        }
        // Realmを使って保持する
        try! realm.write {
            
            // お気に入り動画を追加(Realm)
            // 選択された動画の情報をそれぞれの項目に代入する
            favorite.title = videos[indexPath!.row].title
            favorite.name = videos[indexPath!.row].name
            // RealmではUIImage型が扱えないので、pngData型に変更
            favorite.image = videos[indexPath!.row].image.pngData()!
            favorite.videoid = videos[indexPath!.row].videoid
            realm.add(favorite, update: true)
            
            // Realmデータベースファイルまでのパスを表示
            print(Realm.Configuration.defaultConfiguration.fileURL!)
//            print("これが配列の中身です：\(favoriteVideoArray)")
        }
    
    }

    @IBAction func toFavoriteVC(_ sender: Any) {
//        print("選択されたお気に入り動画の配列：\(favoriteVideos)")
        let favoriteVideoVC = storyboard?.instantiateViewController(withIdentifier: "Favorite") as! FavoriteVideoViewController
          // 値を渡す → Realmから取得するため、不要になった
//        favoriteVideoVC.favoriteVideos = favoriteVideos
        navigationController?.pushViewController(favoriteVideoVC, animated: true)
    }
    
    
}
