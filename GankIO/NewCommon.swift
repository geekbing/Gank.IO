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
    var dataArr = [AVObject]()
    
    var collectionView: UICollectionView!
    
    // 是否赞
    var isZan = false
    // 是否收藏
    var isCollection = true
    
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
        
        showLoding("加载数据中...")
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
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 64), collectionViewLayout: layout)
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
            self.dataArr = results
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

extension NewCommon: ToolBarViewDelegate
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

extension NewCommon: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let result = dataArr[indexPath.item]
        let vc = ArticleDetail(URLString: result["url"] as? String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewCommon: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let result = dataArr[indexPath.item]
        let contentHeight = (result["desc"] as? String)!.stringHeightWith(font16, width: screenWidth - 20)
        return CGSize(width: screenWidth, height: contentHeight + 80 + 40)
    }
}