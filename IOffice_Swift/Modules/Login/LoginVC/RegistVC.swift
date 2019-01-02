//
//  RegistVC.swift
//  IOffice_Swift
//
//  Created by iMac-03 on 2019/1/2.
//  Copyright © 2019 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit

class RegistVC: BaseViewController {

    let unameTF = UITextField();
    let pwdTF = UITextField();
    let registBtn = UIButton();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Regist VC";
        
        setupViews();
        setupLayouts();
    }
    
    //MARK: - SETUP
    
    func setupViews()
    {
        self.view.addSubview(unameTF);
        self.view.addSubview(pwdTF);
        self.view.addSubview(registBtn);
        
        unameTF.textColor = UIColor.black;
        unameTF.placeholder = "请输入账号";
        unameTF.font = UIFont.systemFont(ofSize: kScaleW(17));
        unameTF.textAlignment = NSTextAlignment.center;
        
        pwdTF.textColor = UIColor.black;
        pwdTF.placeholder = "请输入密码"
        pwdTF.font = UIFont.systemFont(ofSize: kScaleW(17))
        pwdTF.textAlignment = NSTextAlignment.center
        pwdTF.isSecureTextEntry = true
        
        registBtn.setTitle("注册", for: .normal);
        registBtn.setBackgroundImage(UIImage.init(named: "login_loginbtn_bg.png"), for: .normal)
        registBtn.titleLabel?.font = UIFont.systemFont(ofSize: kScaleW(17))
        registBtn.addTarget(self, action:#selector(clickRegistBtn) , for: .touchUpInside)
    }
    
    func setupLayouts()
    {
        unameTF.snp.makeConstraints { (make) in
            make.top.equalTo(kScaleW(60))
            make.left.equalTo(kScaleW(30))
            make.right.equalTo(kScaleW(-30))
            make.height.equalTo(kScaleW(44))
        }
        
        pwdTF.snp.makeConstraints { (make) in
            make.top.equalTo(unameTF.snp.bottom).offset(kScaleW(30))
            make.left.equalTo(kScaleW(30))
            make.right.equalTo(kScaleW(-30))
            make.height.equalTo(kScaleW(44))
        }
        
        registBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTF.snp.bottom).offset(kScaleW(44))
            make.left.equalTo(kScaleW(30))
            make.right.equalTo(kScaleW(-30))
            make.height.equalTo(44)
        };
    }

    //MARK: - ACTIONS
    
    @objc func clickRegistBtn() -> Void
    {
        
    }
    
    
    //MARK: - NET
    func regist(_ username:String ,_ password:String) -> Void
    {
        let para:[String:Any] = [
            "username":username,
            "password":password
        ];
        
        print(para);
        
        post(url: kRegistUrl, para: para, success: { (value) in
            print(value);
        }) { (value, code, desc) in
            print(code);
        }
    }

}
