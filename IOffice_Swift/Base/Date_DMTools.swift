//
//  File.swift
//  IOffice_Swift
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/7.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import Foundation

let yyyyMMdd = "yyyy-MM-dd"



extension Date
{
    var year: Int
    {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let date = formatter.string(from: self)
        return Int(date)!
    }
    
}



