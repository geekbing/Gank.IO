//
//  Outsourcing.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SVProgressHUD

class Outsourcing: UIViewController
{
    var collectionView: UICollectionView!
    var dataArr = [OutsourcingModel]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 20
        
        collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight - 49 - 20), collectionViewLayout: layout)
        
        collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 15, right: 0)
        collectionView.backgroundColor = UIColor(red:0.93, green:0.95, blue:0.95, alpha:1.00)
        collectionView.registerClass(OutsourcingCell.self, forCellWithReuseIdentifier: "OutsourcingCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        // 获取数据
        SVProgressHUD.show()
        API.grabDataFromWaibao({ (dataArr) in
            SVProgressHUD.dismiss()
            self.dataArr = dataArr
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
        
        cell?.desc?.text = model.desc
        cell?.title?.text = model.title
        cell?.money?.text = model.money
        cell?.type?.text = model.type.desc()
        cell?.bigImg?.image = UIImage(named: model.type.desc() + "BigImg")
        cell?.typeImage?.image = UIImage(named: model.type.desc() + "MiniImg")
        cell?.status?.text = model.status.desc()
        cell?.status?.backgroundColor = model.status.getBackgroundColor()
        
        return cell!
    }

}

extension Outsourcing: UICollectionViewDelegate
{
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let result = dataArr[indexPath.item]
        let vc = ArticleDetail(URLString: result.url)
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension Outsourcing: UICollectionViewDelegateFlowLayout
{
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
        let model = dataArr[indexPath.item]
        // 标题高度
        let titleHeight = model.title.stringHeightWith(Common.font18, width: Common.screenWidth - 40)
        // 描述高度
        let descHeight = model.desc.stringHeightWith(Common.font14, width: Common.screenWidth - 40)
        
        return CGSize(width: Common.screenWidth - 20, height: titleHeight + descHeight + 280)
    }
}
