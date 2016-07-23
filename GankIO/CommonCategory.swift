//
//  CommonCategory.swift
//  GankIO
//
//  Created by Bing on 7/22/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class CommonCategory: UIViewController
{
    // 类别
    var type: ClassType
    
    // 表格视图
    var tableView: UITableView!
    var dataArr = [AVObject]()
    
    init(type: ClassType)
    {
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = self.type.desc()
        
        // 导航条右边的搜索按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "RightSearch"), style: .Plain, target: self, action: .searchBtnClick)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.flatWhiteColor()
        
        // 表格视图
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 260
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(CommonCategoryCell.self, forCellReuseIdentifier: "CommonCategoryCell")
        tableView.registerClass(CommonCategoryOneImageCell.self, forCellReuseIdentifier: "CommonCategoryOneImageCell")
        tableView.registerClass(CommonCategoryTwoImageCell.self, forCellReuseIdentifier: "CommonCategoryTwoImageCell")
        view.addSubview(tableView)
        
        // 下拉刷新和上拉加载
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
        
        // 获取数据
        SVProgressHUD.show()
        API.getDataByType(type, limit: 10, skip: 0, successCall: { (results) in
            SVProgressHUD.dismiss()
            self.dataArr = results
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错")
        }
    }
    
    // 点击搜索按钮
    func searchBtnClick()
    {
        let vc = Search(type: type)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        API.getDataByType(type, limit: 10, skip: 0, successCall: { (results) in
            self.tableView.mj_header.endRefreshing()
            self.dataArr = results
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错")
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        API.getDataByType(type, limit: 10, skip: self.dataArr.count, successCall: { (results) in
            self.tableView.mj_footer.endRefreshing()
            self.dataArr.appendContentsOf(results)
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错")
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
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let searchBtnClick = #selector(CommonCategory.searchBtnClick)
    static let headerRefresh = #selector(CommonCategory.headerRefresh)
    static let footerRefresh = #selector(CommonCategory.footerRefresh)
}

extension CommonCategory: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let object = self.dataArr[indexPath.row]
        let imgArr = object["image"] as? [String]
        if imgArr?.count == 0
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommonCategoryCell", forIndexPath: indexPath) as? CommonCategoryCell
            // 获取用户名
            var name = object["author"] as? String
            if name == nil || name! == ""
            {
                name = "代码家"
            }
            
            cell!.who?.text = name
            cell!.publishedAt?.text = Common.getStringWithDate(object["resourcePublished"] as! NSDate)
            cell!.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: name!, placeholderSize: CGSize(width: 90, height: 90))
            cell!.desc?.text = object["title"] as? String
            
            return cell!
        }
        else if imgArr?.count == 1
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommonCategoryOneImageCell", forIndexPath: indexPath) as? CommonCategoryOneImageCell
            // 获取用户名
            var name = object["author"] as? String
            if name == nil || name! == ""
            {
                name = "代码家"
            }
            
            cell!.who?.text = name
            cell!.publishedAt?.text = Common.getStringWithDate(object["resourcePublished"] as! NSDate)
            cell!.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: name!, placeholderSize: CGSize(width: 90, height: 90))
            cell!.desc?.text = object["title"] as? String
            
            // 设置图片
            dispatch_async(dispatch_get_main_queue(), {
                cell!.imgView?.yy_setImageWithURL(NSURL(string: imgArr![0]), options: [.ProgressiveBlur ,.SetImageWithFadeAnimation])
            })

            return cell!
        }
        else
        {
            let cell = tableView.dequeueReusableCellWithIdentifier("CommonCategoryTwoImageCell", forIndexPath: indexPath) as? CommonCategoryTwoImageCell
            // 获取用户名
            var name = object["author"] as? String
            if name == nil || name! == ""
            {
                name = "代码家"
            }
            cell!.who?.text = name
            cell!.publishedAt?.text = Common.getStringWithDate(object["resourcePublished"] as! NSDate)
            cell!.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: name!, placeholderSize: CGSize(width: 90, height: 90))
            cell!.desc?.text = object["title"] as? String

            // 设置左右图片
            dispatch_async(dispatch_get_main_queue(), {
                cell!.leftImg?.yy_setImageWithURL(NSURL(string: imgArr![0]), options: [.ProgressiveBlur ,.SetImageWithFadeAnimation])
            })
            dispatch_async(dispatch_get_main_queue(), {
                cell!.rightImg?.yy_setImageWithURL(NSURL(string: imgArr![1]), options: [.ProgressiveBlur ,.SetImageWithFadeAnimation])
            })

            return cell!

        }
    }
}

extension CommonCategory: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        let result = dataArr[indexPath.row]
        let vc = ArticleDetail(URLString: result["url"] as? String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
}
