//
//  Main.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Main: UITabBarController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        // 配置tabBar图标颜色
        tabBar.tintColor = mainColor
        // 配置delegate
        delegate = self
        // 添加所有子控制器
        addAllChildViewController()
    }
    
    // 添加所有子控制器
    private func addAllChildViewController()
    {
        // 最新
        let newVc = UINavigationController(rootViewController: New())
//        let newVc = New()
        addChildViewController(newVc, title: "最新", imageName: "New")
        
        // 分类
        let categoryVc = UINavigationController(rootViewController: Category())
        addChildViewController(categoryVc, title: "分类", imageName: "Category")
        
        // 外包
        let outsourcingVc = UINavigationController(rootViewController: Outsourcing())
        addChildViewController(outsourcingVc, title: "外包", imageName: "Outsourcing")
        
        // 我的
        let mineVc = UINavigationController(rootViewController: Mine())
        addChildViewController(mineVc, title: "我的", imageName: "Mine")
    }
    
    /**
     配置添加子控制器
     - parameter childController: 控制器
     - parameter title:           标题
     - parameter imageName:       图片
     */
    private func addChildViewController(childController: UIViewController, title: String, imageName: String)
    {
        childController.title = title
        childController.tabBarItem.title = title
        // childController.tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: -3)
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font10, NSForegroundColorAttributeName: tabbarColor], forState: .Normal)
        childController.tabBarItem.setTitleTextAttributes([NSFontAttributeName: font10, NSForegroundColorAttributeName: mainColor], forState: .Selected)
        childController.tabBarItem.image = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        childController.tabBarItem.selectedImage = UIImage(named: imageName)?.imageWithRenderingMode(.AlwaysTemplate)
        addChildViewController(childController)
    }
}

extension Main: UITabBarControllerDelegate
{
    func tabBarController(tabBarController: UITabBarController, shouldSelectViewController viewController: UIViewController) -> Bool
    {
        //        if viewController == tabBarController.viewControllers![3]
        //        {
        //            let isLogin = NSUserDefaults.standardUserDefaults().valueForKey("isLogin") as? Bool
        //            if isLogin == nil || isLogin == false
        //            {
        //                let vc = UINavigationController(rootViewController: Login())
        //                tabBarController.presentViewController(vc, animated: true, completion: nil)
        //                return false
        //            }
        //        }
        return true
    }
}

