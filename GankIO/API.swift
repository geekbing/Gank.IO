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
    
    // 获取对应的点赞表
    func getZanClass() -> String
    {
        return "Zan_\(self)"
    }
    
    // 获取收藏表的表名
    func getCollectionClass() -> String
    {
        return "Collection_\(self)"
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
                    let isZan = API.isZan(type, objectId: object.objectId)
                    let isCollection = API.isCollection(type, objectId: object.objectId)
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
    static func Zan(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let object = AVObject(className: classType.getZanClass())
        object.setValue(AVUser.currentUser().objectId, forKey: "userId")
        object.setValue(objectId, forKey: classType.getColName())
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) in
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
    
    // 用户对某一条内容点赞
    static func userZan(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let object = AVObject(className: classType.getZanClass())
        object.setObject(AVUser.currentUser().objectId, forKey: "userId")
        object.setObject(objectId, forKey: classType.getColName())
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) in
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
    
    // 用户对某一条内容删除点赞
    static func userDelZan(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: classType.getZanClass())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        query.getFirstObjectInBackgroundWithBlock { (object: AVObject!, error: NSError!) in
            if error == nil
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
            else
            {
                failCall(error: error)
            }
        }
    }
    
    // 用户对某一条内容收藏
    static func userCollection(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let object = AVObject(className: classType.getCollectionClass())
        object.setObject(AVUser.currentUser().objectId, forKey: "userId")
        object.setObject(objectId, forKey: classType.getColName())
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) in
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
    
    // 用户删除对某一条内容的收藏
    static func userDelCollection(classType: ClassType, objectId: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: classType.getCollectionClass())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        query.getFirstObjectInBackgroundWithBlock { (object: AVObject!, error: NSError!) in
            if error == nil
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
            else
            {
                failCall(error: error)
            }
        }
    }
    
    // 获取用户是否对一条内容收藏
    static func isZan(classType: ClassType, objectId: String) -> Bool
    {
        let query = AVQuery(className: classType.getZanClass())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        let results = query.findObjects()
        // 有记录，说明已经点赞
        if results != nil && results.count != 0
        {
            return true
        }
        else
        {
            return false
        }
    }
    
    // 获取用户是否对一条内容收藏
    static func isCollection(classType: ClassType, objectId: String) -> Bool
    {
        let query = AVQuery(className: classType.getCollectionClass())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(classType.getColName(), equalTo: objectId)
        let results = query.findObjects()
        // 有记录，说明已经收藏
        if results != nil && results.count != 0
        {
            return true
        }
        else
        {
            return false
        }
    }
}
