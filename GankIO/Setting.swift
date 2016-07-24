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
                    ["title": "用户协议", "icon": "用户协议"],
                    ["title": "清除缓存", "icon": "清除缓存"],
                    ["title": "向朋友推荐", "icon": "Like"],
                    ["title": "给IT干货评分", "icon": "评分"],
                    ["title": "退出登录", "icon": "退出"]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "设置"
        view.backgroundColor = UIColor.whiteColor()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight))
        tableView.registerClass(SettingCell.self, forCellReuseIdentifier: "SettingCell")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
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
    
    // 消除分割线前面的间距
    override func viewDidLayoutSubviews()
    {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
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
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        switch indexPath.row
        {
            case 0:
                break
            case 1:
                break
            case 2:
                break
            case 3:
                break
            case 4:
                SVProgressHUD.show()
                // 清除缓存用户对象
                AVUser.logOut()
                SVProgressHUD.dismiss()
                // 回到登录界面
                let vc = UINavigationController(rootViewController: Login())
                UIApplication.sharedApplication().keyWindow?.rootViewController = vc
            default:
                break
        }
    }
}
