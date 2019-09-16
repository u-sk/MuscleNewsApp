//
//  HomeViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    // PostDataクラスの配列
    var postArray: [PostData] = []
    // DatabaseのobserveEventの登録状態を表す
    var observing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        navigationController?.hidesBarsOnTap = false

        // Do any additional setup after loading the view.
        // テーブルビューデリゲート
        tableView.delegate = self
        tableView.dataSource = self
        
        // サーチバー初期設定
        searchBar.delegate = self
        searchBar.placeholder = "カテゴリーを入力してください"
        
        // テーブルセルのタップを無効にする
        tableView.allowsSelection = false
        
        // PostTableViewCell.xibファイルに作成したセルの定義内容をUINib(nibName:bundle)で取得
        // Outletで接続しているTableViewにregister(_:forCellReuseIdentifier:)メソッドで登録
        // Identifierは"Cell"
        let nib = UINib(nibName: "PostTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "Cell")
        
        // テーブル行の高さをAutoLayoutで自動調整する
        tableView.rowHeight = UITableView.automaticDimension
        // テーブル行の高さの概算値を設定しておく
        // 高さ概算値 = 「縦横比1:1のUIImageViewの高さ(=画面幅)」+「いいねボタン、キャプションラベル、その他余白の高さの合計概算(=100pt)」
        tableView.estimatedRowHeight = UIScreen.main.bounds.width + 100
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("DEBUG_PRINT: viewWillAppear")
        SVProgressHUD.show()
                
        // ＊ログアウト画面から新たにユーザーを作った後、settingVCからpopToRootViewController()で戻ってくる
        // -- ここから --
        // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
        // テーブルをクリアする
        postArray = []
        tableView.reloadData()
        // オブザーバーを削除する
        let postsRef = Database.database().reference().child(Const.PostPath)
        postsRef.removeAllObservers()
        
        // DatabaseのobserveEventが上記コードにより解除されたため
        // falseとする
        observing = false
         // -- ここまで --
        
        if Auth.auth().currentUser != nil {
            if self.observing == false {
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
               
                // 要素が変更されたら該当のデータをpostArrayから一度削除した後に新しいデータを追加してTableViewを再表示する
                postsRef.observe(.childChanged, with: { snapshot in
                    print("DEBUG_PRINT: .childChangedイベントが発生しました。")
                    
                    if let uid = Auth.auth().currentUser?.uid {
                        // PostDataクラスを生成して受け取ったデータを設定する
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        
                        // 保持している配列からidが同じものを探す
                        var index: Int = 0
                        for post in self.postArray {
                            if post.id == postData.id {
                                index = self.postArray.firstIndex(of: post)!
                                break
                            }
                        }
                        
                        // 差し替えるため一度削除する
                        self.postArray.remove(at: index)
                        
                        // 削除したところに更新済みのデータを追加する
                        self.postArray.insert(postData, at: index)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                
                // DatabaseのobserveEventが上記コードにより登録されたため
                // trueとする
                observing = true
            }
        } else {
            if observing == true {
                // ログアウトを検出したら、一旦テーブルをクリアしてオブザーバーを削除する。
                // テーブルをクリアする
                postArray = []
                tableView.reloadData()
                // オブザーバーを削除する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.removeAllObservers()
                
                // DatabaseのobserveEventが上記コードにより解除されたため
                // falseとする
                observing = false
            }
        }
        SVProgressHUD.dismiss()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得してデータを設定する
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! PostTableViewCell
        cell.setPostData(postArray[indexPath.row])
        // セル内のボタンのアクションをソースコードで設定する
        cell.likeButton.addTarget(self, action:#selector(handleButton(_:forEvent:)), for: .touchUpInside)
        // セル内のボタン(コメント作成のボタン)のアクションをソースコードで設定する
        cell.makeCommentButton.addTarget(self, action:#selector(makeComment(_:forEvent:)), for: .touchUpInside)
        
        return cell
    }
    
    // セルが削除が可能なことを伝えるメソッド
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        // 選択箇所のデータ一覧
        let postData = postArray[indexPath.row]
        // ログインユーザーIDと投稿ユーザーIDが一致する場合は「.delete」を返す
        if postData.userId == Auth.auth().currentUser?.uid {
            return .delete
        } else {
            // 一致しない場合は「.none」を返す
            return .none
        }
    }
    // Delete ボタンが押された時に呼ばれるメソッド
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // 選択箇所のデータ一覧
            let postData = postArray[indexPath.row]
            // 選択した投稿を削除する
            // 選択した投稿のデータの場所(Firebase上)
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            // 選択した投稿のデータの場所から削除(Firebase上)
            postRef.removeValue()
            // 選択した投稿のデータの配列
            self.postArray.remove(at: indexPath.row)
            // 選択した投稿のデータの配列をテーブルビュー上から削除
            tableView.deleteRows(at: [indexPath], with: .fade)
            // HUDで削除完了を表示する
            SVProgressHUD.showSuccess(withStatus: "削除しました")
        } else {
            return
        }
    }
    
    // セル内のボタン(コメント作成のボタン)がタップされた時に呼ばれるメソッド
    @objc func makeComment(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: コメント作成のボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        print("\(String(describing: indexPath))取得場所です。")
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        print("\(postData)これです")
        
        // CommentViewControllerへの遷移を行う
        let commentViewController = self.storyboard?.instantiateViewController(withIdentifier: "Comment") as! CommentViewController
        commentViewController.X = postData
        self.present(commentViewController, animated: true, completion: nil)
    }
    
    // セル内のボタンがタップされた時に呼ばれるメソッド
    @objc func handleButton(_ sender: UIButton, forEvent event: UIEvent) {
        print("DEBUG_PRINT: likeボタンがタップされました。")
        
        // タップされたセルのインデックスを求める
        let touch = event.allTouches?.first
        let point = touch!.location(in: self.tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        print("\(String(describing: indexPath))ハート取得場所です。")
        
        // 配列からタップされたインデックスのデータを取り出す
        let postData = postArray[indexPath!.row]
        
        print("\(postData)ハートこれです")
        // Firebaseに保存するデータの準備
        if let uid = Auth.auth().currentUser?.uid {
            if postData.isLiked {
                // すでにいいねをしていた場合はいいねを解除するためIDを取り除く
                var index = -1
                for likeId in postData.likes {
                    if likeId == uid {
                        // 削除するためにインデックスを保持しておく
                        index = postData.likes.firstIndex(of: likeId)!
                        break
                    }
                }
                postData.likes.remove(at: index)
            } else {
                postData.likes.append(uid)
            }
            
            // 増えたlikesをFirebaseに保存する
            let postRef = Database.database().reference().child(Const.PostPath).child(postData.id!)
            let likes = ["likes": postData.likes]
            postRef.updateChildValues(likes)
            
        }
    }
    
    //  サーチバータップ時、検索結果を絞り込み表示(検索文字列が何もない場合の解消含む)
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            // サーチバーが空欄の場合
            if text.isEmpty {
                print("空欄です")
                // キーボードを閉じる
                view.endEditing(true)
                
                // 要素が追加されたらpostArrayに追加してTableViewを再表示する
                let postsRef = Database.database().reference().child(Const.PostPath)
                postsRef.observe(.childAdded, with: { snapshot in
                    print("DEBUG_PRINT: .childAddedイベントが発生しました。")
                    
                    // PostDataクラスを生成して受け取ったデータを設定する
                    if let uid = Auth.auth().currentUser?.uid {
                        let postData = PostData(snapshot: snapshot, myId: uid)
                        self.postArray.insert(postData, at: 0)
                        
                        // TableViewを再表示する
                        self.tableView.reloadData()
                    }
                })
                
            } else {
                print("検索する文字列：\(text)")
                // キーボードを閉じる
                view.endEditing(true)
                // category部分で保存されているカテゴリーをsearchBarに入力したキーワードで検索する
                let ref = Database.database().reference().child(Const.PostPath).queryOrdered(byChild: "category").queryEqual(toValue:searchBar.text!)
                print("refです：\(ref)")
                // まとめて取得する
                ref.observeSingleEvent(of: .value, with: { (snapshot) in
                    // 差し替えるため一度削除する
                    self.postArray.removeAll()
                            // まとめて取得したデータをfor文で分割する
                            for item in snapshot.children {
                            let snap = item as! DataSnapshot
                                print("snapです：\(snap)")
                                // 分割したSnapshot型のデータからPostData型のデータを作る
                                if let uid = Auth.auth().currentUser?.uid {
                                    let postData = PostData(snapshot: snap, myId: uid)
                                     print("postDataです：\(postData)")
                                    // 検索後のデータを挿入
//                                    self.postArray.insert(postData, at: 0)
                                    self.postArray.append(postData)
                                    // 再表示
                                    self.tableView.reloadData()
                                }
                        }
                })
            }
        }
    }


}
