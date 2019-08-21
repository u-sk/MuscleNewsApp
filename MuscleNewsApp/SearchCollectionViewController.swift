//
//  SearchCollectionViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/21.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SearchCell"

class SearchCollectionViewController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        
        //「SearchCollectionViewCell.xib」ファイルに作成したセルの定義内容をUINib(nibName:bundle)で取得します。
        self.collectionView!.register(UINib(nibName: "SearchCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! SearchCollectionViewCell
        
        // セル内のボタンのアクションをソースコードで設定する
        cell.tapCellButton.addTarget(self, action:#selector(tapButton(_:forEvent:)), for: .touchUpInside)
        
        // indexPath.rowによって配置する画像を変える
        switch indexPath.row {
        case 0:
            cell.tapCellButton.backgroundColor = UIColor.red
            let image = UIImage(named: "workout")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 1:
            cell.tapCellButton.backgroundColor = UIColor.blue
            let image = UIImage(named: "muscle")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 2:
            cell.tapCellButton.backgroundColor = UIColor.yellow
            let image = UIImage(named: "protein")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 3:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "supplement")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 4:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "weight-lost")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 5:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "salad")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 6:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "beaf")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 7:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "chicken")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 8:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "lamb")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 9:
            cell.tapCellButton.backgroundColor = UIColor.green
            let image = UIImage(named: "supplement")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
            
        default:
            break
        }
        return cell
    }
    
    // キーワード「word」で記事を検索する
    func searchNews(word:String) {
        let searchWord = word
        let query = searchWord.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        if let query = query,
            let url = URL(string: "https://www.google.com/search?q=\(query)&hl=ja&source=lnms&tbm=nws") {
            UIApplication.shared.open(url)
        }
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func tapButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: ボタンがタップされました")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.collectionView)
        let indexPath = collectionView.indexPathForItem(at: point)
        print(indexPath!.row)
        
        // indexPath.rowによって検索ワードを変える
        switch indexPath!.row {
        case 0:
            // キーワード「東京」で記事を検索する
            searchNews(word: "筋トレ")
            break
        case 1:
            searchNews(word: "マッチョ")
            break
        case 2:
            searchNews(word: "プロテイン")
            break
        case 3:
            searchNews(word: "筋肉 サプリメント")
            break
        case 4:
           searchNews(word: "減量")
            break
        case 5:
            searchNews(word: "サラダ 減量")
            break
        case 6:
            searchNews(word: "牛肉 筋肉")
            break
        case 7:
            searchNews(word: "鶏肉 筋肉")
            break
        case 8:
            searchNews(word: "羊肉 筋肉")
            break
        case 9:
            searchNews(word: "馬肉 筋肉")
            break
        default:
            break
        }
        
        
        
        
        // MARK: UICollectionViewDelegate
        
        /*
         // Uncomment this method to specify if the specified item should be highlighted during tracking
         override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment this method to specify if the specified item should be selected
         override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
         return true
         }
         */
        
        /*
         // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
         override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
         return false
         }
         
         override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
         
         }
         */
        
    }
}
