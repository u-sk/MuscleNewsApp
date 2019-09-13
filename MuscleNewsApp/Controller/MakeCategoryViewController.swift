//
//  MakeCategoryViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD
import RealmSwift

class MakeCategoryViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var makeCategoryTextField: UITextField!
    
    // Realmインスタンスを取得
    let realm = try! Realm()
    // categoryを定義
    var category: Category!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // テキストフィールドデリゲート
        makeCategoryTextField.delegate = self
    }
    
    
    // 作成ボタンをタップした時
    @IBAction func pushCategoryButton(_ sender: Any) {
        // カテゴリー作成欄が空文字の場合、カテゴリー作成しない
        if let title = makeCategoryTextField.text {
            if title.isEmpty {
                return
            } else {
                print(makeCategoryTextField.text!)
                try! realm.write {
                    // カテゴリーを追加
                    self.category.categoryName = self.makeCategoryTextField.text!
                    self.realm.add(self.category, update: true)
                    // Realmデータベースファイルまでのパスを表示
                    print(Realm.Configuration.defaultConfiguration.fileURL!)
                    // 画面を閉じる
                    dismiss(animated: true, completion: nil)
                    // HUDで作成完了を表示する
                    SVProgressHUD.showSuccess(withStatus: "カテゴリーを作成しました")
                }
            }
    }
    }
    // キャンセルボタンをタップした時
    @IBAction func cancelButton(_ sender: Any) {
        // 画面を閉じる
        self.dismiss(animated: true, completion: nil)
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
