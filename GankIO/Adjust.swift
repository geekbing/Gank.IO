//
//  Adjust.swift
//  GankIO
//
//  Created by Bing on 7/24/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import Material

class Adjust: UIViewController
{
    var tableView: UITableView!
    var dataArr = [["title": "iOS", "icon": ""],
                   ["title": "Android", "icon": ""],
                   ["title": "前端", "icon": ""],
                   ["title": "App", "icon": ""],
                   ["title": "拓展资源", "icon": ""],
                   ["title": "休息视频", "icon": ""],
                   ["title": "瞎推荐", "icon": ""],
                   ["title": "福利", "icon": ""]]
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "主题调整"
        view.backgroundColor = UIColor.whiteColor()
        
        // 导航条右上角的重置按钮
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "重置", style: .Plain, target: self, action: .resetBtnClick)
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.flatWhiteColor()
        
        // 表格视图
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: Common.screenWidth, height: Common.screenHeight))
        tableView.registerClass(AdjustCell.self, forCellReuseIdentifier: "AdjustCell")
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.tableFooterView = UIView()
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        // 给表格增加长按手势
        let longPress = UILongPressGestureRecognizer(target: self, action: .tableviewLongPressed)
        longPress.minimumPressDuration = 0.5
        tableView.addGestureRecognizer(longPress)
        
        // 最下面的保存按钮
        let saveBtn = RaisedButton()
        saveBtn.layer.masksToBounds = true
        saveBtn.layer.cornerRadius = 20
        saveBtn.pulseColor = UIColor.whiteColor()
        saveBtn.backgroundColor = Common.mainColor
        saveBtn.titleLabel?.font = Common.font16
        saveBtn.setTitle("保存", forState: .Normal)
        saveBtn.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        saveBtn.addTarget(self, action: .saveBtnClick, forControlEvents: .TouchUpInside)
        view.addSubview(saveBtn)
        
        // 布局
        saveBtn.snp_makeConstraints { (make) in
            make.left.equalTo(30)
            make.right.equalTo(-30)
            make.height.equalTo(40)
            make.bottom.equalTo(-100)
        }
    }
    
    // 点击保存按钮
    func saveBtnClick()
    {
        tableView.setEditing(false, animated: true)
    }
    
    // 点击重置按钮
    func resetBtnClick()
    {
        tableView.setEditing(false, animated: true)
        dataArr = [["title": "iOS", "icon": ""],
                   ["title": "Android", "icon": ""],
                   ["title": "前端", "icon": ""],
                   ["title": "App", "icon": ""],
                   ["title": "拓展资源", "icon": ""],
                   ["title": "休息视频", "icon": ""],
                   ["title": "瞎推荐", "icon": ""],
                   ["title": "福利", "icon": ""]]
        tableView.reloadData()
    }
    
    // 长按表格
    func tableviewLongPressed(gestureRecognizer: UILongPressGestureRecognizer)
    {
        if gestureRecognizer.state == .Began
        {
            if tableView.editing == false
            {
                tableView.setEditing(true, animated: true)
            }
        }
    }
    
    // 消除分割线前面的间距
    override func viewDidLayoutSubviews()
    {
        tableView.separatorInset = UIEdgeInsetsZero
        tableView.layoutMargins = UIEdgeInsetsZero
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.hidden = false
        tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

private extension Selector
{
    static let saveBtnClick = #selector(Adjust.saveBtnClick)
    static let resetBtnClick = #selector(Adjust.resetBtnClick)
    static let tableviewLongPressed = #selector(Adjust.tableviewLongPressed(_:))
}

extension Adjust: UITableViewDataSource
{
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return dataArr.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("AdjustCell", forIndexPath: indexPath) as! AdjustCell
        let cellData = dataArr[indexPath.row]
        
        cell.title?.text = cellData["title"]
        cell.icon?.image = UIImage(named: cellData["icon"]!)
        
        cell.showsReorderControl = false
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath)
    {
        let source = dataArr[sourceIndexPath.row]
        dataArr.removeAtIndex(sourceIndexPath.row)
        dataArr.insert(source, atIndex: destinationIndexPath.row)
        tableView.reloadData()
    }
    
    // 进入编辑模式，按下出现的编辑按钮后, 进行删除操作
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        dataArr.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    }
    
    func tableView(tableView: UITableView, titleForDeleteConfirmationButtonForRowAtIndexPath indexPath: NSIndexPath) -> String?
    {
        return "删除"
    }
}

extension Adjust: UITableViewDelegate
{
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath)
    {
        cell.separatorInset = UIEdgeInsetsZero
        cell.layoutMargins = UIEdgeInsetsZero
    }
    
    func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle
    {
        tableView.setEditing(true, animated: true)
        return .Delete
    }
}