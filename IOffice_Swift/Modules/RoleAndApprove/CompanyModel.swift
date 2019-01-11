//
//  CompanyModel.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/11.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class CompanyModel: DMBaseModel {

    var guid : String?;
    var company_name : String?;
    
    
    init(dict:[String:Any]) {
        guid = dmString(dict["guid"]);
        company_name = dmString(dict["company_name"]);
    }
}
