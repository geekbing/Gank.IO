//
//  Outsourcing.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import MJRefresh
import SVProgressHUD

class Outsourcing: UIViewController
{
    var collectionView: UICollectionView!
    var dataArr = [AVObject]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "外包"
        view.backgroundColor = UIColor.whiteColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        
        // 表格视图
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight - 49), collectionViewLayout: layout)
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: -15, right: 0)
        collectionView.backgroundColor = UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.00)
        collectionView.registerClass(OutsourcingCell.self, forCellWithReuseIdentifier: "OutsourcingCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // 下拉刷新和上拉加载
        let header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        header.lastUpdatedTimeLabel.hidden = true
        collectionView.mj_header = header
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
        
        // 获取数据
        SVProgressHUD.show()
        API.getWaibaoData(10, skip: 0, successCall: { (dataArr) in
            SVProgressHUD.dismiss()
            self.dataArr = dataArr
            self.collectionView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错")
        }
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        API.getWaibaoData(10, skip: 0, successCall: { (dataArr) in
            self.collectionView.mj_header.endRefreshing()
            self.dataArr = dataArr
            self.collectionView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错")
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        API.getWaibaoData(10, skip: dataArr.count, successCall: { (resultArr) in
            self.collectionView.mj_footer.endRefreshing()
            self.dataArr.appendContentsOf(resultArr)
            self.collectionView.reloadData()
        }) { (error) in
            SVProgressHUD.showErrorWithStatus("获取数据出错")
        }
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let headerRefresh = #selector(Outsourcing.headerRefresh)
    static let footerRefresh = #selector(Outsourcing.footerRefresh)
}

extension Outsourcing: UICollectionViewDataSource
{
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.dataArr.count
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("OutsourcingCell", forIndexPath: indexPath) as? OutsourcingCell
        
        let model = dataArr[indexPath.row]
        
        cell?.desc?.text = model["detail"] as? String
        cell?.title?.text = model["title"] as? String
        cell?.money?.text = model["price"] as? String
        cell?.type?.text = model["kind"] as? String
        cell?.bigImg?.image = UIImage(named: (model["kind"] as! String) + "BigImg")
        cell?.typeImage?.image = UIImage(named: (model["kind"] as! String) + "MiniImg")
        cell?.status?.text = model["status"] as? String
        cell?.status?.backgroundColor = getStatusByString(model["status"] as! String).getBackgroundColor()
        
        return cell!
    }
}

extension Outsourcing: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let result = dataArr[indexPath.item]
        let vc = ArticleDetail(URLString: result["url"] as? String)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Outsourcing: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let model = dataArr[indexPath.item]
        
        // 标题高度
        let title = model["title"] as! String
        let titleHeight = title.stringHeightWith(Common.font18, width: Common.screenWidth - 40)
        
        // 描述高度
        let desc = model["detail"] as! String
        let descHeight = desc.stringHeightWith(Common.font14, width: Common.screenWidth - 40)
        
        return CGSize(width: Common.screenWidth - 20, height: titleHeight + descHeight + 280)
    }
}
