//
//  FlowModel.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/14.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class FlowModel: DMBaseModel {

    var guid : String?;
    var flow_name : String?;
    
    
    init(dict:[String:Any]) {
        guid = dmString(dict["guid"]);
        flow_name = dmString(dict["flow_name"]);
    }
    
}
