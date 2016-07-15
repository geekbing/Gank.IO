//
//  Comment.swift
//  GankIO
//
//  Created by Bing on 7/14/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Comment: UIViewController
{
    // 传递过来的数据
    var result: AVObject!
    
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
        let descHeight = (result["desc"] as? String)!.stringHeightWith(font16, width: screenWidth - 30)
        let upViewHeight = descHeight + 80
        upView = CommentUpView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: upViewHeight))
        // upView.layer.borderWidth = 1
        // upView.layer.borderColor = UIColor.flatRedColor().CGColor
        upView.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: (result["who"] as? String) ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        upView.desc?.text = result["desc"] as? String
        upView.who?.text = result["who"] as? String
        upView.publishedAt?.text = result["publishedAt"] as? String
        view.addSubview(upView)
        
        // 评论表格
        let tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: 30))
        
        let newCommentLabel = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 20))
        newCommentLabel.textAlignment = .Left
        newCommentLabel.font = font14
        newCommentLabel.text = "最新评论"
        newCommentLabel.textColor = UIColor.flatBlackColor()
        tableHeaderView.addSubview(newCommentLabel)
        
        tableView = UITableView(frame: CGRect(x: 0, y: upViewHeight + 10, width: screenWidth, height: screenHeight - upViewHeight - 114))
        tableView.tableHeaderView = tableHeaderView
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 140
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(CommentCell.classForCoder(), forCellReuseIdentifier: "CommentCell")
        view.addSubview(tableView)
        
        // 底部的评论工具条
        commentToolBar = CommentToolBar(frame: CGRect(x: 0, y: screenHeight - 104, width: screenWidth, height: 40))
        view.addSubview(commentToolBar)
        
        // TODO
//        API.getArticlesByType(API.getUrlByTypeCountAndPage(.iOS, count: 10, page: 4)) { (result) in
//            self.dataArr = result
//            self.tableView.reloadData()
//        }
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
        
        cell.who?.text = result["who"] as? String
        cell.publishedAt?.text = result["publishedAt"] as? String
        cell.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: (result["who"] as? String) ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        cell.desc?.text = result["desc"] as? String
        
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
