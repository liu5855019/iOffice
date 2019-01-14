//
//  ModuleManagerVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/14.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit
import PKHUD

class ModuleManagerVC: DMBaseViewController , UITableViewDataSource , UITableViewDelegate {

    var datas = [ModuleModel]();
    
    var nameTF = UITextField();
    var btn = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Module";
        
        self.setupViews();
        self.setupLayouts();
        
        self.loadModuleList();
    }
    
    func setupViews()
    {
        self.view.addSubview(nameTF);
        self.view.addSubview(btn);
        self.view.addSubview(self.tabV);
        
        nameTF.textColor = UIColor.black;
        nameTF.backgroundColor = UIColor.groupTableViewBackground;
        
        btn.setTitle("submit", for: .normal);
        btn.addTarget(self, action: #selector(clickBtn), for: .touchUpInside);
        btn.setTitleColor(UIColor.blue, for: .normal);
    }
    
    func setupLayouts()
    {
        nameTF.snp.makeConstraints { (make) in
            make.top.equalTo(kNavHeight + 10);
            make.left.equalTo(15);
            make.height.equalTo(40);
            make.width.equalTo(kScaleW(200));
        };
        
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
        
        guard nameTF.text?.count ?? 0 > 0 else {
            self.view.makeToast("please input module name");
            return;
        }
        
        self.createModule(module_name: nameTF.text!);
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
        
        cell?.textLabel?.text = datas[indexPath.row].module_name;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
    //MARK: - NET
    
    func createModule(module_name:String)
    {
        HUD.show(.systemActivity, onView: self.view);
        let para = ["module_name":module_name];
        
        post(url: kCreateModuleUrl, para:para, success: {[weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                self?.view.makeToast("添加成功");
                self?.nameTF.text = "";
                self?.loadModuleList();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
            HUD.hide();
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
            HUD.hide();
        };
    }
    
    func loadModuleList()
    {
        post(url: kGetModuleListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [ModuleModel] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(ModuleModel.init(dict: tmpDict));
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
