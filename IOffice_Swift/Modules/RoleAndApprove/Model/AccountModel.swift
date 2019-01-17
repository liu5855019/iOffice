//
//  AccountModel.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/17.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class AccountModel: DMBaseModel {
    
    var guid : String?;
    var username : String?;
    
    
    init(dict:[String:Any]) {
        guid = dmString(dict["guid"]);
        username = dmString(dict["username"]);
    }
    
}
