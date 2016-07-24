//
//  Mine.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Mine: UIViewController
{
    var headerView: MineHeaderView!
    var tableView: UITableView!
    var dataDict = [["title": "主题调整", "icon": "Adjust"],
                    ["title": "我的收藏", "icon": "Like"],
                    ["title": "随意吐槽", "icon": "Feedback"]]
                    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 顶部视图
        headerView = MineHeaderView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: 200))
        headerView.delegate = self

        // 表格视图
         tableView = UITableView(frame: CGRect(x: 0, y: -20, width: Common.screenWidth, height: Common.screenHeight))
        tableView.registerClass(MineCell.classForCoder(), forCellReuseIdentifier: "MineCell")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableHeaderView = headerView
        view.addSubview(tableView)
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
        UIView.animateWithDuration(0.3, animations: { 
            self.navigationController?.navigationBar.alpha = 0
            self.tabBarController?.tabBar.alpha = 1
        }) { (finished) in
            self.navigationController?.navigationBar.alpha = 1
            self.navigationController?.navigationBar.hidden = true
            self.tabBarController?.tabBar.alpha = 1
            self.tabBarController?.tabBar.hidden = false
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension Mine: MineHeaderViewDelegate
{
    // 点击设置按钮
    func clickSettingBtn()
    {
        let vc = Setting()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击头像
    func clickAvatar()
    {
        
    }
}

extension Mine: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataDict.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("MineCell", forIndexPath: indexPath) as! MineCell
        cell.icon?.image = UIImage(named: dataDict[indexPath.row]["icon"]!)
        cell.title?.text = dataDict[indexPath.row]["title"]
        
        return cell
    }
}

extension Mine: UITableViewDelegate
{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 44
    }
    
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
                let vc = Adjust()
                self.navigationController?.pushViewController(vc, animated: true)
            case 1:
                let vc = Collection()
                self.navigationController?.pushViewController(vc, animated: true)
            case 2:
                let vc = Feedback()
                self.navigationController?.pushViewController(vc, animated: true)
            default:
                break
        }
    }
}

extension Mine: UIScrollViewDelegate
{
    func scrollViewDidScroll(scrollView: UIScrollView)
    {
        let offsetY = scrollView.contentOffset.y
        if offsetY < 0
        {
            headerView.background.frame = CGRect(x: offsetY / 2, y: offsetY, width: Common.screenWidth - offsetY, height: 200 - offsetY)
        }
    }
}