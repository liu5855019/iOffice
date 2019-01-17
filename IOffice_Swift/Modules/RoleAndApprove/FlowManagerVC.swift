//
//  FlowManagerVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/14.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit
import IQDropDownTextField
import PKHUD

class FlowManagerVC: DMBaseViewController , UITableViewDataSource , UITableViewDelegate {

    var flowDatas = [FlowModel]();
    var moduleDatas = [ModuleModel]();
    var selectFlows = [RoleModel]();
    
    var flowNameTF = UITextField();
    
    var flowLab = UILabel();
    var flowBtn = UIButton();
    
    var moduleTF = IQDropDownTextField();
    var submitBtn = UIButton();
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Flow";
        
        self.setupViews();
        self.setupLayouts();
        
        self.loadFlowList();
        self.loadModuleList();
    }
    
    func setupViews()
    {
        self.view.addSubview(flowNameTF);
        self.view.addSubview(flowLab);
        self.view.addSubview(flowBtn);
        self.view.addSubview(moduleTF);
        self.view.addSubview(submitBtn);
        
        self.view.addSubview(self.tabV);
        
        
        flowNameTF.textColor = UIColor.black;
        flowNameTF.backgroundColor = UIColor.groupTableViewBackground;
        
        flowLab.textColor = UIColor.black;
        flowLab.text = "流程";
        flowLab.font = UIFont.systemFont(ofSize: 12);
        
        
        flowBtn.setTitle("请选择", for: .normal);
        flowBtn.setTitleColor(UIColor.blue, for: .normal);
        flowBtn.addTarget(self, action: #selector(clickFlowBtn), for: .touchUpInside);
        
        
        
        moduleTF.textColor = UIColor.black;
        moduleTF.backgroundColor = UIColor.groupTableViewBackground;
        moduleTF.optionalItemText = "请选择";
        
        
        submitBtn.setTitle("submit", for: .normal);
        submitBtn.addTarget(self, action: #selector(clickSubmitBtn), for: .touchUpInside);
        submitBtn.setTitleColor(UIColor.blue, for: .normal);
    }
    
    func setupLayouts()
    {
        flowNameTF.snp.makeConstraints { (make) in
            make.top.equalTo(kNavHeight + 10);
            make.left.equalTo(15);
            make.height.equalTo(40);
            make.width.equalTo(kScaleW(200));
        };
        
        flowLab.snp.makeConstraints { (make) in
            make.top.equalTo(flowNameTF.snp.bottom).offset(10);
            make.left.height.equalTo(flowNameTF);
        };
        
        flowBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(flowLab);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        };
        
        moduleTF.snp.makeConstraints { (make) in
            make.top.equalTo(flowLab.snp.bottom).offset(10);
            make.left.width.height.equalTo(flowNameTF);
        };
        
        submitBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(moduleTF);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        };
        
        tabV.snp.makeConstraints { (make) in
            make.top.equalTo(moduleTF.snp.bottom).offset(10);
            make.left.right.equalTo(0);
            make.bottom.equalTo(kSafeBottomHeight);
        };
    }
    
    //MARK: - ACTIONS
    
    @objc func clickFlowBtn()
    {
        self.view.endEditing(true);
        
        let vc = FlowSelectVC();
        vc.didSelectBlock =  { (flows) in
            self.selectFlows = flows;
            self.updateFlowLab();
        }
        self.navigationController?.pushViewController(vc, animated: true);
    }
    
    
    @objc func clickSubmitBtn()
    {
        self.view.endEditing(true);
        
        guard flowNameTF.text?.count ?? 0 > 1 else {
            self.view.makeToast("please input flow name");
            return;
        }
        
        guard selectFlows.count > 1 else {
            self.view.makeToast("please select flow");
            return;
        }
        
        guard moduleTF.selectedRow >= 0 else {
            self.view.makeToast("please select module");
            return;
        }

        self.createFlow(flow_name: flowNameTF.text!, module_guid: moduleDatas[moduleTF.selectedRow].guid!);
    }
    
    func updateFlowLab()
    {
        var strArr = [String]();
        
        for role in selectFlows {
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
        return flowDatas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCell(withIdentifier: "cell");
        
        if cell == nil {
            cell = UITableViewCell.init(style: .default, reuseIdentifier: "cell");
        }
        
        cell?.textLabel?.text = flowDatas[indexPath.row].flow_name;
        
        return cell!;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        tableView.deselectRow(at: indexPath, animated: true);
    }
    
    
    //MARK: - NET
    
    func createFlow(flow_name:String,module_guid:String)
    {
        HUD.show(.systemActivity, onView: self.view);

        var flowStrs = [String]();
        for role in selectFlows {
            flowStrs.append(role.guid);
        }

        let para = ["flow_name":flow_name,
                    "module_guid":module_guid,
                    "flows":flowStrs] as [String : Any];

        post(url: kCreateFlowUrl, para:para, success: {[weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);

            if (code == 200) {
                self?.view.makeToast("添加成功");
                self?.flowNameTF.text = "";
                self?.moduleTF.selectedRow = -1;
                self?.flowLab.text = "流程";
                self?.selectFlows.removeAll();
                self?.loadFlowList();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
            HUD.hide();
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
            HUD.hide();
        };
    }
    
    
    func loadFlowList()
    {
        post(url: kGetFlowListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);

            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [FlowModel] = [];

                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(FlowModel.init(dict: tmpDict));
                }
                self?.flowDatas = muarray;
                self?.tabV.reloadData();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
    

    func loadModuleList()
    {
        post(url: kGetModuleListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);

            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [ModuleModel] = [];
                var muStrArr : [String] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    muarray.append(ModuleModel.init(dict: tmpDict));
                    muStrArr.append(dmString(tmpDict["module_name"]));
                }
                self?.moduleDatas = muarray;
                self?.moduleTF.itemList = muStrArr;
                self?.tabV.reloadData();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
}
