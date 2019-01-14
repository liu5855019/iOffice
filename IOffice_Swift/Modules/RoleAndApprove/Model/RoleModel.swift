//
//  RoleModel.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/14.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class RoleModel: DMBaseModel {

    var guid : String?;
    var role_name : String?;
    
    
    init(dict:[String:Any]) {
        guid = dmString(dict["guid"]);
        role_name = dmString(dict["role_name"]);
    }
    
}
