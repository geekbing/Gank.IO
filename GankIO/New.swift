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
    let menuList = ["iOS", "Android", "前端", "休息视频", "App", "福利"]
    
    var magic: VTMagicController!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        initMagicController()
    }
    
    func initMagicController()
    {
        if magic == nil
        {
            magic = VTMagicController()
            magic.magicView.navigationColor = UIColor.whiteColor()
            magic.magicView.sliderColor = UIColor.redColor()
            magic.magicView.layoutStyle = VTLayoutStyle.Default
            magic.magicView.switchStyle = VTSwitchStyle.Default
            magic.magicView.navigationHeight = 40.0
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

            menuItem.setTitleColor(UIColor(red: 50.0 / 255.0, green: 50.0 / 255.0, blue: 50.0 / 255.0, alpha: 1.0), forState: .Normal)
            menuItem.setTitleColor(UIColor(red: 169.0 / 255.0, green: 37.0 / 255.0, blue: 37.0 / 255.0, alpha: 1.0), forState: .Selected)
            menuItem.titleLabel!.font = font16
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
        switch pageIndex
        {
            case 0:
                let vc = IOSVC()
                return vc
            case 1:
                let vc = AndroidVC()
                return vc
            default:
                let vc = IOSVC()
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