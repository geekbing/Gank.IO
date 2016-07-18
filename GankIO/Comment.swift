//
//  Comment.swift
//  GankIO
//
//  Created by Bing on 7/14/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class Comment: UIViewController
{
    // 传递过来的数据
    var result: AVObject!
    
    // 类型
    var type: ClassType!
    
    // 上面的视图
    var upView: CommentUpView!
    
    // 下面的评论表格
    var tableView: UITableView!
    
    // 评论数据源
    var dataArr = [AVObject]()
    
    // 最下面的评论工具条
    var commentToolBar: CommentToolBar!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "评论详情"
        view.backgroundColor = UIColor.flatWhiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        // 内容的高度
        let descHeight = (result["title"] as? String)!.stringHeightWith(Common.font16, width: Common.screenWidth - 30)
        let upViewHeight = descHeight + 80
        upView = CommentUpView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: upViewHeight))
        upView.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: (result["author"] as? String) ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        upView.desc?.text = result["title"] as? String
        upView.who?.text = result["author"] as? String
        upView.publishedAt?.text = Common.getStringWithDate(result["resourcePublished"] as! NSDate)
        view.addSubview(upView)
        
        // 评论表格
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: 30))
        
        let newCommentLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        newCommentLabel.textAlignment = .Left
        newCommentLabel.font = Common.font14
        newCommentLabel.text = "最新评论"
        newCommentLabel.textColor = UIColor.flatBlackColor()
        tableHeaderView.addSubview(newCommentLabel)
        
        tableView = UITableView(frame: CGRect(x: 0, y: upViewHeight + 10, width: Common.screenWidth, height: Common.screenHeight - upViewHeight - 114))
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(CommentCell.classForCoder(), forCellReuseIdentifier: "CommentCell")
        view.addSubview(tableView)
        
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        tableView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
        
        // 底部的评论工具条
        commentToolBar = CommentToolBar(frame: CGRect(x: 0, y: Common.screenHeight - 104, width: Common.screenWidth, height: 40))
        commentToolBar.delegate = self
        view.addSubview(commentToolBar)
        
        // 获取评论数据
        API.getCommentByTypeAndParams(type, object: result, limit: 10, skip: 0, successCall: { (results) in
            self.dataArr = results
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取评论数据出错了。")
        }
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        API.getCommentByTypeAndParams(type, object: result, limit: 10, skip: 0, successCall: { (results) in
            self.tableView.mj_header.endRefreshing()
            self.dataArr = results
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取评论数据出错了。")
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        API.getCommentByTypeAndParams(type, object: result, limit: 10, skip: dataArr.count, successCall: { (results) in
            self.tableView.mj_footer.endRefreshing()
            self.dataArr.appendContentsOf(results)
            self.tableView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取评论数据出错了。")
        }
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.hidden = true
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let headerRefresh = #selector(Comment.headerRefresh)
    static let footerRefresh = #selector(Comment.footerRefresh)
}

extension Comment: CommentToolBarDelegate
{
    // 点击评论按钮
    func commentBtnClick(content: String)
    {
        if content == ""
        {
            SVProgressHUD.showErrorWithStatus("评论内容不能为空")
            return
        }
        else
        {
            // 进行评论操作
            API.userComment(type, target: result, content: content, successCall: {
                // 重新获取评论数据
                API.getCommentByTypeAndParams(self.type, object: self.result, limit: 10, skip: 0, successCall: { (results) in
                    self.dataArr = results
                    self.tableView.reloadData()
                    SVProgressHUD.showSuccessWithStatus("评论成功")
                }) { (error) in
                    SVProgressHUD.showErrorWithStatus("获取评论数据出错了。")
                }
            }, failCall: { (error) in
                SVProgressHUD.showSuccessWithStatus("评论失败，原因是：\(error.localizedDescription)")
            })
        }
    }
}

extension Comment: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell", forIndexPath: indexPath) as! CommentCell
        let result = dataArr[indexPath.row]
        let user = result["user"] as! AVUser
        
        cell.who?.text = user.username
        cell.publishedAt?.text = Common.getStringWithDate(result["createdAt"] as! NSDate)
        cell.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: (user.username) ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        cell.desc?.text = result["content"] as? String
        
        return cell
    }
}

extension Comment: UITableViewDelegate
{
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
}
