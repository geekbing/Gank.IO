//
//  API.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import Alamofire

// 操作类型
enum OperType
{
    case Zan        // 点赞
    case Collection // 收藏
    case Comment    // 评论
    case Share      // 分享
    
    func getColName() -> String
    {
        return "\(self)Num"
    }
}

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
    
    // 获取对应的表名
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
    
    // 获取对应的评论表的表名
    func getCommentName() -> String
    {
        return "Comment_\(self)"
    }
}

struct API
{
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
    
    // 根据请求类型获取文章，不包含点赞收藏评论
    static func getDataByType(type: ClassType, limit: Int, skip: Int, successCall: (results: [AVObject]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.desc())
        query.orderByDescending("resourcePublished")
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
    
    // 根据请求类型获取数据
    static func getDataByTypeAndParams(type: ClassType, limit: Int, skip: Int, successCall: (results: [NewCommonModel]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.desc())
        query.orderByDescending("resourcePublished")
        query.limit = limit
        query.skip = skip
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]!, error: NSError!) in
            if error == nil
            {
                // 首先从结果results数组中抽取出文章ID，组成文章ID数组
                var ids = [String]()
                for item in results
                {
                    let object = item as! AVObject
                    ids.append(object["objectId"] as! String)
                }
                
                // 需要返回的model数组
                var dataArr = [NewCommonModel]()
                
                // 根据文章ID数组，查询是否点赞和收藏
                API.getAllZanOrCollectionByIds(type, ids: ids, successCall: { (dict) in
                    for item in results
                    {
                        let object = item as! AVObject
                        
                        let id = object["objectId"] as! String
                        
                        let model: NewCommonModel
                        
                        if dict[id] != nil
                        {
                            let boolArr = dict[id]! as [Bool]
                            model = NewCommonModel(avObject: object, isZan: boolArr[0], isCollection: boolArr[1])
                        }
                        else
                        {
                            model = NewCommonModel(avObject: object, isZan: false, isCollection: false)
                        }
                        dataArr.append(model)
                    }
                    successCall(results: dataArr)
                }, failCall: { (error) in
                    failCall(error: error)
                })
            }
            else
            {
                failCall(error: error)
            }
        }
    }

    // 某条内容点赞 / 收藏 / 评论 / 分享次数增加数字amount(可为负数)
    static func operIncrementByAmount(classType: ClassType, objectId: String, amount: Int, operType: OperType, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        // 先根据ID获取最新的对象
        let object = AVObject(className: classType.desc(), objectId: objectId)
        object.fetchInBackgroundWithBlock({ (object: AVObject!, error: NSError!) in
            if error == nil
            {
                // 原子增加查看的次数amount
                object.incrementKey(operType.getColName(), byAmount: amount)
                // 保存时自动取回云端最新数据
                object.fetchWhenSave = true
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
                failCall(error: error)
            }
        })
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
                let newObject = AVObject(className: classType.getZanAndCollection())
                newObject.setObject(AVUser.currentUser().objectId, forKey: "userId")
                newObject.setObject(objectId, forKey: classType.getColName())
                newObject.setObject(true, forKey: "isZan")
                newObject.setObject(false, forKey: "isCollection")
                newObject.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
                    if success
                    {
                        // 增加赞的数量
                        API.operIncrementByAmount(classType, objectId: objectId, amount: 1, operType: .Zan, successCall: { 
                            successCall()
                        }, failCall: { (error) in
                            failCall(error: error)
                        })
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
                        API.operIncrementByAmount(classType, objectId: objectId, amount: 1, operType: .Zan, successCall: { 
                            successCall()
                        }, failCall: { (error) in
                            failCall(error: error)
                        })
                    }
                    else
                    {
                        failCall(error: error)
                    }
                })
            }
        }
    }
    
    // 根据文章ID，获取用户赞和收藏的数组
    static func getAllZanOrCollectionByIds(type: ClassType, ids: [String], successCall: (dict: [String: [Bool]]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.getZanAndCollection())
        query.whereKey("userId", equalTo: AVUser.currentUser().objectId)
        query.whereKey(type.getColName(), containedIn: ids)
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]!, error: NSError!) in
            if error == nil
            {
                // 将所有赞或收藏的结果数组转换成[文章ID：（isZan, isCollection）]的字典
                var dict = [String: [Bool]]()
                for item in results
                {
                    let object = item as! AVObject
                    // 获取文章ID
                    let id = object[type.getColName()] as! String
                    // 获取是否赞，是否收藏
                    let isZan = object["isZan"] as! Bool
                    let isCollection = object["isCollection"] as! Bool
                    // 构建字典
                    dict[id] = [isZan, isCollection]
                }
                successCall(dict: dict)
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
                            API.operIncrementByAmount(classType, objectId: objectId, amount: -1, operType: .Zan, successCall: {
                                successCall()
                            }, failCall: { (error) in
                                failCall(error: error)
                            })
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
                            API.operIncrementByAmount(classType, objectId: objectId, amount: -1, operType: .Zan, successCall: {
                                successCall()
                            }, failCall: { (error) in
                                failCall(error: error)
                            })
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
                        API.operIncrementByAmount(classType, objectId: objectId, amount: 1, operType: .Collection, successCall: {
                            successCall()
                        }, failCall: { (error) in
                            failCall(error: error)
                        })
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
                        API.operIncrementByAmount(classType, objectId: objectId, amount: 1, operType: .Collection, successCall: {
                            successCall()
                            }, failCall: { (error) in
                                failCall(error: error)
                        })
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
                            API.operIncrementByAmount(classType, objectId: objectId, amount: -1, operType: .Collection, successCall: {
                                successCall()
                                }, failCall: { (error) in
                                    failCall(error: error)
                            })
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
                            API.operIncrementByAmount(classType, objectId: objectId, amount: -1, operType: .Collection, successCall: {
                                successCall()
                                }, failCall: { (error) in
                                    failCall(error: error)
                            })
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
    
    // 分页获取用户针对某一内容的评论数据
    static func getCommentByTypeAndParams(type: ClassType, object: AVObject, limit: Int, skip: Int, successCall: (results: [AVObject]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.getCommentName())
        query.limit = limit
        query.skip = skip
        query.whereKey("target", equalTo: object)
        query.includeKey("user")
        query.findObjectsInBackgroundWithBlock { (results: [AnyObject]!, error: NSError!) in
            if error == nil
            {
                successCall(results: results as! [AVObject])
            }
            else
            {
                print(error.localizedDescription)
                failCall(error: error)
            }
        }
    }
    
    // 用户评论某一文章
    static func userComment(type: ClassType, target: AVObject, content: String, successCall: () -> (), failCall: (error: NSError) -> ())
    {
        let object = AVObject(className: type.getCommentName())
        object.setObject(AVUser.currentUser(), forKey: "user")
        object.setObject(target, forKey: "target")
        object.setObject(content, forKey: "content")
        object.saveInBackgroundWithBlock { (success: Bool, error: NSError!) in
            if success
            {
                // 原子增加评论的次数amount
                target.incrementKey(OperType.Comment.getColName(), byAmount: 1)
                // 保存时自动取回云端最新数据
                target.fetchWhenSave = true
                target.saveInBackgroundWithBlock({ (success: Bool, error: NSError!) in
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
    
    // 搜索
    static func searchByType(type: ClassType, searchWord: String, limit: Int, skip: Int, successCall: (results: [AVObject]) -> (), failCall: (error: NSError) -> ())
    {
        let query = AVQuery(className: type.desc())
        query.limit = limit
        query.skip = skip
        query.whereKey("title", containsString: searchWord)
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
}
