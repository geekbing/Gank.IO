//
//  AppDelegate.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import Toast_Swift
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
        setupRongCloud()            // 配置融云聊天
        setupRootViewController()   // 配置根控制器
        setupShareSDK()             // 配置shareSDK
       
        return true
    }
    
    // 配置全局样式
    func setupGlobalStyle()
    {
        UIApplication.sharedApplication().statusBarHidden = false
        UIApplication.sharedApplication().statusBarStyle = .LightContent
//        UINavigationBar.appearance().translucent = false
//        UINavigationBar.appearance().setBackgroundImage(UIImage.imageWithColor(Common.mainColor, size: CGSize(width: Common.screenWidth, height: 64)))
//        UINavigationBar.appearance().barTintColor = Common.mainColor
        
        // 给导航条增加一个纯色背景来实现设置导航条背景色
        UINavigationBar.appearance().setBackgroundImage(UIImage.imageWithColor(Common.mainColor, size: CGSize(width: Common.screenWidth, height: 64)), forBarMetrics: .Default)

        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSFontAttributeName: Common.font18, NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        // 设置导航条返回按钮
        let backImg = UIImage(named: "Back")?.resizableImageWithCapInsets(UIEdgeInsetsMake(0, 30, 0, 0))
        UIBarButtonItem.appearance().setBackButtonBackgroundImage(backImg?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal, barMetrics: .Default)
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffsetMake(-100.0, -100.0), forBarMetrics: UIBarMetrics.Default)
        
        // 去掉底部tabbar的分割线
        UITabBar.appearance().clipsToBounds = true
        UITabBar.appearance().tintColor = Common.mainColor

        // 配置SVProgressHUD样式
        SVProgressHUD.setDefaultStyle(.Custom)
        SVProgressHUD.setMinimumDismissTimeInterval(1.2)
        SVProgressHUD.setFont(Common.font14)
        // SVProgressHUD.setOffsetFromCenter(UIOffset(horizontal: 0, vertical: -Common.screenHeight / 2 + 150))
        SVProgressHUD.setErrorImage(UIImage(named: "Close"))
        SVProgressHUD.setInfoImage(UIImage(named: "Info"))
        SVProgressHUD.setSuccessImage(UIImage(named: "Correct"))
        SVProgressHUD.setBackgroundColor(UIColor.flatBlackColor())
        SVProgressHUD.setForegroundColor(UIColor.flatWhiteColor())
        
        // 配置Toast样式
        var style = ToastStyle()
        style.horizontalPadding = 20
        style.verticalPadding = 20
        style.messageFont = Common.font14
        ToastManager.shared.style = style
        ToastManager.shared.duration = 1.5
        ToastManager.shared.position = .Top
        ToastManager.shared.queueEnabled = true
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
    
    func setupRongCloud()
    {
        RCIM.sharedRCIM().userInfoDataSource = self
        
        let AppKey = "x18ywvqf8866c"
        // let AppSecret = "hlTtUdcsWpV"
        RCIM.sharedRCIM().initWithAppKey(AppKey)
        
        let testUserToken = "iQB1IyJtSXYsxRx9HOyDCLhM/6v5Esk40gZVNL9Od8Abh+LRxlg0KRS+8UYSYX4CVgnTynNGGMe1gPZ+xS83reznxw1P/JdbEf9gBtHBwGtWSmQx9QfFdg=="
        RCIM.sharedRCIM().connectWithToken(testUserToken, success: { (userId) in
            print("登陆成功。当前登录的用户ID：\(userId)")
        }, error: { (status: RCConnectErrorCode) in
            print("登陆的错误码为:\(status.rawValue)")
        }) {
            // token过期或者不正确。
            // 如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
            // 如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
            print("token错误")
        }
    }
    
    // 配置根控制器
    func setupRootViewController()
    {
        window = UIWindow(frame: UIScreen.mainScreen().bounds)
        window?.backgroundColor = UIColor.whiteColor()
        
        // 如果有新版本，则进入用户引导界面
        if Common.isNewVersion()
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
        /**
         *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册，
         *  在将生成的AppKey传入到此方法中。
         *  方法中的第二个参数用于指定要使用哪些社交平台，以数组形式传入。第三个参数为需要连接社交平台SDK时触发，
         *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
         *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
         */
        
        ShareSDK.registerApp(AppKey, activePlatforms: [
            SSDKPlatformType.TypeWechat.rawValue,
            SSDKPlatformType.SubTypeWechatSession.rawValue,
            SSDKPlatformType.SubTypeWechatTimeline.rawValue,
            SSDKPlatformType.TypeQQ.rawValue,
            SSDKPlatformType.SubTypeQQFriend.rawValue,
            SSDKPlatformType.SubTypeQZone.rawValue,
            SSDKPlatformType.TypeSinaWeibo.rawValue,
            SSDKPlatformType.TypeMail.rawValue,
            SSDKPlatformType.TypeSMS.rawValue,
            SSDKPlatformType.TypeCopy.rawValue
        ], onImport: { (platform: SSDKPlatformType) in
            switch platform
            {
                // 微信
                case .TypeWechat:
                    ShareSDKConnector.connectWeChat(WXApi.classForCoder())
                // 新浪微博
                case .TypeSinaWeibo:
                    ShareSDKConnector.connectWeibo(WeiboSDK.classForCoder())
                // QQ
                case .TypeQQ:
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
                    appInfo.SSDKSetupWeChatByAppId("wxcd9fa91650ef51d5", appSecret:     "485a163937c314453d7ca797119ac3e6")
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

extension AppDelegate: RCIMUserInfoDataSource
{
    // 获取用户信息
    func getUserInfoWithUserId(userId: String!, completion: ((RCUserInfo!) -> Void)!)
    {
        let userInfo = RCUserInfo()
        userInfo.userId = userId
        switch userId
        {
            case "578855872e958a005410f778":
                userInfo.name = "Bing"
                userInfo.portraitUri = "http://diary123.oss-cn-shanghai.aliyuncs.com/me.jpg"
            case "578cde816be3ff006ceaffc0":
                userInfo.name = "程序媛"
                userInfo.portraitUri = "http://diary123.oss-cn-shanghai.aliyuncs.com/ITGank.png"
            default:
                print("无此用户")
        }
        return completion(userInfo)
    }
}
