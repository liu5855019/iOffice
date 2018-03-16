//
//  SignVC.swift
//  IOffice_Swift
//
//  Created by 呆木 on 2018/3/13.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class SignVC: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Sign VC"
        
        let _ = DMDBManager.shareDB?.insertLog(page: NSStringFromClass(self.classForCoder), content: "viewDidLoad", date: nil)
        
        self.setupViews()
    }
    
    func setupViews()
    {
        
    }

    

   
}
