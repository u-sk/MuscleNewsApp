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

class VideoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate  {
    @IBOutlet weak var videoList: UITableView!

    
    var videos:[Video] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()


        
        
        // tableViewデリゲート
        videoList.dataSource = self
        videoList.delegate = self
        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "VideoTableViewCell", bundle: nil)
        videoList.register(nib, forCellReuseIdentifier: "VideoCell")
        
        self.setupVideo()
    }
    
    func setupVideo() {
            SVProgressHUD.show()
        Alamofire.request("https://www.googleapis.com/youtube/v3/search?key=[APIキー]&q=%E7%AD%8B%E3%83%88%E3%83%AC%0D%0A&part=id,snippet&maxResults=30&order=viewCount").responseJSON { response in
            // 通信結果のJSON (ここまでがAlamofire)
            if let jsonObject = response.result.value {
                // 使いやすいJSONにしてくれる(ここからSwiftyJSON)
                let json = JSON(jsonObject)
                // Stringで取る
                let Items = json["items"]
                
                var videoDatas: [Video] = []
                // Featureは10個の配列なのでループを回して取る
                // 第一引数のkeyは使わないので、_にする
                for (_ ,subJson):(String, JSON) in Items {
//                    print("タイトル：\(subJson["snippet"]["title"])")
//                    print("チャンネル名：\(subJson["snippet"]["channelTitle"])")
//                    print("キャプション：\(subJson["snippet"]["description"])")
//                    print("サムネ：\(subJson["snippet"]["thumbnails"]["medium"]["url"])")
                    
                    let imageUrl:String = subJson["snippet"]["thumbnails"]["medium"]["url"].string!
                    let image: UIImage? = UIImage(data: NSData(contentsOf: NSURL(string: imageUrl)! as URL)! as Data)

                    
                    let video: Video = Video.init(title: subJson["snippet"]["title"].string!, name: subJson["snippet"]["channelTitle"].string!, image: image!)
                    videoDatas.append(video)
                    print(videoDatas)
                }
                self.videos = videoDatas
                self.videoList.reloadData()
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "VideoCell", for: indexPath) as! VideoTableViewCell
        cell.setCell(videos[indexPath.row])
        // セル内のボタンのアクションをソースコードで設定する
        cell.tapVideoButton.addTarget(self, action:#selector(tapVideoButton(_:forEvent:)), for: .touchUpInside)
        return cell
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func tapVideoButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: 動画ボタンがタップされました")
        // タップされたセルのインデックスを求める
            let touch = event.allTouches?.first
            let point = touch!.location(in: self.videoList)
            let indexPath = videoList.indexPathForRow(at: point)
        print("ここが場所です：\(indexPath!.row)")
        
    }

}
