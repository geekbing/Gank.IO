//
//  Setting.swift
//  GankIO
//
//  Created by Bing on 7/15/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SVProgressHUD
import SnapKit

class Setting: UIViewController
{
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // 退出按钮
        let logout = UIButton()
        logout.backgroundColor = UIColor.flatRedColor()
        logout.layer.masksToBounds = true
        logout.layer.cornerRadius = 15
        logout.setTitle("退出", forState: .Normal)
        logout.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        logout.addTarget(self, action: .logoutBtnClick, forControlEvents: .TouchUpInside)
        view.addSubview(logout)
        
        logout.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(30)
            make.bottom.equalTo(-100)
        }
        
    }
    
    // 点击设置按钮
    func logoutBtnClick()
    {
        SVProgressHUD.show()
        // 清除缓存用户对象
        AVUser.logOut()
        SVProgressHUD.dismiss()
        // 回到登录界面
        let vc = UINavigationController(rootViewController: Login())
        UIApplication.sharedApplication().keyWindow?.rootViewController = vc
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let logoutBtnClick = #selector(Setting.logoutBtnClick)
}
