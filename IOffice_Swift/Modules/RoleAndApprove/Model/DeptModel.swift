//
//  DeptModel.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/11.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class DeptModel: DMBaseModel {

    var guid = "";
    var department_name = "";
    var company_guid = "";
    
    init(dict:[String:Any]) {
        guid = dmString(dict["guid"]);
        department_name = dmString(dict["department_name"]);
        company_guid = dmString(dict["company_guid"]);
    }
}
