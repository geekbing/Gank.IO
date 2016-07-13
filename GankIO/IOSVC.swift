//
//  IOSVC.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//


import UIKit
import ChameleonFramework
import ITDAvatarPlaceholder
import MJRefresh
import SafariServices

class IOSVC: UIViewController
{
    var tableView: UITableView!
    var dataArr = [Result]()
    // 当前页数
    var currentPage = 1
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.flatGrayColor()
        
        prepareUI()
        
        getArticlesByType(getUrlByTypeCountAndPage(.iOS, count: 10, page: 4)) { (result) in
            self.dataArr = result
            self.tableView.reloadData()
        }
    }
    
    func prepareUI()
    {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 20 - 49))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(ArticleCell.classForCoder(), forCellReuseIdentifier: "ArticleCell")
        view.addSubview(tableView)
        
        // 下拉刷新和上拉加载
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        getArticlesByType(getUrlByTypeCountAndPage(.iOS, count: 10, page: 1)) { (result) in
            self.currentPage = 1
            self.tableView.mj_header.endRefreshing()
            self.dataArr = result
            self.tableView.reloadData()
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        getArticlesByType(getUrlByTypeCountAndPage(.iOS, count: 10, page: currentPage + 1)) { (result) in
            self.currentPage += 1
            self.tableView.mj_footer.endRefreshing()
            self.dataArr.appendContentsOf(result)
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let headerRefresh = #selector(IOSVC.headerRefresh)
    static let footerRefresh = #selector(IOSVC.footerRefresh)
}

extension IOSVC: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
   
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("ArticleCell", forIndexPath: indexPath) as! ArticleCell
        let result = dataArr[indexPath.row]
        
        cell.who?.text = result.who
        cell.publishedAt?.text = result.publishedAt
        
        cell.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: result.who ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        cell.desc?.text = result.desc
        
        return cell
    }
}

extension IOSVC: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let result = dataArr[indexPath.row]
        let vc = ArticleDetail(URLString: result.url)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}