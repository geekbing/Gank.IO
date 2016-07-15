//
//  Register.swift
//  GankIO
//
//  Created by Bing on 7/15/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import Material
import SVProgressHUD

class Register: UIViewController
{
    // 用户名
    var username: TextField!
    // 密码
    var password: TextField!
    // 邮箱
    var email: TextField!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 模糊背景
        let background = UIImageView()
        background.image = UIImage(named: "LoginBackground")?.blurImage()
        view.addSubview(background)
        
        // 返回按钮
        let backBtn = IconButton()
        backBtn.setImage(UIImage(named: "Back")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        backBtn.tintColor = UIColor.flatWhiteColor()
        backBtn.addTarget(self, action: .backBtnClick, forControlEvents: .TouchUpInside)
        view.addSubview(backBtn)
        
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
        
        // 邮箱
        email = TextField()
        email.placeholderVerticalOffset = 6.0
        email.placeholderColor = UIColor.flatWhiteColor()
        email.placeholderActiveColor = UIColor.flatWhiteColor()
        email.dividerColor = UIColor.flatWhiteColor()
        email.dividerActiveColor = UIColor.flatWhiteColor()
        email.textColor = UIColor.flatWhiteColor()
        email.secureTextEntry = true
        email.placeholder = "邮箱"
        email.font = font14
        view.addSubview(email)
        
        // 注册按钮
        let register = UIButton()
        register.layer.masksToBounds = true
        register.layer.cornerRadius = 20
        register.setTitle("注册", forState: .Normal)
        register.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        register.backgroundColor = UIColor(red:0.24, green:0.28, blue:0.31, alpha:1.00)
        register.addTarget(self, action: .registerClick, forControlEvents: .TouchUpInside)
        view.addSubview(register)
        
        // 布局
        background.snp_makeConstraints { (make) in
            make.edges.equalTo(view)
        }
        backBtn.snp_makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(view).offset(20)
            make.left.equalTo(view).offset(10)
        }
        logo.snp_makeConstraints { (make) in
            make.width.height.equalTo(80)
            make.top.equalTo(view).offset(80)
            make.centerX.equalTo(view.snp_centerX)
        }
        username.snp_makeConstraints { (make) in
            make.top.equalTo(logo).offset(100)
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
        email.snp_makeConstraints { (make) in
            make.top.equalTo(password.snp_bottom).offset(20)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(30)
        }
        register.snp_makeConstraints { (make) in
            make.top.equalTo(email.snp_bottom).offset(30)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(40)
        }
    }
    
    // 点击返回按钮
    func backBtnClick()
    {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    // 点击注册按钮
    func registerClick()
    {
        let usernameStr = username.text
        if usernameStr == ""
        {
            SVProgressHUD.showErrorWithStatus("用户名不能为空!")
            return
        }
        let passwordStr = password.text
        if passwordStr == ""
        {
            SVProgressHUD.showErrorWithStatus("密码不能为空!")
            return
        }
        let emailStr = email.text
        if emailStr == ""
        {
            SVProgressHUD.showErrorWithStatus("邮箱不能为空!")
            return
        }
        if !isValidateEmail(emailStr!)
        {
            SVProgressHUD.showErrorWithStatus("邮箱格式不合理!")
            return
        }
        SVProgressHUD.show()
        // 进行注册
        register(usernameStr!, password: passwordStr!, email: emailStr!, successCall: {
            // 键盘收起来
            self.resignFirstResponder()
            SVProgressHUD.showSuccessWithStatus("注册成功! 自动登录...")
            // 进行登录
            login(usernameStr!, password: passwordStr!, successCall: { (_) in
                SVProgressHUD.showSuccessWithStatus("登录成功!")
                UIApplication.sharedApplication().keyWindow?.rootViewController = Main()
            }, failCall: { (error) in
                SVProgressHUD.showSuccessWithStatus(getErrorMessageByCode(error.code))
            })
        }) { (error) in
            SVProgressHUD.showErrorWithStatus(getErrorMessageByCode(error.code))
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let backBtnClick = #selector(Register.backBtnClick)
    static let registerClick = #selector(Register.registerClick)
}
