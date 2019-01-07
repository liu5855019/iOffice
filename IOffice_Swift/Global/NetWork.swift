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



let kRegistUrl = kServerIP + "/user/regist";
let kLoginUrl = kServerIP + "/user/login";


func get(url:String,
         para:Any,
         success:@escaping (_ result:Any) -> Void,
         failure:@escaping (_ err:Any ,_ code:Int , _ desc:String) -> Void) -> Void
{
    network(url: url,
            para: para,
            method: .get,
            encoding: URLEncoding.default,
            success: success,
            failure: failure);
}

func post(url:String,
          para:Any,
          success:@escaping (_ result:Any) -> Void,
          failure:@escaping (_ err:Any ,_ code:Int , _ desc:String) -> Void) -> Void
{
    network(url: url,
            para: para,
            method: .post,
            encoding: JSONEncoding.default,
            success: success,
            failure: failure);
}

func network(url:String,
             para:Any,
             method: HTTPMethod,
             encoding: ParameterEncoding,
             success:@escaping (_ result:Any) -> Void,
             failure:@escaping (_ err:Any ,_ code:Int , _ desc:String) -> Void) -> Void
{
    request(url,
            method: method,
            parameters: para as? Parameters,
            encoding: encoding,
            headers: nil)
        .responseJSON(completionHandler: { (DataResponse) in
            switch DataResponse.result {
            case .success(let value) :
                print(value);
                if (DataResponse.response?.statusCode == 200) {
                    print(Thread.current);
                    DispatchQueue.main.async {
                        success(value);
                    }
                } else {
                    DispatchQueue.main.async {
                        failure(value,(DataResponse.response?.statusCode)!,"");
                    }
                }
                break;
            case .failure(let err):
                print(err);
                DispatchQueue.main.async {
                    failure(err,DataResponse.response?.statusCode ?? -1,"");
                }
                break;
            }
        })
}






