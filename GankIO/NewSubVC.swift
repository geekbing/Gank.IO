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
    var dataArr = [Result]()
    var collectionView: UICollectionView!
    
    // 当前页数
    var currentPage = 1

    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        self.automaticallyAdjustsScrollViewInsets = false
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 64), collectionViewLayout: layout)
        collectionView.registerClass(NewSubVCCell.classForCoder(), forCellWithReuseIdentifier: "NewSubVCCell")
        
        collectionView.backgroundColor = UIColor.flatWhiteColor()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.addSubview(collectionView)
        
        // 下拉刷新和上拉加载
        collectionView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: .headerRefresh)
        collectionView.mj_footer = MJRefreshAutoNormalFooter(refreshingTarget: self, refreshingAction: .footerRefresh)
        
        getArticlesByType(getUrlByTypeCountAndPage(.iOS, count: 10, page: 1)) { (result) in
            self.dataArr = result
            self.collectionView.reloadData()
        }
    }
    
    // 下拉刷新
    func headerRefresh()
    {
        getArticlesByType(getUrlByTypeCountAndPage(.iOS, count: 10, page: 1)) { (result) in
            self.currentPage = 1
            self.collectionView.mj_header.endRefreshing()
            self.dataArr = result
            self.collectionView.reloadData()
        }
    }
    
    // 上拉加载
    func footerRefresh()
    {
        getArticlesByType(getUrlByTypeCountAndPage(.iOS, count: 10, page: currentPage + 1)) { (result) in
            self.currentPage += 1
            self.collectionView.mj_footer.endRefreshing()
            self.dataArr.appendContentsOf(result)
            self.collectionView.reloadData()
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
        cell.who?.text = result.who
        cell.publishedAt?.text = result.publishedAt
        cell.avatar?.image = UIImage.createAvatarPlaceholder(userFullName: result.who ?? "代码家", placeholderSize: CGSize(width: 90, height: 90))
        cell.desc?.text = result.desc
        
        return cell
    }
}

extension NewSubVC: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let result = dataArr[indexPath.item]
        let vc = ArticleDetail(URLString: result.url)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension NewSubVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let result = dataArr[indexPath.item]
        let contentHeight = result.desc.stringHeightWith(font16, width: screenWidth - 20)
        return CGSize(width: screenWidth, height: contentHeight + 80 + 40)
    }
}