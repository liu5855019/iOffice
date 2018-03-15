//
//  DMTools.swift
//  IOffice_Swift
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/15.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class DMTools: NSObject {

    private override init() {}
    
    //MARK: - Documents
    
    /** 给出文件名获得其在doc中的路径 */
    static func filePathInDocument(file:String) -> String
    {
        var path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        path += "/\(file)"
        return path
    }
    
    /** 给出文件名获得其在Cache中的路径 */
    static func filePathInCaches(file:String) -> String
    {
        var path = NSSearchPathForDirectoriesInDomains(.cachesDirectory, .userDomainMask, true).first!
        path += "/\(file)"
        return path
    }
    
    /** 给出文件名获得其在Tmp中的路径 */
    static func filePathInTmp(file:String) -> String
    {
        var path = NSTemporaryDirectory()
        path += "\(file)"
        return path
    }
    
}
