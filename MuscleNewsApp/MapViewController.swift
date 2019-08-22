//
//  MapViewController.swift
//  MuscleNewsApp
//
//  Created by 板垣有祐 on 2019/08/21.
//  Copyright © 2019 Swift-Beginner. All rights reserved.
//

import UIKit
import GoogleMaps
import Alamofire
import SwiftyJSON
import SVProgressHUD


class MapViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    self.makeMap()
    }
    
    func makeMap() {
        SVProgressHUD.show()
        // 渋谷駅でカメラを作る
        let camera = GMSCameraPosition.camera(withLatitude: 35.658034, longitude: 139.701636, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // 渋谷駅でマーカーを作る
        //        let marker = GMSMarker()
        //        marker.position = CLLocationCoordinate2D(latitude: 35.658034, longitude: 139.701636)
        //        marker.title = "渋谷"
        //        marker.snippet = "渋谷駅"
        //        marker.map = mapView
        
        // HTTP通信
        Alamofire.request("https://map.yahooapis.jp/search/local/V1/localSearch?cid=d8a23e9e64a4c817227ab09858bc1330&lat=35.658034&lon=139.701636&dist=2&query=%E3%82%B9%E3%83%9D%E3%83%BC%E3%83%84%E3%82%B8%E3%83%A0%0A&appid=[APIキー]&output=json").responseJSON { response in
            // リクエスト
//                        print("Request: \(String(describing: response.request))")
            // レスポンス
            //            print("Response: \(String(describing: response.response))")
            // レスポンスの結果
            //            print("Result: \(response.result)")
            // 通信結果のJSON (ここまでがAlamofire)
            if let jsonObject = response.result.value {
                // JSONを表示
                //                print("JSON: \(jsonObject)")
                // 使いやすいJSONにしてくれる(ここからSwiftyJSON)
                let json = JSON(jsonObject)
                // Stringで取る
                let features = json["Feature"]
                
                // Featureは10個の配列なのでループを回して取る
                // 第一引数のkeyは使わないので、_にする
                for (_ ,subJson):(String, JSON) in features {
                    //                    print(subJson["Name"])
                    //                    print(subJson["Property"]["Address"])
                    //                    print(subJson["Geometry"]["Coordinates"])
                    let name = subJson["Name"].stringValue
                    let address = subJson["Property"]["Address"].stringValue
                    let coordinates = subJson["Geometry"]["Coordinates"].stringValue
                    // Coordinatesの文字列からカンマ区切りにして、配列にする
                    let coordinatesArray = coordinates.split(separator: ",")
                    //                    print(coordinatesArray)
                    let lat = coordinatesArray[1]
                    let lon = coordinatesArray[0]
                    // 文字列をDouble型に変換
                    let latDouble = Double(lat)
                    let lonDouble = Double(lon)
                    
                    // マーカーを作る
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2D(latitude: latDouble!, longitude: lonDouble!)
                    marker.title = name
                    marker.snippet = address
                    marker.map = mapView
                }
            } 
        }
        SVProgressHUD.dismiss()
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
