//
//  ViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import ESTabBarController
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupTab()
    }

    func setupTab() {
        
        // 画像のファイル名を指定してESTabBarControllerを作成する
        let tabBarController: ESTabBarController! = ESTabBarController(tabIconNames: ["home", "youtube", "camera", "search", "map"])
        
        // 背景色、選択時の色を設定する
        tabBarController.selectedColor = UIColor(red: 250/255, green: 128/255, blue: 114/255, alpha: 1)
        tabBarController.buttonsBackgroundColor = UIColor(red: 250/255, green: 128/255, blue: 114/255, alpha: 0.5)
        tabBarController.selectionIndicatorHeight = 5
        
        // 作成したESTabBarControllerを親のViewController（＝self）に追加する
        addChild(tabBarController)
        let tabBarView = tabBarController.view!
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tabBarView)
        let safeArea = view.safeAreaLayoutGuide
        NSLayoutConstraint.activate([
            tabBarView.topAnchor.constraint(equalTo: safeArea.topAnchor),
            tabBarView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            tabBarView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            tabBarView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            ])
        tabBarController.didMove(toParent: self)
        
        // タブをタップした時に表示するViewControllerを設定する
        let navigationController = storyboard?.instantiateViewController(withIdentifier: "Nav")
        let videoNavigationController = storyboard?.instantiateViewController(withIdentifier: "VideoNav")
        let searchNavigationController = storyboard?.instantiateViewController(withIdentifier: "SearchNav")
        let mapNavigationController = storyboard?.instantiateViewController(withIdentifier: "MapNav")

        tabBarController.setView(navigationController, at: 0)
        tabBarController.setView(videoNavigationController , at: 1)
        tabBarController.setView(searchNavigationController, at: 3)
        tabBarController.setView(mapNavigationController, at: 4)
        
        // 真ん中のタブはボタンとして扱う
        tabBarController.highlightButton(at: 2)
        tabBarController.setAction({
            // ボタンが押されたらImageViewControllerをモーダルで表示する
            let imageViewController = self.storyboard?.instantiateViewController(withIdentifier: "ImageSelect")
            self.present(imageViewController!, animated: true, completion: nil)
        }, at: 2)
    }
    
    // ViewController.swiftのviewDidAppear(_:)メソッドをオーバーライドする
    // viewDidAppear(_:)メソッドの中でログインしているか確認する
    // ログインしていなければLoginViewControllerをモーダルで表示する
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // curentUserがnilならごログインしていない
        if Auth.auth().currentUser == nil {
            // ログインしていない時の処理
            // 該当のViewControllerを得る(Storyboad ID)
            let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            // モーダル表示
            self.present(loginViewController!, animated: true, completion: nil)
        }
}

}
