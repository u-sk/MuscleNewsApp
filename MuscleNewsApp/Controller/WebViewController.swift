//
//  WebViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/09/23.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, WKUIDelegate {
    
    var webView = WKWebView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // webView
        webView.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height - 50)
        view.addSubview(webView)
        
        // 戻るボタン
        let button = UIButton(type: .system)
        button.addTarget(self, action: #selector(backButton(_ :)), for: .touchUpInside)
        button.setTitle("戻る", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.frame = CGRect(x: 0, y: self.view.frame.size.height - 50, width: self.view.frame.size.width, height: 50)
        self.view.addSubview(button)
        
        // 動画のURLを受け取る
        // 指定のURLから遷移する。
        if UserDefaults.standard.object(forKey: "url") != nil {
            let urlString = UserDefaults.standard.object(forKey: "url")
            let url = URL(string: urlString as! String)
            let request = URLRequest(url: url!)
            webView.load(request)
        }
        
    }
    
    // 戻るボタンをタップした時に呼ばれるメソッド
    @objc func backButton(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
}
