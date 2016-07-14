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
    var tableView: UITableView!
    var dataDict = [["title": "我的收藏", "icon": "Collection"],
                    ["title": "我的分享", "icon": "Collection"],
                    ["title": "我的收藏", "icon": "Collection"],
                    ["title": "我的收藏", "icon": "Collection"]]
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
//        let headerView = UIView()
//        let background = UIImageView()
//        background.image = UIImage(named: "background")
//        headerView.addSubview(background)
        let headerView = MineHeaderView()
        view.addSubview(headerView)
        
        tableView = UITableView()
        tableView.registerClass(MineCell.classForCoder(), forCellReuseIdentifier: "MineCell")
        tableView.tableFooterView = UIView()
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // 布局
        headerView.snp_makeConstraints { (make) in
            make.width.equalTo(screenWidth)
            make.top.equalTo(-20)
            make.left.equalTo(0)
            make.height.equalTo(220)
        }
//        background.snp_makeConstraints { (make) in
//            make.edges.equalTo(headerView)
//        }
        tableView.snp_makeConstraints { (make) in
            make.top.equalTo(headerView.snp_bottom)
            make.left.equalTo(0)
            make.width.equalTo(screenWidth)
            make.bottom.equalTo(view)
        }
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
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
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
    }
}