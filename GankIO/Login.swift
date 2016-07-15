//
//  Login.swift
//  GankIO
//
//  Created by Bing on 7/15/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SnapKit
import ChameleonFramework
import Material
import SVProgressHUD

class Login: UIViewController
{
    // 用户名
    var username: TextField!
    // 密码
    var password: TextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 模糊背景
        let background = UIImageView()
        background.image = UIImage(named: "LoginBackground")?.blurImage()
        view.addSubview(background)
        
        // Logo
        let logo = UIImageView()
        logo.image = UIImage(named: "Logo")
        logo.layer.masksToBounds = true
        logo.layer.cornerRadius = 40
        view.addSubview(logo)
        
        // 用户名
        username = TextField()
        username.placeholderVerticalOffset = 6.0
        username.placeholderColor = UIColor.flatWhiteColor()
        username.placeholderActiveColor = UIColor.flatWhiteColor()
        username.dividerColor = UIColor.flatWhiteColor()
        username.dividerActiveColor = UIColor.flatWhiteColor()
        username.textColor = UIColor.flatWhiteColor()
        username.placeholder = "用户名"
        username.font = font14
        view.addSubview(username)
        
        // 密码
        password = TextField()
        password.placeholderVerticalOffset = 6.0
        password.placeholderColor = UIColor.flatWhiteColor()
        password.placeholderActiveColor = UIColor.flatWhiteColor()
        password.dividerColor = UIColor.flatWhiteColor()
        password.dividerActiveColor = UIColor.flatWhiteColor()
        password.textColor = UIColor.flatWhiteColor()
        password.secureTextEntry = true
        password.placeholder = "密码"
        password.font = font14
        view.addSubview(password)
        
        // 登录按钮
        let login = RaisedButton()
        login.layer.masksToBounds = true
        login.layer.cornerRadius = 20
        login.setTitle("登录", forState: .Normal)
        login.titleLabel?.font = font16
        login.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        login.backgroundColor = UIColor(red:0.24, green:0.28, blue:0.31, alpha:1.00)
        login.pulseColor = UIColor.whiteColor()
        login.addTarget(self, action: .loginClick, forControlEvents: .TouchUpInside)
        view.addSubview(login)
        
        // 找回密码
        let foundPassword = FlatButton()
        foundPassword.setTitle("找回密码", forState: .Normal)
        foundPassword.titleLabel?.font = font16
        foundPassword.setTitleColor(UIColor.flatGrayColor(), forState: .Normal)
        foundPassword.addTarget(self, action: .foundPasswordClick, forControlEvents: .TouchUpInside)
        view.addSubview(foundPassword)
        
        // 注册按钮
        let register = FlatButton()
        register.titleLabel?.font = font16
        register.setTitle("去注册", forState: .Normal)
        register.setTitleColor(UIColor.flatGrayColor(), forState: .Normal)
        register.addTarget(self, action: .registerClick, forControlEvents: .TouchUpInside)
        view.addSubview(register)
        
        // 布局
        background.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        logo.snp_makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.top.equalTo(view).offset(80)
            make.centerX.equalTo(view.snp_centerX)
        }
        username.snp_makeConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(80)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(30)
        }
        password.snp_makeConstraints { (make) in
            make.top.equalTo(username.snp_bottom).offset(20)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(30)
        }
        login.snp_makeConstraints { (make) in
            make.top.equalTo(password.snp_bottom).offset(30)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(40)
        }
        foundPassword.snp_makeConstraints { (make) in
            make.top.equalTo(login.snp_bottom).offset(20)
            make.width.equalTo(100)
            make.centerX.equalTo(view.snp_centerX)
        }
        register.snp_makeConstraints { (make) in
            make.bottom.equalTo(view.snp_bottom).offset(-40)
            make.width.equalTo(100)
            make.centerX.equalTo(view.snp_centerX)
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    // 点击登录按钮
    func loginClick()
    {
        username.resignFirstResponder()
        password.resignFirstResponder()
        
        
        SVProgressHUD.show()
        login(username.text!, password: password.text!, successCall: {_ in 
            SVProgressHUD.showSuccessWithStatus("登录成功。")
            let vc = Main()
            self.presentViewController(vc, animated: true, completion: nil)
        }) { (error) in
            SVProgressHUD.showErrorWithStatus(error.localizedDescription)
        }
    }
    
    // 点击找回密码按钮
    func foundPasswordClick()
    {
        print("foundPasswordClick")
    }
    
    // 点击去注册按钮
    func registerClick()
    {
        let vc = Register()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let loginClick = #selector(Login.loginClick)
    static let foundPasswordClick = #selector(Login.foundPasswordClick)
    static let registerClick = #selector(Login.registerClick)
}