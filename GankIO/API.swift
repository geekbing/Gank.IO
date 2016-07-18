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
    
    // 获取对应的点赞收藏表
    func getZanAndCollection() -> String
    {
        return "ZanAndCollection_\(self)"
    }
    
    // 获取该类型在点赞表和收藏表的列字段名
    func getColName() -> String
    {
        return "\(self)Id"
    }
}

struct API
{
    
    // 根据请求类型获取数据
    static func getDataByTypeAndParams(type: ClassType, limit: Int, skip: Int, successCall: (results: [NewCommonModel]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.desc())
        query.orderByDescending("publishedAt")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]!, error: NSError!) in
            if error == nil
            {
                var dataArr = [NewCommonModel]()
                for item in results
                {
                    let object = item as! AVObject
                    let (isZan, isCollection) = API.isZanOrCollection(type, objectId: object.objectId)
                    let model = NewCommonModel(avObject: object, isZan: isZan, isCollection: isCollection)
                    dataArr.append(model)
                }
                successCall(results: dataArr)
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

    // 用户对某一条内容点赞
    static func userZan(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: classType.getZanAndCollection())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        query.getFirstObjectInBackgroundWithBlock { (object: AVObject!, error: NSError!) in
            if object == nil
            {
                // 新插入一条数据
                let object = AVObject(className: classType.getZanAndCollection())
                object.setObject(AVUser.currentUser().objectId, forKey: "userId")
                object.setObject(objectId, forKey: classType.getColName())
                object.setObject(true, forKey: "isZan")
                object.setObject(false, forKey: "isCollection")
                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                    if success
                    {
                        successCall()
                    }
                    else
                    {
                        failCall(error: error)
                    }
                })
            }
            else
            {
                object.setObject(true, forKey: "isZan")
                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                    if success
                    {
                        successCall()
                    }
                    else
                    {
                        failCall(error: error)
                    }
                })
            }
        }
    }
    
    // 用户对某一条内容删除点赞
    static func userDelZan(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: classType.getZanAndCollection())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        query.getFirstObjectInBackgroundWithBlock { (object: AVObject!, error: NSError!) in
            if object == nil
            {
                successCall()
            }
            else
            {
                let isCollection = object["isCollection"] as! Bool
                if isCollection
                {
                    object.setObject(false, forKey: "isZan")
                    object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                        if success
                        {
                            successCall()
                        }
                        else
                        {
                            failCall(error: error)
                        }
                    })
                }
                else
                {
                    object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                        if success
                        {
                            successCall()
                        }
                        else
                        {
                            failCall(error: error)
                        }
                    })
                }
            }
        }
    }
    
    // 用户对某一条内容收藏
    static func userCollection(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: classType.getZanAndCollection())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        query.getFirstObjectInBackgroundWithBlock { (object: AVObject!, error: NSError!) in
            if object == nil
            {
                // 新插入一条数据
                let object = AVObject(className: classType.getZanAndCollection())
                object.setObject(AVUser.currentUser().objectId, forKey: "userId")
                object.setObject(objectId, forKey: classType.getColName())
                object.setObject(true, forKey: "isCollection")
                object.setObject(false, forKey: "isZan")
                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                    if success
                    {
                        successCall()
                    }
                    else
                    {
                        failCall(error: error)
                    }
                })
            }
            else
            {
                object.setObject(true, forKey: "isCollection")
                object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                    if success
                    {
                        successCall()
                    }
                    else
                    {
                        failCall(error: error)
                    }
                })
            }
        }
    }
    
    // 用户删除对某一条内容的收藏
    static func userDelCollection(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: classType.getZanAndCollection())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        query.getFirstObjectInBackgroundWithBlock { (object: AVObject!, error: NSError!) in
            if object == nil
            {
                successCall()
            }
            else
            {
                let isZan = object["isZan"] as! Bool
                if isZan
                {
                    object.setObject(false, forKey: "isCollection")
                    object.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                        if success
                        {
                            successCall()
                        }
                        else
                        {
                            failCall(error: error)
                        }
                    })
                }
                else
                {
                    object.deleteInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                        if success
                        {
                            successCall()
                        }
                        else
                        {
                            failCall(error: error)
                        }
                    })
                }
            }
        }
    }
    
    // 获取用户是否对一条内容点赞和收藏
    static func isZanOrCollection(classType: ClassType, objectId: String) -> (Bool, Bool)
    {
        let query = AVQuery(className: classType.getZanAndCollection())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        let object = query.getFirstObject()
        // 没有记录，说明没有点赞或者收藏
        if object == nil
        {
            return (false, false)
        }
        else
        {
            return (object["isZan"] as! Bool, object["isCollection"] as! Bool)
        }
    }
}
