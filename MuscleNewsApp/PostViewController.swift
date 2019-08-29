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
import RealmSwift


class PostViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // Realmインスタンスを取得する
    let realm = try! Realm()
    // categoryを定義
    var category: Category!
    
    // DB内のタスクが格納されるリスト。
    // 以降内容をアップデートするとリスト内は自動的に更新される。
    var categoryArray = try! Realm().objects(Category.self)
    
    var image: UIImage!
//    var categoryList: [String] = []
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
    
    // カテゴリー作成ボタンを押した時に実行されるメソッド
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 遷移させる
        performSegue(withIdentifier: "toMakeCategory",sender: nil)
    }
    // segue "toMakeCategory"で画面遷移する時に呼ばれる
    // Categoryクラスのインスタンスを生成してMakeCategoryViewControllerのcategoryプロパティに値を指定
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let makeCategoryViewController:MakeCategoryViewController = segue.destination as! MakeCategoryViewController
        let categoryData = Category()
        let allCategoryData = realm.objects(Category.self)
        if allCategoryData.count != 0 {
            categoryData.id = allCategoryData.max(ofProperty: "id")! + 1
        }
        makeCategoryViewController.category = categoryData
    }

    // カテゴリ削除ボタンを押した時
    @IBAction func deleteCategoryButton(_ sender: Any) {
        // ポップアップを追加する
        let alertController = UIAlertController(title: "選択したカテゴリーを削除しますか？", message: nil, preferredStyle: .alert)
        let action:UIAlertAction = UIAlertAction(title: "削除", style: .default) { (void) in
            
            if self.pickerView.selectedRow(inComponent: 0) > 2 {
                // データベースから削除する
                try! self.realm.write {
                    self.realm.delete(self.categoryArray[self.pickerView.selectedRow(inComponent: 0)])
                }
                // ピッカービュー更新
                self.pickerView.reloadAllComponents()
            } else {
                SVProgressHUD.showSuccess(withStatus: "基本カテゴリーの為、削除できません")
                return
            }

            // HUDで削除を表示する
            SVProgressHUD.showSuccess(withStatus: "カテゴリーが削除されました")
        }
        let cancel:UIAlertAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alertController.addAction(action)
        alertController.addAction(cancel)
        present(alertController, animated: true, completion: nil)
    }
    
    // MakeCategoryViewController(カテゴリー作成画面)から戻ってきた時
    override func viewWillAppear(_ animated: Bool) {
        categoryArray = realm.objects(Category.self)
//        categoryList = []
//
//        for category in categoryArray {
//            categoryList.append(category.categoryName)
//        }
        // ピッカービュー更新
        pickerView.reloadAllComponents()
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
        
        // 追加するデータを用意(初期値)
        let categoryData1 = Category()
        categoryData1.id = 1
        categoryData1.categoryName = "AAA"
        // データを追加
        try! realm.write() {
            realm.add(categoryData1, update: true)
        }
        
        let categoryData2 = Category()
        categoryData2.id = 2
        categoryData2.categoryName = "BBB"
        // データを追加
        try! realm.write() {
            realm.add(categoryData2, update: true)
        }
        
        let categoryData3 = Category()
        categoryData3.id = 3
        categoryData3.categoryName = "CCC"
        // データを追加
        try! realm.write() {
            realm.add(categoryData3, update: true)
        }
        
    }
    
    // UIPickerViewの列の数
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // UIPickerViewの行数、要素の全数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return categoryArray.count
    }

    // UIPickerViewに表示する配列
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return categoryArray[row].categoryName
    }
    
    // UIPickerViewのRowが選択された時の挙動
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // 処理
        selectedCategory = categoryArray[row].categoryName
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
