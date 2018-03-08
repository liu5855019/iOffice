//
//  LoginVC.swift
//  IOffice_Swift
//
//  Created by 西安旺豆电子信息有限公司 on 2018/3/7.
//  Copyright © 2018年 西安旺豆电子信息有限公司. All rights reserved.
//

import UIKit
import Alamofire

class LoginVC: BaseViewController {

    let bgImgV  = UIImageView();
    let logoIV  = UIImageView();
    let unameTF = UITextField();
    let pwdTF   = UITextField();
    let loginBtn = UIButton();
    let saveBtn = UIButton();
    let forgetBtn = UIButton();
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
        setupLayouts()
    }
    
    func setupViews()
    {
        self.view.addSubview(bgImgV);
        self.view.addSubview(logoIV)
        self.view.addSubview(unameTF)
        self.view.addSubview(pwdTF)
        self.view.addSubview(loginBtn)
        self.view.addSubview(saveBtn)
        self.view.addSubview(forgetBtn)
        
        bgImgV.image = UIImage.init(named:"login_bg.png");
        
        logoIV.image = UIImage.init(named: "login_logo_hk.png")
        
        unameTF.textColor = UIColor.white
        unameTF.placeholder = "请输入账号"
        unameTF.font = UIFont.systemFont(ofSize: CGFloat(kScaleW(17)))
        unameTF.textAlignment = NSTextAlignment.center
        unameTF.setValue(UIColor.white.withAlphaComponent(0.5), forKeyPath: "_placeholderLabel.textColor")
        
        
        
        pwdTF.textColor = UIColor.white
        pwdTF.placeholder = "请输入密码"
        pwdTF.font = UIFont.systemFont(ofSize: CGFloat(kScaleW(17)))
        pwdTF.textAlignment = NSTextAlignment.center
        pwdTF.setValue(UIColor.white.withAlphaComponent(0.5), forKeyPath: "_placeholderLabel.textColor")
        pwdTF.isSecureTextEntry = true
        
        loginBtn.setTitle("登录", for: .normal)
        loginBtn.setBackgroundImage(UIImage.init(named: "login_loginbtn_bg.png"), for: .normal)
        loginBtn.titleLabel?.font = UIFont.systemFont(ofSize: CGFloat(kScaleW(17)))
        loginBtn.addTarget(self, action:#selector(clickLoginBtn) , for: .touchUpInside)
        
    }

    func setupLayouts()
    {
        bgImgV.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalTo(self.view);
        }
        
        logoIV.snp.makeConstraints { (make) in
            make.top.equalTo(kScaleW(100))
            make.centerX.equalTo(self.view)
            make.width.equalTo(kScaleW(271.0/2))
            make.height.equalTo(kScaleW(126.0/2))
        }
        
        unameTF.snp.makeConstraints { (make) in
            make.top.equalTo(logoIV.snp.bottom).offset(kScaleW(60))
            make.left.equalTo(kScaleW(30))
            make.right.equalTo(kScaleW(-30))
            make.height.equalTo(44)
        }
        unameTF.layer.cornerRadius = 22
        unameTF.layer.borderColor = UIColor.white.cgColor
        unameTF.layer.borderWidth = 1
        
        pwdTF.snp.makeConstraints { (make) in
            make.top.equalTo(unameTF.snp.bottom).offset(kScaleW(30))
            make.left.equalTo(kScaleW(30))
            make.right.equalTo(kScaleW(-30))
            make.height.equalTo(44)
        }
        pwdTF.layer.cornerRadius = 22
        pwdTF.layer.borderColor = UIColor.white.cgColor
        pwdTF.layer.borderWidth = 1
        
        loginBtn.snp.makeConstraints { (make) in
            make.top.equalTo(pwdTF.snp.bottom).offset(kScaleW(44))
            make.left.equalTo(kScaleW(30))
            make.right.equalTo(kScaleW(-30))
            make.height.equalTo(44)
        }
    }
    
    @objc func clickLoginBtn() -> Void {
        print("click login btn")
    }
    
    let url = "http://192.168.100.201:92/Safe.svc/IKey"
    
    
    func loadPwdKey() -> Void {
        let para = ["name":unameTF.text]

        
    }
    
    
    
    
    
}


