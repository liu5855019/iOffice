//
//  FlowSelectVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/14.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class FlowSelectVC: DMBaseViewController,UITableViewDelegate,UITableViewDataSource {

    
    var didSelectBlock:((_ flows:[RoleModel]) -> Void)? = nil;
    

    
    var datas = [RoleModel]();
    var selectDatas = [RoleModel]();
    
    var flowLab = UILabel();
    var btn = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flow select";
        self.navigationItem.rightBarButtonItem = self.rightItem;
        
        self.setupViews();
        self.setupLayouts();
        
        self.loadRoleList();
    }
    
    func setupViews()
    {
        self.view.addSubview(flowLab);
        self.view.addSubview(btn);
        self.view.addSubview(self.tabV);
        
        flowLab.textColor = UIColor.black;
        flowLab.backgroundColor = UIColor.groupTableViewBackground;
        flowLab.font = UIFont.systemFont(ofSize: 12);
        
        btn.setTitle("<-", for: .normal);
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside);
        btn.setTitleColor(UIColor.blue, for: .normal);
    }
    
    func setupLayouts()
    {
        flowLab.snp.makeConstraints { (make) in
            make.top.equalTo(kNavHeight + 10);
            make.left.equalTo(15);
            make.height.equalTo(40);
        };
        
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(flowLab);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        };
        
        tabV.snp.makeConstraints { (make) in
            make.top.equalTo(flowLab.snp.bottom).offset(10);
            make.left.right.equalTo(0);
            make.bottom.equalTo(kSafeBottomHeight);
        };
    }
    
    //MARK: - ACTIONS
    @objc func clickBtn()
    {
        self.view.endEditing(true);
        
        if selectDatas.count > 0 {
            selectDatas.removeLast();
            updateLabel();
        }
    }
    
    @objc func clickRightItem()
    {
        self.view.endEditing(true);
        
        if selectDatas.count < 2 {
            self.view.makeToast("请最少选择两个角色");
        } else {
            if (didSelectBlock != nil) {
                didSelectBlock!(selectDatas);
            }
            self.navigationController?.popViewController(animated: true);
        }
    }
    
    func updateLabel()
    {
        var strArr = [String]();
        
        for role in selectDatas {
            strArr.append(role.role_name);
        }
        
        flowLab.text = strArr.joined(separator: "=>");
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
        
        cell?.textLabel?.text = datas[indexPath.row].role_name;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
        
        selectDatas.append(datas[indexPath.row]);
        
        updateLabel();
    }
    
    
    lazy var rightItem: UIBarButtonItem = {
        var _rightItem = UIBarButtonItem.init(title: "确定", style: .done, target: self, action: #selector(clickRightItem));
        return _rightItem;
    }();
    
    
    
    
    
    //MARK: - NET
    
    func loadRoleList()
    {
        post(url: kGetRoleListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [RoleModel] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(RoleModel.init(dict: tmpDict));
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
