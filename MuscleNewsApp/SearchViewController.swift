//
//  SearchViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/19.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var cowButton: UIButton!
    
    @IBOutlet weak var chickenButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // 牛
//        let cowImage = UIImage(named: "cow")
//        cowButton.setBackgroundImage(cowImage, for: .normal)
        cowButton.backgroundColor = UIColor.red
        
        // 鶏
//        let chickenImage = UIImage(named: "chicken")
//        chickenButton.setBackgroundImage(chickenImage, for: .normal)
        chickenButton.backgroundColor = UIColor.blue
    }
    
    
    @IBAction func tapCowButton(_ sender: Any) {
        let searchWord = "牛肉 筋肉"
        let query = searchWord.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        
        if let query = query,
            let url = URL(string: "https://www.google.com/search?q=\(query)&hl=ja&source=lnms&tbm=nws") {
            UIApplication.shared.open(url)
        }
    }
    
    @IBAction func tapChickenButton(_ sender: Any) {
        let searchWord = "鶏肉 筋肉"
        let query = searchWord.addingPercentEncoding(
            withAllowedCharacters: .urlQueryAllowed
        )
        
        if let query = query,
            let url = URL(string: "https://www.google.com/search?q=\(query)&hl=ja&source=lnms&tbm=nws") {
            UIApplication.shared.open(url)
        }
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
