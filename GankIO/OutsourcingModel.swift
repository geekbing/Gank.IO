//
//  OutsourcingModel.swift
//  GankIO
//
//  Created by Bing on 7/23/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import Foundation

// 外包的类型
enum OutsourcingType
{
    case iOS
    case Android
    case HTML5
    case Script
    case NodeJS
    case Design
    
    func desc() -> String
    {
        return String(self)
    }
}

// 从字符串得到对应的外包类型
func getTypeByString(str: String) -> OutsourcingType
{
    if str == "iOS"
    {
        return .iOS
    }
    else if str == "Android"
    {
        return .Android
    }
    else if str == "HTML5"
    {
        return .HTML5
    }
    else if str == "Script"
    {
        return .Script
    }
    else if str == "NodeJS"
    {
        return .NodeJS
    }
    else
    {
        return .Design
    }
}


// 外包的状态
enum OutsourcingStatus
{
    case Ongoing        // 进行中
    case Developing     // 正在开发
    case Done           // 成功完成
    case Fail           // 流产
    
    // 对应的字符串
    func desc() -> String
    {
        switch self
        {
            case .Ongoing:
                return "进行中"
            case .Developing:
                return "正在开发"
            case .Done:
                return "成功完成"
            case .Fail:
                return "流产"
        }
    }
    
    // 得到对应的背景色
    func getBackgroundColor() -> UIColor
    {
        switch self
        {
            case .Ongoing:
                return UIColor(red:0.08, green:0.71, blue:0.49, alpha:1.00)
            case .Developing:
                return UIColor(red:0.00, green:0.75, blue:1.00, alpha:1.00)
            case .Done:
                return UIColor(red:0.91, green:0.34, blue:0.00, alpha:1.00)
            case .Fail:
                return UIColor(red:0.00, green:0.00, blue:0.00, alpha:1.00)
        }
    }
}

// 根据字符串得到对应的外包状态
func getStatusByString(str: String) -> OutsourcingStatus
{
    if str == "进行中"
    {
        return .Ongoing
    }
    else if str == "正在开发"
    {
        return .Developing
    }
    else if str == "成功完成"
    {
        return .Done
    }
    else
    {
        return .Fail
    }
}

class OutsourcingModel
{
    // 外包类型
    var type: OutsourcingType
    // 标题
    var title: String
    // 描述
    var desc: String
    // 价格
    var money: String
    // 状态
    var status: OutsourcingStatus
    // 地址
    var url: String
    
    // 初始化方法
    init(type: OutsourcingType, title: String, desc: String, money: String, status: OutsourcingStatus, url: String)
    {
        self.type = type
        self.title = title
        self.desc = desc
        self.money = money
        self.status = status
        self.url = url
    }
}