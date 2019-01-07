//
//  HomeVC.swift
//  IOffice_Swift
//
//  Created by 呆木 on 2018/3/13.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class HomeVC: DMBaseViewController , UITableViewDataSource , UITableViewDelegate {
    

    let datas = ["RoleCreateVC",
                 ];
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Home VC"
        
        self.setupViews()
    }
    
    func setupViews()
    {
        self.view.addSubview(tabV);
    }

    //MARK: - TABLEVIEW
    lazy var tabV: UITableView = {
        let _tabV = UITableView.init(frame: CGRect.init(x: 0, y: kNavHeight, width: kScreenH, height: kScreenH - kNavHeight - kSafeBottomHeight), style: .plain);
        DMTools.AdjustsScrollViewInsetNever(self, _tabV);
        _tabV.delegate = self;
        _tabV.dataSource = self;
        _tabV.estimatedRowHeight = 60;
        _tabV.rowHeight = UITableView.automaticDimension;
        _tabV.tableFooterView = UIView.init(frame: CGRect.zero);
        _tabV.separatorStyle = .singleLine;
        return _tabV;
    }();
    
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell");
        }
        
        cell?.textLabel?.text = datas[indexPath.row];
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
        
        let cls : AnyClass? = NSClassFromString(datas[indexPath.row]);
        if cls != nil {
            if cls is UIViewController.Type {
                let vcCls = cls as! UIViewController.Type;
                let vc = vcCls.init();
                self.navigationController?.pushViewController(vc, animated: true);
            }
        }
        
        
    }

}
