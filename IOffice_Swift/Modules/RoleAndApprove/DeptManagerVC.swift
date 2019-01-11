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


class DeptManagerVC: DMBaseViewController,UITableViewDelegate,UITableViewDataSource {
    
    var datas = [DeptModel]();
    var companyDatas = [CompanyModel]();
    
    var companyTF = IQDropDownTextField();
    var deptTF = UITextField();
    var btn = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Company";
        
        self.setupViews();
        self.setupLayouts();
        
        self.loadCompanyList();
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
            make.top.equalTo(companyTF)
        }
        
        btn.snp.makeConstraints { (make) in
            make.centerY.equalTo(nameTF);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        };
        
        tabV.snp.makeConstraints { (make) in
            make.top.equalTo(nameTF.snp_bottomMargin);
            make.left.right.equalTo(0);
            make.bottom.equalTo(kSafeBottomHeight);
        };
    }
    
    //MARK: - ACTIONS
    @objc func clickBtn()
    {
        self.view.endEditing(true);

        guard nameTF.selectedRow >= 0 else {
            self.view.makeToast("please select company");
            return;
        }

        self.createCompany(companyName: nameTF.selectedItem!);
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
        
        cell?.textLabel?.text = datas[indexPath.row].company_name;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
    //MARK: - NET
    
    func createCompany(companyName:String)
    {
        let para = ["companyName":companyName];
        
        post(url: kCreateCompanyUrl, para:para, success: {[weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                self?.view.makeToast("添加成功");
                self?.nameTF.selectedItem = "";
                self?.loadCompanyList();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        };
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
                self?.nameTF.itemList = muStrArr;
                self?.tabV.reloadData();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
}
