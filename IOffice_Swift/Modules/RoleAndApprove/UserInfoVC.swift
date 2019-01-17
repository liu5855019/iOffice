//
//  UserInfoVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/17.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit
import IQDropDownTextField
import PKHUD

class UserInfoVC: DMBaseViewController {

    var account : AccountModel? = nil;
    var userInfo = UserInfoModel.init(dict: [String : Any]());
    var deptDatas = [DeptModel]();
    var roleDatas = [RoleModel]();
    
    var usernameTF = UITextField();
    var deptTF = IQDropDownTextField();
    var roleTF = IQDropDownTextField();
    var submitBtn = UIButton();
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = account?.username ?? "unknow";
        
        self.setupViews();
        self.setupLayouts();
        
        
        self.loadDeptList();
        self.loadRoleList();
        self.getUserInfo(account_guid: account?.guid ?? "");
    }
    
    func setupViews()
    {
        self.view.addSubview(usernameTF);
        self.view.addSubview(deptTF);
        self.view.addSubview(roleTF);
        self.view.addSubview(submitBtn);

        
        usernameTF.textColor = UIColor.black;
        usernameTF.backgroundColor = UIColor.groupTableViewBackground;
        usernameTF.placeholder = "请输入用户名";
        
        deptTF.textColor = UIColor.black;
        deptTF.backgroundColor = UIColor.groupTableViewBackground;
        deptTF.optionalItemText = "请选择";
        deptTF.placeholder = "请选择";
        
        roleTF.textColor = UIColor.black;
        roleTF.backgroundColor = UIColor.groupTableViewBackground;
        roleTF.optionalItemText = "请选择";
        roleTF.placeholder = "请选择";
        
        
        submitBtn.setTitle("submit", for: .normal);
        submitBtn.addTarget(self, action: #selector(clickSubmitBtn), for: .touchUpInside);
        submitBtn.setTitleColor(UIColor.blue, for: .normal);
    }
    
    func setupLayouts()
    {
        usernameTF.snp.makeConstraints { (make) in
            make.top.equalTo(kNavHeight + 10);
            make.left.equalTo(15);
            make.height.equalTo(40);
            make.width.equalTo(kScaleW(249));
        };
        
        deptTF.snp.makeConstraints { (make) in
            make.top.equalTo(usernameTF.snp.bottom).offset(10);
            make.left.height.right.equalTo(usernameTF);
        };
        
        
        roleTF.snp.makeConstraints { (make) in
            make.top.equalTo(deptTF.snp.bottom).offset(10);
            make.left.width.height.right.equalTo(deptTF);
        };
        
        submitBtn.snp.makeConstraints { (make) in
            make.top.equalTo(roleTF.snp.bottom).offset(10);
            make.right.equalTo(-15);
            make.height.equalTo(40);
        };
        
    }
    
    
    //MARK: - ACTIONS
    
    @objc func clickSubmitBtn()
    {
        guard usernameTF.text?.count ?? 0 > 1 else {
            self.view.makeToast("please input user name");
            return;
        }
        
        guard userInfo.department_guid.count > 1 || deptTF.selectedRow >= 0 else {
            self.view.makeToast("please select dept");
            return;
        }
        
        guard userInfo.role_guid.count > 1 || roleTF.selectedRow >= 0 else {
            self.view.makeToast("please select role");
            return
        }
        
        self.updateUserInfo(account_guid: account?.guid ?? "",
                            user_name: usernameTF.text!,
                            department_guid: deptTF.selectedRow >= 0 ? deptDatas[deptTF.selectedRow].guid : userInfo.department_guid , role_guid: roleTF.selectedRow >= 0 ? roleDatas[roleTF.selectedRow].guid : userInfo.role_guid)
        
    }
    
    func updateDatas()
    {
        usernameTF.text = userInfo.user_name;
        deptTF.placeholder = userInfo.department_name.count > 0 ? userInfo.department_name : "请选择";
        roleTF.placeholder = userInfo.role_name.count > 0 ? userInfo.role_name : "请选择";
    }
    
    
    
    //MARK: - NET
    
    func updateUserInfo(account_guid : String ,
                        user_name : String ,
                        department_guid : String ,
                        role_guid : String)
    {
        let para = ["account_guid" : account_guid,
                    "user_name" : user_name,
                    "department_guid" : department_guid,
                    "role_guid" : role_guid];
        
        post(url: kUpdateUserInfoUrl, para: para, success: {[weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                UIApplication.shared.keyWindow?.makeToast("Update success!");
                self?.navigationController?.popViewController(animated: true);
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
    
    func getUserInfo(account_guid:String)
    {
        HUD.show(.systemActivity, onView: self.view);
        let para = ["account_guid" : account_guid];
        
        post(url: kGetUserInfoUrl, para: para, success: {[weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let tmpDict = dmDict(dict["obj"]);
                self?.userInfo = UserInfoModel.init(dict: tmpDict);
                self?.updateDatas();
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
            HUD.hide();
        }) { [weak self] (err, code, desc) in
            self?.view.makeToast(String(code) + " : " + desc);
            HUD.hide();
        }
    }
    
    func loadDeptList()
    {
        post(url: kGetDeptListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [DeptModel] = [];
                var muStrArr : [String] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    let model = DeptModel.init(dict: tmpDict);
                    muarray.append(model);
                    muStrArr.append(model.department_name);
                }
                self?.deptDatas = muarray;
                self?.deptTF.itemList = muStrArr;
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
    
    func loadRoleList()
    {
        post(url: kGetRoleListUrl, para: nil, success: { [weak self] (value) in
            let dict = dmDict(value);
            let code = dmInt(dict["code"]);
            
            if (code == 200) {
                let arr = dmArray(dict["obj"]);
                var muarray : [RoleModel] = [];
                var muStrArr : [String] = [];
                for tmp in arr {
                    let tmpDict = dmDict(tmp);
                    let role = RoleModel.init(dict: tmpDict);
                    muarray.append(role);
                    muStrArr.append(role.role_name);
                }
                self?.roleDatas = muarray;
                self?.roleTF.itemList = muStrArr;
            } else {
                self?.view.makeToast(dmString(dict["msg"]));
            }
        }) { (err, code, desc) in
            print(String(code) + " : " + desc);
        }
    }
   

}
