//
//  DeptManagerVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/11.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import IQDropDownTextField
import PKHUD


class DeptManagerVC: DMBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var deptDatas = [DeptModel]();
    var companyDatas = [CompanyModel]();
    
    var companyTF = IQDropDownTextField();
    var deptTF = UITextField();
    var btn = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Department";
        
        self.setupViews();
        self.setupLayouts();
        
        self.loadCompanyList();
        self.loadDeptList();
    }
    
    func setupViews()
    {
        self.view.addSubview(companyTF);
        self.view.addSubview(deptTF)
        self.view.addSubview(btn);
        self.view.addSubview(self.tabV);
        
        
        companyTF.textColor = UIColor.black;
        companyTF.backgroundColor = UIColor.groupTableViewBackground;
        companyTF.optionalItemText = "请选择";
        
        deptTF.textColor = UIColor.black;
        deptTF.backgroundColor = UIColor.groupTableViewBackground;
        
        
        btn.setTitle("submit", for: .normal);
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside);
        btn.setTitleColor(UIColor.blue, for: .normal);
    }
    
    func setupLayouts()
    {
        companyTF.snp.makeConstraints { (make) in
            make.top.equalTo(kNavHeight + 10);
            make.left.equalTo(15);
            make.height.equalTo(40);
            make.width.equalTo(kScaleW(200));
        };
        
        deptTF.snp.makeConstraints { (make) in
            make.top.equalTo(companyTF.snp.bottom).offset(10);
            make.left.width.height.equalTo(companyTF);
        };
        
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(deptTF);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        };
        
        tabV.snp.makeConstraints { (make) in
            make.top.equalTo(deptTF.snp.bottom).offset(10);
            make.left.right.equalTo(0);
            make.bottom.equalTo(kSafeBottomHeight);
        };
    }
    
    //MARK: - ACTIONS
    @objc func clickBtn()
    {
        self.view.endEditing(true);

        guard companyTF.selectedRow >= 0 else {
            self.view.makeToast("please select company");
            return;
        }
        
        guard deptTF.text?.count ?? 0 > 0 else {
            self.view.makeToast("please input dept name");
            return;
        }

        self.createDept(departmentName: deptTF.text!, companyGuid: companyDatas[companyTF.selectedRow].guid!);
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
        return deptDatas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell");
        }
        
        cell?.textLabel?.text = deptDatas[indexPath.row].department_name;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
    //MARK: - NET
    
    func createDept(departmentName:String,companyGuid:String)
    {
        HUD.show(.systemActivity, onView: self.view);
        
        let para = ["departmentName":departmentName,
                    "companyGuid":companyGuid];
        
        post(url: kCreateDeptUrl, para:para, success: {[weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                self?.view.makeToast("添加成功");
                self?.deptTF.text = "";
                self?.companyTF.selectedRow = -1;
                self?.loadDeptList();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
            HUD.hide();
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
            HUD.hide();
        };
    }
    
    
    func loadDeptList()
    {
        post(url: kGetDeptListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [DeptModel] = [];

                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(DeptModel.init(dict: tmpDict));
                }
                self?.deptDatas = muarray;
                self?.tabV.reloadData();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
    
    
    func loadCompanyList()
    {
        post(url: kGetCompanyListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [CompanyModel] = [];
                var muStrArr : [String] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(CompanyModel.init(dict: tmpDict));
                    muStrArr.append(dmString(tmpDict["company_name"]));
                }
                self?.companyDatas = muarray;
                self?.companyTF.itemList = muStrArr;
                self?.tabV.reloadData();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
}
