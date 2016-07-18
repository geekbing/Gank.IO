//
//  FindPassword.swift
//  GankIO
//
//  Created by Bing on 7/15/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import Material
import SVProgressHUD
import NVActivityIndicatorView

class FindPassword: UIViewController
{
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
        email.font = Common.font14
        email.returnKeyType = .Done
        email.delegate = self
        view.addSubview(email)

        // 确认发送邮件按钮
        let sureSend = UIButton()
        sureSend.layer.masksToBounds = true
        sureSend.layer.cornerRadius = 20
        sureSend.titleLabel?.font = Common.font16
        sureSend.setTitle("确认发送邮件", forState: .Normal)
        sureSend.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        sureSend.backgroundColor = UIColor(red:0.24, green:0.28, blue:0.31, alpha:1.00)
        sureSend.addTarget(self, action: .sureSendBtnClick, forControlEvents: .TouchUpInside)
        view.addSubview(sureSend)
        
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
        email.snp_makeConstraints { (make) in
            make.top.equalTo(logo.snp_bottom).offset(80)
            make.left.equalTo(view).offset(30)
            make.right.equalTo(view).offset(-30)
            make.height.equalTo(30)
        }
        sureSend.snp_makeConstraints { (make) in
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
    
    // 点击确认发送邮件按钮
    func sureSendBtnClick()
    {
        let emailStr = email.text!
        if emailStr == ""
        {
            SVProgressHUD.showErrorWithStatus("邮箱不能为空")
            return
        }
        if !Common.isValidateEmail(emailStr)
        {
            SVProgressHUD.showErrorWithStatus("邮箱不合法")
            return
        }
        self.showLoding("")
        // 发送重置邮件
        API.resetPassWordByEmail(emailStr, successCall: {
            self.stopActivityAnimating()
            self.email.resignFirstResponder()
            SVProgressHUD.showSuccessWithStatus("邮件发送成功")
        }) { (error) in
            self.stopActivityAnimating()
            SVProgressHUD.showErrorWithStatus(Common.getErrorMessageByCode(error.code))
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let backBtnClick = #selector(FindPassword.backBtnClick)
    static let sureSendBtnClick = #selector(FindPassword.sureSendBtnClick)
}

extension FindPassword: UITextFieldDelegate
{
    // 键盘上return键被触摸后调用
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
}
