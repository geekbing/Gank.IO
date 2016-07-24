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
    var tableView: UITableView!
    var dataArr = [
                    ["title": "用户协议", "icon": ""],
                    ["title": "清除缓存", "icon": ""],
                    ["title": "向朋友推荐", "icon": ""],
                    ["title": "给IT干货评分", "icon": ""],
                    ["title": "退出登录", "icon": ""]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight))
        tableView.registerClass(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
//        // 退出按钮
//        let logout = UIButton()
//        logout.backgroundColor = UIColor.flatRedColor()
//        logout.layer.masksToBounds = true
//        logout.layer.cornerRadius = 15
//        logout.setTitle("退出", forState: .Normal)
//        logout.setTitleColor(UIColor.whiteColor(), forState: .Normal)
//        logout.addTarget(self, action: .logoutBtnClick, forControlEvents: .TouchUpInside)
//        view.addSubview(logout)
//        
//        logout.snp_makeConstraints { (make) in
//            make.left.equalTo(30)
//            make.right.equalTo(-30)
//            make.height.equalTo(30)
//            make.bottom.equalTo(-100)
//        }
        
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

extension Setting: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SettingCell", forIndexPath: indexPath) as? SettingCell
        let data = dataArr[indexPath.row]
        
        cell?.icon?.image = UIImage(named: data["icon"]!)
        cell?.title?.text = data["title"]
        
        return cell!
    }
}

extension Setting: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
