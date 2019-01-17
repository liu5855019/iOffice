//
//  UserInfoModel.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/17.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class UserInfoModel: DMBaseModel {
    var guid = "";
    var account_guid = "";
    var user_name = "";
    var department_guid = "";
    var department_name = "";
    var role_guid = "";
    var role_name = "";
    
    init(dict:[String:Any]) {
        guid = dmString(dict["guid"]);
        account_guid = dmString(dict["account_guid"]);
        user_name = dmString(dict["user_name"]);
        department_guid = dmString(dict["department_guid"]);
        department_name = dmString(dict["department_name"]);
        role_guid = dmString(dict["role_guid"]);
        role_name = dmString(dict["role_name"]);
    }
}
