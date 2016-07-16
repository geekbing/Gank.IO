//
//  API.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import Alamofire

// LeanCloud后台存储的表的类型
enum ClassType
{
    case Android
    case App
    case ExpandResource
    case iOS
    case Random
    case Video
    case Web
    case Welfare
    
    // 转换为字符串
    func desc() -> String
    {
        return String(self)
    }
}
struct Common
{
    static func getPlatformTypeByIndex(index: Int) -> SSDKPlatformType
    {
        var platformType: SSDKPlatformType
        switch index
        {
            case 0:
                platformType = .SubTypeWechatSession
            case 1:
                platformType = .SubTypeWechatTimeline
            case 2:
                platformType = .SubTypeQQFriend
            case 3:
                platformType = .SubTypeQZone
            case 4:
                platformType = .TypeSinaWeibo
            case 5:
                platformType = .TypeMail
            case 6:
                platformType = .TypeSMS
            case 7:
                platformType = .TypeCopy
            default:
                platformType = .TypeCopy
        }
        return platformType
    }
}

struct API
{
    
    // 根据请求类型获取数据
    static func getDataByTypeAndParams(type: ClassType, limit: Int, skip: Int, successCall: (results: [AVObject]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.desc())
        query.orderByDescending("publishedAt")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]!, error: NSError!) in
            if error == nil
            {
                successCall(results: results as! [AVObject])
            }
            else
            {
                failCall(error: error)
            }
        }
    }
    
    // 注册
    static func register(username: String, password: String, email: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let newUser = AVUser()
        newUser.username = username
        newUser.password = password
        newUser.email = email
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError!) in
            if success
            {
                successCall()
            }
            else
            {
                failCall(error: error)
            }
        }
    }
    
    // 登录
    static func login(username: String, password: String, successCall: (user: AVUser) -> (), failCall: (error: NSError) -> ())
    {
        AVUser.logInWithUsernameInBackground(username, password: password) { (user: AVUser!, error: NSError!) in
            if user != nil && error == nil
            {
                successCall(user: user)
            }
            else
            {
                failCall(error: error)
            }
        }
    }
    
    // 邮件重置密码
    static func resetPassWordByEmail(email: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        AVUser.requestPasswordResetForEmailInBackground(email) { (success: Bool, error: NSError!) in
            if success
            {
                successCall()
            }
            else
            {
                failCall(error: error)
            }
        }
    }
    
    // 分享内容
    static func share(text: String, images: [UIImage]?, url: NSURL, title: String, contentType: SSDKContentType, platformType: SSDKPlatformType, successCall: () -> (), failCall: (error: NSError) -> (), cancelCall: () -> ())
    {
        // 创建分享参数
        let shareParames = NSMutableDictionary()
        // QQ空间
        if platformType == .SubTypeQZone
        {
            shareParames.SSDKSetupQQParamsByText(text, title: title, url: url, thumbImage: UIImage(named: "Logo"), image: UIImage(named: "Logo"), type: .Auto, forPlatformSubType: .SubTypeQZone)
        }
        else
        {
            shareParames.SSDKSetupShareParamsByText(text, images: images, url: url, title: title, type: contentType)
        }
        // 分享
        ShareSDK.share(platformType, parameters: shareParames) { (state: SSDKResponseState, userData: [NSObject : AnyObject]!, contentEntity: SSDKContentEntity!, error: NSError!) in
            switch state
            {
                case .Success:
                    // 执行分享成功的回调
                    successCall()
                case .Fail:
                    // 执行分享失败的回调
                    failCall(error: error)
                case .Cancel:
                    // 执行分享取消的回调
                    cancelCall()
                default:
                    break
            }
        }
    }
}
