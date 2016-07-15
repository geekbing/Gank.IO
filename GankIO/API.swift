//
//  API.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import Alamofire

enum URLType
{
    case iOS
    case Android
    case Web
    case Video
    case App
    case Photos
}

// 根据文章的请求类型获取请求地址
func getBaseUrlByType(type: URLType) -> String
{
    var url: String
    switch type
    {
        case .iOS:
            url = "http://gank.io/api/data/iOS"
            break
        case .Android:
            url = "http://gank.io/api/data/Android"
            break
        case .Web:
            url = "http://gank.io/api/data/前端"
            break
        case .Video:
            url = "http://gank.io/api/data/休息视频"
            break
        case .App:
            url = "http://gank.io/api/data/App"
            break
        case .Photos:
            url = "http://gank.io/api/data/福利"
            break
    }
    return url
}

func getUrlByTypeCountAndPage(type: URLType, count: Int, page: Int) -> String
{
    let baseUrl = getBaseUrlByType(type)
    return baseUrl + "/" + String(count) + "/" + String(page)
}


// 根据笑话请求类型获取笑话
func getArticlesByType(url: String, callBack: (result: [Result]) -> ())
{
    Alamofire.request(.GET, url).responseJSON { (response) in
        switch response.result
        {
            case .Success:
                if let dict = response.result.value as? NSDictionary
                {
                    let root = RootClass(fromDictionary: dict)
                    callBack(result: root.results)
                }
            case .Failure(let error):
                print(error)
        }
    }
}

// 注册
func register(username: String, password: String, email: String, successCall: () -> (), failCall: (error: NSError) -> ())
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
func login(username: String, password: String, successCall: (user: AVUser) -> (), failCall: (error: NSError) -> ())
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