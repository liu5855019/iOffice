//
//  DMDBManager.swift
//  IOffice_Swift
//
//  Created by 呆木 on 2018/3/13.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class DMDBManager: NSObject {

    lazy var dataBase = FMDatabase.init(path: "")
    
    
    static let shareDB: DMDBManager = {
        
        let manager = DMDBManager()
        
        let result : Bool = (manager.dataBase?.open())!
        
        if (!result)
        {
            print(manager.dataBase?.lastErrorMessage() as Any)
            
        }
        
        return manager
    }()
    
    private override init() {}
    
    
    
    
    
}
