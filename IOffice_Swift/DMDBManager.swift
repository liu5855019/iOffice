//
//  DMDBManager.swift
//  IOffice_Swift
//
//  Created by 呆木 on 2018/3/13.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

let dbFile = "DATAS.db"

class DMDBManager: NSObject {
    
    let path = DMTools.filePathInDocument(file:dbFile)
    
    lazy var dataBase = FMDatabase.init(path: self.path)
    
    
    static let shareDB: DMDBManager? = {
        
        let manager = DMDBManager()
        
        let result : Bool = (manager.dataBase?.open())!
        
        if (!result)
        {
            print(manager.dataBase?.lastErrorMessage() as Any)
            return nil
        }
        
        if (manager.createLogTable()) { }
        
        
        
        return manager
    }()
    
    private override init() {}
    
    //func
    
    //创建log table
    func createLogTable() -> Bool
    {
        let sql = "create table if not exists logtable(ID integer primary key, time text,content text,page text)"
        
        let result = (self.dataBase?.executeStatements(sql))!
        
        if !result {
            print("创建 log 表失败");
            print("-----error-----:\(String(describing: self.dataBase?.lastErrorMessage()))")
        } else {
            print("创建 log 表成功")
        }
        return result
    }
    
    //插入 log 数据
    func insertLog(page:String , content:String , date:Date?) -> Bool
    {
        let timeStr = date == nil ? Date().detailString : date?.detailString
        
        let result = (self.dataBase?.executeUpdate("insert into logtable(page,content,time) values(?,?,?)", withArgumentsIn: [page,content,timeStr!]))!

        if !result {
            print("插入log失败");
            print("-----error-----:\(String(describing: self.dataBase?.lastErrorMessage()))")
        } else {
            print("插入log成功")
        }
        return result
    }
    
    func selectAllLogs() -> [Any]
    {
        let set = self.dataBase?.executeQuery("select * from logtable", withArgumentsIn: [])
        var muarray = [Any]()
        while (set?.next())! {
            let dict = set?.resultDictionary()
            muarray.append(dict!)
            print(dict as Any)
        }
        return muarray
    }
}
