//
//  New.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import VTMagic

class New: UIViewController
{
    // 顶部的菜单数组
    let menuList = ["iOS", "Android", "Web", "Video", "App"]
    
    var magic: VTMagicController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.hidden = true
        
        initMagicController()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    func initMagicController()
    {
        if magic == nil
        {
            magic = VTMagicController()
            magic.magicView.navigationColor = UIColor.whiteColor()
            magic.magicView.separatorColor = UIColor.flatWhiteColor()
            magic.magicView.sliderColor = Common.mainColor
            magic.magicView.sliderHeight = 1.5
            magic.magicView.layoutStyle = .Center
            magic.magicView.itemSpacing = 20
            magic.magicView.againstStatusBar = true
            magic.magicView.switchStyle = .Default
            magic.magicView.navigationHeight = 44.0
            magic.magicView.dataSource = self
            magic.magicView.delegate = self
            self.addChildViewController(self.magic)
            self.view.addSubview(magic.view)
        }
        magic.magicView.reloadData()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}

extension New: VTMagicViewDataSource
{
    func menuTitlesForMagicView(magicView: VTMagicView!) -> [String]!
    {
        return menuList
    }
    
    func magicView(magicView: VTMagicView!, menuItemAtIndex itemIndex: UInt) -> UIButton!
    {
        var menuItem = magicView.dequeueReusableItemWithIdentifier("ItemWithIdentifier")
        if menuItem == nil
        {
            menuItem = UIButton(type: .Custom)
            menuItem.setTitleColor(UIColor(red: 133.0 / 255.0, green: 133.0 / 255.0, blue: 144.0 / 255.0, alpha: 1.0), forState: .Normal)
            menuItem.setTitleColor(Common.mainColor, forState: .Selected)
            menuItem.titleLabel!.font = Common.font16
        }
        return menuItem
    }
    
    func magicView(magicView: VTMagicView!, viewControllerAtPage pageIndex: UInt) -> UIViewController!
    {
        
//        if (0 == pageIndex)
//        {
//            let recomViewController = magicView.dequeueReusablePageWithIdentifier("PageWithIdentifier")
//            
//            if recomViewController == nil
//            {
//                recomViewController = VTRecomViewController()
//            }
//            return recomViewController;
//        }
//        
//        static NSString *gridId = @"grid.identifier";
//        VTGridViewController *gridViewController = [magicView dequeueReusablePageWithIdentifier:gridId];
//        if (!gridViewController) {
//            gridViewController = [[VTGridViewController alloc] init];
//        }
//        return gridViewController;
//        ["iOS", "Android", "Web", "Video", "App"]
        switch pageIndex
        {
            case 0:
                let vc = NewCommon(type: .iOS)
                return vc
            case 1:
                let vc = NewCommon(type: .Android)
                return vc
            case 2:
                let vc = NewCommon(type: .Web)
                return vc
            case 3:
                let vc = NewCommon(type: .Video)
                return vc
            case 4:
                let vc = NewCommon(type: .App)
                return vc
            default:
                let vc = NewCommon(type: .iOS)
                return vc
        }
    }
}

extension New: VTMagicViewDelegate
{
    func magicView(magicView: VTMagicView!, didSelectItemAtIndex itemIndex: UInt)
    {
        
    }
}