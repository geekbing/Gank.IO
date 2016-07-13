//
//  Category.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Category: UIViewController
{
    // 分类
    var categoryArr = ["福利", "iOS", "Android", "前端", "App", "拓展资源", "休息视频", "瞎推荐"]
    // 图片
    let imageArr = ["福利", "iOS", "Android", "前端", "App", "拓展资源", "休息视频", "瞎推荐"]
    // 颜色
    let colorArr = [cateColor1, cateColor2, cateColor3, cateColor4, cateColor5, cateColor6, cateColor7, cateColor8]
    
    var tableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "分类"
        self.automaticallyAdjustsScrollViewInsets = false
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: screenWidth, height: screenHeight - 64 - 49))
        tableView.separatorStyle = .None
        tableView.dataSource = self
        tableView.delegate = self
        tableView.registerClass(CategoryCell.classForCoder(), forCellReuseIdentifier: "CategoryCell")
        view.addSubview(tableView)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension Category: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.categoryArr.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("CategoryCell", forIndexPath: indexPath) as! CategoryCell
//        for view in (cell?.subviews)!
//        {
//            view.removeFromSuperview()
//        }
        cell.backgroundColor = colorArr[indexPath.row]
        cell.imgView?.image = UIImage(named: imageArr[indexPath.row])?.imageWithRenderingMode(.AlwaysTemplate)
        cell.imgView?.tintColor = UIColor.whiteColor()
        cell.title?.text = categoryArr[indexPath.row]
        return cell
    }
}

extension Category: UITableViewDelegate
{
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return (tableView.bounds.height) / 3.0
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        var vc: UIViewController
        if indexPath.row == 0
        {
            vc = Girls()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        else
        {
            let vc = IOSVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
