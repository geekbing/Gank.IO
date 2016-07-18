//
//  NewCommonVC.swift
//  GankIO
//
//  Created by Bing on 7/15/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class NewCommon: UIViewController
{
    var dataArr = [NewCommonModel]()
    
    var collectionView: UICollectionView!
    
    // 分享第几条数据
    var shareIndex = 0
    
    var type: ClassType
    
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
        self.automaticallyAdjustsScrollViewInsets = false
        
        prepareUI()
        
        showLoding("")
        API.getDataByTypeAndParams(type, limit: 10, skip: 0, successCall: { (results) in
            self.dataArr = results
            self.collectionView.reloadData()
            self.stopActivityAnimating()
        }) { (error) in
            self.stopActivityAnimating()
            print(error.localizedDescription)
            SVProgressHUD.showErrorWithStatus("获取数据出错。")
        }
    }
    
    func prepareUI()
    {
        view.backgroundColor = UIColor.whiteColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight - 64), collectionViewLayout: layout)
        collectionView.registerClass(NewCommonCell.classForCoder(), forCellWithReuseIdentifier: "NewCommonCell")
        
        collectionView.backgroundColor = UIColor.flatWhiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // 下拉刷新和上拉加载
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        API.getDataByTypeAndParams(type, limit: 10, skip: 0, successCall: { (results) in
            self.collectionView.mj_header.endRefreshing()
            self.dataArr.removeAll()
            self.dataArr.appendContentsOf(results)
            self.collectionView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错。")
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        API.getDataByTypeAndParams(type, limit: 10, skip: dataArr.count, successCall: { (results) in
            self.collectionView.mj_footer.endRefreshing()
            self.dataArr.appendContentsOf(results)
            self.collectionView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错。")
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let headerRefresh = #selector(NewCommon.headerRefresh)
    static let footerRefresh = #selector(NewCommon.footerRefresh)
}

extension NewCommon: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewCommonCell", forIndexPath: indexPath) as! NewCommonCell
        
        let model = dataArr[indexPath.row]
        let object = model.avObject
        let isZan = model.isZan
        let isCollection = model.isCollection
        
        cell.who?.text = object["author"] as? String
        cell.publishedAt?.text = Common.getStringWithDate(object["resourcePublished"] as! NSDate)
        cell.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: (object["author"] as? String) ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        cell.desc?.text = object["title"] as? String
        cell.toolBar?.delegate = self
        
        // 设置赞的图标
        cell.toolBar?.isZanOrNot(isZan)
        // 设置收藏图标
        cell.toolBar?.isCollectionOrNot(isCollection)
        
        return cell
    }
    
    func getIndexByTouch(event: UIEvent) -> NSIndexPath?
    {
        let touches:NSSet = event.allTouches()!
        let touch:UITouch = touches.anyObject() as! UITouch
        let currentTouchPosition:CGPoint = touch.locationInView(collectionView)
        // 获取点击位置所在的行
        let indexPath = collectionView.indexPathForItemAtPoint(currentTouchPosition)
        return indexPath
    }
}

extension NewCommon: ToolBarViewDelegate
{
    // 点击分享按钮
    func clickShare(btn: UIButton, event: UIEvent)
    {
        // 获取点击位置所在的行
        let indexPath = getIndexByTouch(event)
        self.shareIndex = (indexPath?.item)!
        
        // 初始化分享弹出菜单
        let shareMenuView = LYShareMenuView()
        shareMenuView.delegate = self
        let window = ((UIApplication.sharedApplication().delegate?.window)!)! as UIWindow
        window.addSubview(shareMenuView)
        // 配置分享菜单项
        var itemArr = [LYShareMenuItem]()
        for i in 0...7
        {
            var item:LYShareMenuItem
            switch i
            {
                case 0:
                    item = LYShareMenuItem(imageName: "WeChat", itemTitle: "微信好友")
                case 1:
                    item = LYShareMenuItem(imageName: "Moments", itemTitle: "朋友圈")
                case 2:
                    item = LYShareMenuItem(imageName: "QQ", itemTitle: "QQ好友")
                case 3:
                    item = LYShareMenuItem(imageName: "QQSpace", itemTitle: "QQ空间")
                case 4:
                    item = LYShareMenuItem(imageName: "Weibo", itemTitle: "新浪微博")
                case 5:
                    item = LYShareMenuItem(imageName: "Email", itemTitle: "发送邮件")
                case 6:
                    item = LYShareMenuItem(imageName: "SMS", itemTitle: "发送短信")
                case 7:
                    item = LYShareMenuItem(imageName: "Copy", itemTitle: "复制")
                default:
                    item = LYShareMenuItem(imageName: "QQ", itemTitle: "QQ")
            }
            itemArr.append(item)
        }
        shareMenuView.shareMenuItems = itemArr
        // 显示分享弹出菜单
        shareMenuView.show()
    }
    
    // 点击评论按钮
    func clickComment(btn: UIButton, event: UIEvent)
    {
        // 获取点击位置所在的行
        let indexPath = getIndexByTouch(event)
        let result = dataArr[indexPath!.row].avObject
        let vc = Comment()
        
        vc.result = result
        vc.type = type
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击赞按钮
    func clickZan(btn: UIButton, event: UIEvent)
    {
        // 先禁用按钮
        btn.enabled = false
        
        // 获取点击位置所在的行对应的model
        let indexPath = getIndexByTouch(event)
        let model = dataArr[(indexPath?.item)!]
        
        // 当前是点赞状态
        if model.isZan
        {
            // 进行删除点赞操作
            API.userDelZan(type, objectId: model.avObject.objectId, successCall: {
                // 更新model
                self.dataArr[(indexPath?.item)!].isZan = false
                // 按钮恢复可点击
                btn.enabled = true
                // 当前按钮设置为取消赞状态
                btn.setImage(UIImage(named: "Zan")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            }, failCall: { (error) in
                print("清除赞错误，原因是：" + error.localizedDescription)
                // 按钮恢复可点击
                btn.enabled = true
            })
        }
        else
        {
            // 进行点赞操作
            API.userZan(type, objectId: model.avObject.objectId, successCall: { 
                // 更新model
                self.dataArr[(indexPath?.item)!].isZan = true
                // 按钮恢复可点击
                btn.enabled = true
                // 当前按钮设置为赞状态
                btn.setImage(UIImage(named: "Zan-Fill")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            }, failCall: { (error) in
                print("点赞出错，原因是：" + error.localizedDescription)
                // 按钮恢复可点击
                btn.enabled = true
            })
        }
    }
    
    // 点击收藏按钮
    func clickCollection(btn: UIButton, event: UIEvent)
    {
        // 先禁用按钮
        btn.enabled = false

        // 获取点击位置所在的行对应的model
        let indexPath = getIndexByTouch(event)
        let model = dataArr[(indexPath?.item)!]
        
        // 当前是收藏状态
        if model.isCollection
        {
            // 进行清除收藏操作
            API.userDelCollection(type, objectId: model.avObject.objectId, successCall: {
                // 更新model
                self.dataArr[(indexPath?.item)!].isCollection = true
                // 按钮恢复可点击
                btn.enabled = true
                // 当前按钮设置为取消收藏状态
                btn.setImage(UIImage(named: "Collection")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            }, failCall: { (error) in
                print("清除收藏错误，原因是：" + error.localizedDescription)
                // 按钮恢复可点击
                btn.enabled = true
            })
        }
        else
        {
            // 进行收藏操作
            API.userCollection(type, objectId: model.avObject.objectId, successCall: { 
                // 更新model
                self.dataArr[(indexPath?.item)!].isCollection = true
                // 按钮恢复可点击
                btn.enabled = true
                // 当前按钮设置为赞状态
                btn.setImage(UIImage(named: "Collection-Fill")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            }, failCall: { (error) in
                print("收藏出错，原因是：" + error.localizedDescription)
                // 按钮恢复可点击
                btn.enabled = true
            })
        }
    }
}

extension NewCommon: LYShareMenuViewDelegate
{
    func shareMenuView(shareMenuView: LYShareMenuView!, didSelecteShareMenuItem shareMenuItem: LYShareMenuItem!, atIndex index: Int)
    {
        let object = dataArr[shareIndex].avObject
        let text = (object["desc"] as? String)! + "\n" + (object["url"] as? String)!
        let url = NSURL(string: (object["url"] as? String)!)
        let title = (object["desc"] as? String)! + "\n" + (object["url"] as? String)!
        let platformType = Common.getPlatformTypeByIndex(index)
        
        // 进行分享
        API.share(text, images: nil, url: url!, title: title, contentType: .Auto, platformType: platformType, successCall: {
            var message = ""
            if platformType == .TypeCopy
            {
                message = "复制成功。"
            }
            else
            {
                message = "分享成功。"
            }
            // 分享成功弹出框
            let alert = UIAlertController(title: nil, message: message, preferredStyle: .Alert)
            let sure = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alert.addAction(sure)
            self.presentViewController(alert, animated: true, completion: nil)
        }, failCall: { (error) in
            print(error.description)
            print(error.localizedDescription)
            // 分享失败弹出框
            let alert = UIAlertController(title: nil, message: "分享失败，请稍后再试.", preferredStyle: .Alert)
            let sure = UIAlertAction(title: "确定", style: .Default, handler: nil)
            alert.addAction(sure)
            self.presentViewController(alert, animated: true, completion: nil)
        }) { 
            print("取消分享")
        }
    }
}

extension NewCommon: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let result = dataArr[indexPath.item].avObject
        let vc = ArticleDetail(URLString: result["url"] as? String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewCommon: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let result = dataArr[indexPath.item].avObject
        let contentHeight = (result["title"] as? String)!.stringHeightWith(Common.font16, width: Common.screenWidth - 20)
        return CGSize(width: Common.screenWidth, height: contentHeight + 80 + 40)
    }
}