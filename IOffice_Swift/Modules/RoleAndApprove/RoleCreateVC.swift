//
//  RoleCreateVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/7.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class RoleCreateVC: DMBaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Role create"
        
        createRole();
    }
    

    func createRole() {
        let para = ["roleName":"aaa"];
        
        post(url: kCreateRoleUrl, para: para, success: { (value) in
            
            
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
    
    
    
    

}
