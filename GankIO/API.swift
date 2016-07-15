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
}
