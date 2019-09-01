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
        
        // レイアウト設定(全て余白無し/縦横同じ比率)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: self.view.frame.width / 2, height: self.view.frame.width / 2)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        collectionView.collectionViewLayout = layout
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
            let image = UIImage(named: "workout")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 1:
            let image = UIImage(named: "muscle")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 2:
            let image = UIImage(named: "protein")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 3:
            let image = UIImage(named: "supplement")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 4:
            let image = UIImage(named: "weight-lost")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 5:
            let image = UIImage(named: "salad")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 6:
            let image = UIImage(named: "beaf")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 7:
            let image = UIImage(named: "chicken")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 8:
            let image = UIImage(named: "lamb")
            cell.tapCellButton.setBackgroundImage(image, for: .normal)
            break
        case 9:
            let image = UIImage(named: "horse")
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
        
    }
}
