//
//  PostViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class PostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    var image: UIImage!
    var categoryList = ["AAA", "BBB", "CCC", "DDD"]
    // pickerViewで選択した要素の入れ物
    var selectedCategory: String = ""

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!
    // ピッカービュー
    @IBOutlet weak var pickerView: UIPickerView!
    // カテゴリー作成ボタンをタップしたときに呼ばれるメソッド
    @IBAction func makeCategoryButton(_ sender: Any) {
    }
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var urlTextField: UITextField!
    
    // 投稿ボタンをタップしたときに呼ばれるメソッド
    @IBAction func handlePostButton(_ sender: Any) {
        // ImageViewから画像を取得する
        let imageData = imageView.image!.jpegData(compressionQuality: 0.5)
        let imageString = imageData!.base64EncodedString(options: .lineLength64Characters)
        
        // postDataに必要な情報を取得しておく
        let time = Date.timeIntervalSinceReferenceDate
        let name = Auth.auth().currentUser?.displayName
        
        // 辞書を作成してFirebaseに保存する
        let postRef = Database.database().reference().child(Const.PostPath)
        let postDic = ["caption": captionTextField.text!, "category": selectedCategory, "url": urlTextField.text!, "image": imageString, "time": String(time), "name": name!]
        postRef.childByAutoId().setValue(postDic)
        // HUDで投稿完了を表示する
        SVProgressHUD.showSuccess(withStatus: "投稿しました")
        // 全てのモーダルを閉じる
        UIApplication.shared.keyWindow?.rootViewController?.dismiss(animated: true, completion: nil)
    }
    // キャンセルボタンをタップしたときに呼ばれるメソッド
    @IBAction func handkleCancelButton(_ sender: Any) {
        // 画面を閉じる
        dismiss(animated: true, completion: nil)
    }
    
    // TextField以外をタップして閉じる
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        captionTextField.resignFirstResponder()
        urlTextField.resignFirstResponder()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // 受け取った画像をImageViewに設定する
        imageView.image = image
        
        // pickerViewDelegate設定
        pickerView.delegate = self
        pickerView.dataSource = self
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryList.count
    }

    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryList[row]
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 処理
        selectedCategory = categoryList[row]
        print(" \(selectedCategory) が選択された。")
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
