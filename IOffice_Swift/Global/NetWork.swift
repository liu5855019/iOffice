//
//  UrlDefine.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2018/12/28.
//  Copyright © 2018 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit
import Alamofire


//let kServerIP = "http://192.168.100.121:3000";

let kServerIP = "http://47.105.171.135:3000";



let kRegistUrl = kServerIP + "/user/register";


func get(url:String,
         para:Any,
         success:(_ result:Any) -> Void,
         failure:(_ err:Any ,_ code:Int , _ desc:String) -> Void) -> Void {
    request(kRegistUrl,
            method: .get,
            parameters: nil,
            encoding:URLEncoding.default ,
            headers: nil)
        .responseString { (DataResponse) in
            print(DataResponse);
            
            switch DataResponse.result {
            case .success(let resultStr) :
                print(resultStr);
                print(DataResponse.response?.statusCode as Any);
                if (DataResponse.response?.statusCode == 200) {
                    
                } else {
                    
                }
                
                break;
            case .failure(let err):
                print(err);
                break;
            }
    }
}
