//
//  AppDelegate.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SVProgressHUD

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        setupGlobalStyle()          // 配置全局样式
        setupGlobalData()           // 配置全局数据
        setupLeanCloud()            // 配置LeanCloud
        setupRootViewController()   // 配置根控制器
        setupShareSDK()             // 配置shareSDK
       
        return true
    }
    
    // 配置全局样式
    func setupGlobalStyle()
    {
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
        UINavigationBar.appearance().translucent = false
        UINavigationBar.appearance().barTintColor = mainColor
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: font18, NSForegroundColorAttributeName: UIColor.whiteColor()]
        // 设置导航条返回按钮
        let backImg = UIImage(named: "Back")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 30, 0, 0))
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal, barMetrics: .Default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-100.0, -100.0), forBarMetrics: UIBarMetrics.Default)
        
        // 配置SVProgressHUDStyle
        SVProgressHUD.setMinimumDismissTimeInterval(1.5)
    }
    
    // 配置全局数据
    func setupGlobalData()
    {
        
    }
    
    // 配置LeanCloud
    func setupLeanCloud()
    {
        let AppID = "TWpjtxh1X7AWkS0RIz7tz2MW-gzGzoHsz"
        let AppKey = "ihT09VMyr4sY0naf833CTnqA"
        // 注册LeanCloud
        AVOSCloud.setApplicationId(AppID, clientKey: AppKey)
    }
    
    // 配置根控制器
    func setupRootViewController()
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 如果有新版本，则进入用户引导界面
        if isNewVersion()
        {
            window?.rootViewController = Guide()
        }
        else
        {
            // 如果当前用户没登录则进入登录界面
            if AVUser.currentUser() == nil
            {
                window?.rootViewController = UINavigationController(rootViewController: Login())
            }
            else
            {
                // 否则直接进入主界面
                let vc = Main()
                window?.rootViewController = vc
            }
        }
        window?.makeKeyAndVisible()
    }
    
    // 配置shareSDK
    func setupShareSDK()
    {
        let AppKey = "14f69640aefab"
//        let AppSecret = "c001df46d12a250316d7800ea4982eec"
        
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        ShareSDK.registerApp(AppKey, activePlatforms: [
            SSDKPlatformType.TypeSinaWeibo.rawValue,
            SSDKPlatformType.SubTypeWechatSession.rawValue,
            SSDKPlatformType.TypeWechat.rawValue,
            SSDKPlatformType.SubTypeQZone.rawValue,
            SSDKPlatformType.TypeQQ.rawValue,
            SSDKPlatformType.SubTypeQQFriend.rawValue
        ], onImport: { (platform: SSDKPlatformType) in
            switch platform
            {
                case SSDKPlatformType.TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                case SSDKPlatformType.TypeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                case SSDKPlatformType.TypeQQ:
                    ShareSDKConnector.connectQQ(QQApiInterface.classForCoder(), tencentOAuthClass: TencentOAuth.classForCoder())
                default:
                    break
            }
        }) { (platform: SSDKPlatformType, appInfo: NSMutableDictionary!) in
            switch platform
            {
                // 设置新浪微博应用信息
                case SSDKPlatformType.TypeSinaWeibo:
                    appInfo.SSDKSetupSinaWeiboByAppKey("4287282896",
                                                   appSecret : "97a2d01b2ddd9a704dfbe3179643ff6a",
                                                   redirectUri : "http://www.sharesdk.cn",
                                                   authType : SSDKAuthTypeBoth)
                    break
                // 设置微信应用信息
                case SSDKPlatformType.TypeWechat:
                    appInfo.SSDKSetupWeChatByAppId("wx4868b35061f87885", appSecret:     "64020361b8ec4c99936c0e3999a9f249")
                    break
                // 设置QQ应用信息
                case SSDKPlatformType.TypeQQ:
                    appInfo.SSDKSetupQQByAppId("1105542914", appKey: "eLkLRBfT7v6FD4TO", authType: SSDKAuthTypeBoth)
                    break
                default:
                    break
            }
        }
    }
    
    func applicationWillResignActive(application: UIApplication)
    {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication)
    {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication)
    {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication)
    {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication)
    {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

