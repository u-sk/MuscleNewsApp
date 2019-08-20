//
//  CommentViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class CommentViewController: UIViewController {

    var X: PostData!
    
    @IBOutlet weak var editCommentTextField: UITextField!
    
    // 投稿ボタンを押したとき
    @IBAction func postCommentButton(_ sender: Any) {
        print(editCommentTextField.text!)
        
        // 辞書を作成してFirebaseに保存する(更新)
        let postRef = Database.database().reference().child(Const.PostPath).child(X.id!)
        // コメントを追加
        X.comment.append(editCommentTextField.text!)
        // 投稿者を追加
        X.poster.append((Auth.auth().currentUser?.displayName)!)
        // コメントと投稿者が追加された状態で更新
        let postCommentDic = ["comment": X.comment, "poster": X.poster]
        postRef.updateChildValues(postCommentDic)
        
        print(postCommentDic)
        print("\(postCommentDic.count)postCommentDicの要素数")
        print("\(X.comment.count)コメントの要素数")
        print("\(X.poster.count)投稿者の要素数")
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    
    // キャンセルボタンを押したとき
    @IBAction func cancelCommentButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
