//
//  Search.swift
//  GankIO
//
//  Created by Bing on 7/22/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class Search: UIViewController
{
    // 类型
    var type: ClassType
    
    // 导航条中间的搜索框
    var input: UITextField!
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
        
        // 导航条中间的搜索框
        input = UITextField(frame: CGRect(x: 0, y: 0, width: Common.screenWidth - 140, height: 30))
        input.textAlignment = .Center
        input.backgroundColor = UIColor.flatWhiteColor()
        input.layer.masksToBounds = true
        input.layer.cornerRadius = 6
        input.layer.borderWidth = 1
        input.layer.borderColor = UIColor.flatWhiteColor().CGColor
        input.placeholder = "搜索一下"
        input.font = Common.font14
        input.returnKeyType = .Search
        input.delegate = self
        self.navigationItem.titleView = input
        
        // 初始化表格视图
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight))
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100
        tableView.tableFooterView = UIView()
        tableView.registerClass(SearchCell.self, forCellReuseIdentifier: "SearchCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // 下拉刷新和上拉加载
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        if self.input.text == nil || self.input.text == ""
        {
            self.tableView.mj_header.endRefreshing()
            return
        }
        else
        {
            let searchWord = self.input.text!
            API.searchByType(type, searchWord: searchWord, limit: 10, skip: 0, successCall: { (results) in
                self.tableView.mj_header.endRefreshing()
                self.dataArr = results
                self.tableView.reloadData()
            }, failCall: { (error) in
                self.tableView.mj_header.endRefreshing()
                SVProgressHUD.showErrorWithStatus("获取数据出错")
            })
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        if self.input.text == nil || self.input.text == ""
        {
            self.tableView.mj_footer.endRefreshing()
            return
        }
        else
        {
            let searchWord = self.input.text!
            API.searchByType(type, searchWord: searchWord, limit: 10, skip: self.dataArr.count, successCall: { (results) in
                self.tableView.mj_footer.endRefreshing()
                self.dataArr.appendContentsOf(results)
                self.tableView.reloadData()
            }, failCall: { (error) in
                self.tableView.mj_footer.endRefreshing()
                SVProgressHUD.showErrorWithStatus("获取数据出错")
            })
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let headerRefresh = #selector(Search.headerRefresh)
    static let footerRefresh = #selector(Search.footerRefresh)
}

extension Search: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataArr.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("SearchCell", forIndexPath: indexPath) as? SearchCell
        let object = dataArr[indexPath.row]
        
        cell?.title?.text = object["title"] as? String
        cell?.name?.text = object["author"] as? String
        cell?.time?.text = Common.getStringWithDate(object["resourcePublished"] as! NSDate)
        
        return cell!
    }
}

extension Search: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let result = dataArr[indexPath.row]
        let vc = ArticleDetail(URLString: result["url"] as? String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Search: UITextFieldDelegate
{
    // 键盘上return键被触摸后调用
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        if textField.text == nil || textField.text == ""
        {
            SVProgressHUD.showErrorWithStatus("请输入关键字")
            return true
        }
        else
        {
            // 收起键盘
            textField.resignFirstResponder()
            // 获得搜索关键字
            let searchWord = textField.text
            SVProgressHUD.show()
            // 执行搜索
            API.searchByType(self.type, searchWord: searchWord!, limit: 10, skip: 0, successCall: { (results) in
                SVProgressHUD.dismiss()
                self.dataArr = results
                self.tableView.reloadData()
            }, failCall: { (error) in
                SVProgressHUD.showErrorWithStatus("获取数据出错了")
            })
        }

        return true
    }
}