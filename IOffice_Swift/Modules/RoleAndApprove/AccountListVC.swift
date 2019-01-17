//
//  AccountListVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/17.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class AccountListVC: DMBaseViewController , UITableViewDelegate, UITableViewDataSource {

    var datas = [AccountModel]();
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.view.addSubview(self.tabV);
        
        self.getAccountList();
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
        _tabV.separatorStyle = .none;
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
        
        cell?.textLabel?.text = datas[indexPath.row].username;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
        
        let vc = UserInfoVC();
        vc.account = datas[indexPath.row];
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    //MARK: - NET
    
    func getAccountList() {
        post(url: kGetAccountListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [AccountModel] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(AccountModel.init(dict: tmpDict));
                }
                self?.datas = muarray;
                self?.tabV.reloadData();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
    
}
