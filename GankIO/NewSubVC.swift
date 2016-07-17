//
//  NewSubVC.swift
//  GankIO
//
//  Created by Bing on 7/13/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import MJRefresh

class NewSubVC: UIViewController
{
    var dataArr = [AVObject]()
    var collectionView: UICollectionView!
    
    // 是否赞
    var isZan = false
    // 是否收藏
    var isCollection = true
    // 当前页数
    var currentPage = 1

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight - 64), collectionViewLayout: layout)
        collectionView.registerClass(NewSubVCCell.classForCoder(), forCellWithReuseIdentifier: "NewSubVCCell")
        
        collectionView.backgroundColor = UIColor.flatWhiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        // 下拉刷新和上拉加载
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
        // TODO
//        API.getArticlesByType(API.getUrlByTypeCountAndPage(.iOS, count: 10, page: 1)) { (result) in
//            self.dataArr = result
//            self.collectionView.reloadData()
//        }
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        // TODO
//        API.getArticlesByType(API.getUrlByTypeCountAndPage(.iOS, count: 10, page: 1)) { (result) in
//            self.currentPage = 1
//            self.collectionView.mj_header.endRefreshing()
//            self.dataArr = result
//            self.collectionView.reloadData()
//        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        // TODO
//        API.getArticlesByType(API.getUrlByTypeCountAndPage(.iOS, count: 10, page: currentPage + 1)) { (result) in
//            self.currentPage += 1
//            self.collectionView.mj_footer.endRefreshing()
//            self.dataArr.appendContentsOf(result)
//            self.collectionView.reloadData()
//        }
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

extension NewSubVC: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("NewSubVCCell", forIndexPath: indexPath) as! NewSubVCCell
    
        cell.backgroundColor = UIColor.whiteColor()
        let result = dataArr[indexPath.row]
        cell.who?.text = result["who"] as? String
        cell.publishedAt?.text = result["publishedAt"] as? String
        cell.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: (result["who"] as? String) ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        cell.desc?.text = result["desc"] as? String
        
        cell.toolBar?.delegate = self
        
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

extension NewSubVC: ToolBarViewDelegate
{
    // 点击分享按钮
    func clickShare(btn: UIButton, event: UIEvent)
    {
        // 获取点击位置所在的行
//        let indexPath = getIndexByTouch(event)
        
        let imagePath = NSBundle.mainBundle().pathForResource("ShareTest", ofType: "png")
        let shareImage = UIImage(contentsOfFile: imagePath!)
        
        
        let shareParames = NSMutableDictionary()
        
        shareParames.SSDKSetupShareParamsByText("分享测试",
                                                images : shareImage,
                                                url : NSURL(string:"http://geekbing.com"),
                                                title : "分享标题",
                                                type : SSDKContentType.Image)
        
        ShareSDK.share(SSDKPlatformType.TypeQQ, parameters: shareParames) { (state: SSDKResponseState, userData: [NSObject : AnyObject]!, contentEntity: SSDKContentEntity!, error: NSError!) in
            switch state
            {
            case SSDKResponseState.Success:
                print("分享成功")
                let alert = UIAlertController(title: nil, message: "分享成功", preferredStyle: .Alert)
                let sure = UIAlertAction(title: "确定", style: .Default, handler: { (action) in
                })
                alert.addAction(sure)
                self.presentViewController(alert, animated: true, completion: nil)
            case SSDKResponseState.Fail:
                print("分享失败,错误描述:\(error)")
                let alert = UIAlertController(title: nil, message: "分享失败", preferredStyle: .Alert)
                let sure = UIAlertAction(title: "确定", style: .Default, handler: { (action) in
                })
                alert.addAction(sure)
                self.presentViewController(alert, animated: true, completion: nil)
            case SSDKResponseState.Cancel:
                print("分享取消")
            default:
                break
            }
        }
        
        //2.进行分享
      /*  ShareSDK.share(SSDKPlatformType.TypeSinaWeibo, parameters: shareParames) { (state : SSDKResponseState, userData : [NSObject : AnyObject]!, contentEntity :SSDKContentEntity!, error : NSError!) -> Void in
            
            switch state
            {
                case SSDKResponseState.Success:
                    print("分享成功")
                    let alert = UIAlertController(title: nil, message: "分享成功", preferredStyle: .Alert)
                    let sure = UIAlertAction(title: "确定", style: .Default, handler: { (action) in
                    })
                    alert.addAction(sure)
                    self.presentViewController(alert, animated: true, completion: nil)
                case SSDKResponseState.Fail:
                    print("分享失败,错误描述:\(error)")
                    let alert = UIAlertController(title: nil, message: "分享失败", preferredStyle: .Alert)
                    let sure = UIAlertAction(title: "确定", style: .Default, handler: { (action) in
                    })
                    alert.addAction(sure)
                    self.presentViewController(alert, animated: true, completion: nil)
                case SSDKResponseState.Cancel:
                    print("分享取消")
                default:
                    break
            }
        }*/
    }
    
    // 点击评论按钮
    func clickComment(btn: UIButton, event: UIEvent)
    {
        // 获取点击位置所在的行
        let indexPath = getIndexByTouch(event)
        let result = dataArr[indexPath!.row]
        let vc = Comment()
        vc.result = result
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 点击赞按钮
    func clickZan(btn: UIButton, event: UIEvent)
    {
        // 获取点击位置所在的行
        // let indexPath = getIndexByTouch(event)
        if isZan == false
        {
            isZan = true
            btn.setImage(UIImage(named: "Zan-Fill")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        else
        {
            isZan = false
            btn.setImage(UIImage(named: "Zan")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
    }
    
    // 点击收藏按钮
    func clickCollection(btn: UIButton, event: UIEvent)
    {
        // 获取点击位置所在的行
//        let indexPath = getIndexByTouch(event)
        if isCollection == false
        {
            isCollection = true
            btn.setImage(UIImage(named: "Collection-Fill")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        else
        {
            isCollection = false
            btn.setImage(UIImage(named: "Collection")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
    }
}

extension NewSubVC: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let result = dataArr[indexPath.item]
        let vc = ArticleDetail(URLString: result["url"] as? String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewSubVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let result = dataArr[indexPath.item]
        let contentHeight = (result["desc"] as? String)!.stringHeightWith(Common.font16, width: Common.screenWidth - 20)
        return CGSize(width: Common.screenWidth, height: contentHeight + 80 + 40)
    }
}