//
//  Common.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

struct Common
{
    // 分类
    static let categoryArr = ["福利", "iOS", "Android", "前端", "App", "拓展资源", "休息视频", "瞎推荐"]
    static let classTypeArr: [ClassType] = [.Welfare, .iOS, .Android, .Web, .App, .ExpandResource, .Video, .Random]

    // 屏幕的长和宽
    static let screenWidth = UIScreen.mainScreen().bounds.size.width
    static let screenHeight = UIScreen.mainScreen().bounds.size.height
    
    // 应用主颜色
    static let mainColor = UIColor(red: 101.0 / 255.0, green: 196.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
    static let tabbarColor = UIColor(red: 146.0 / 255.0, green: 146.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)
    // 点赞状态颜色,桃红色
    static let zanColor = UIColor(hexString: "FF6E7C")
    
    // 分类页面的面板颜色
    static let cateColor1 = UIColor(hexString: "673ADD", withAlpha: 0.85)!
    static let cateColor2 = UIColor(hexString: "E12562", withAlpha: 0.85)!
    static let cateColor3 = UIColor(hexString: "ECA32A", withAlpha: 0.85)!
    static let cateColor4 = UIColor(hexString: "59A7A1", withAlpha: 0.85)!
    static let cateColor5 = UIColor(hexString: "FC5732", withAlpha: 0.85)!
    static let cateColor6 = UIColor(hexString: "67D5A3", withAlpha: 0.85)!
    static let cateColor7 = UIColor(hexString: "3ECC14", withAlpha: 0.85)!
    static let cateColor8 = UIColor(hexString: "673ADD", withAlpha: 0.85)!
    
    // 字体
    static let font26 = UIFont.systemFontOfSize(26, weight: UIFontWeightThin)
    static let font27 = UIFont.italicSystemFontOfSize(27)
    static let font20 = UIFont.systemFontOfSize(20, weight: UIFontWeightThin)
    static let font19 = UIFont.systemFontOfSize(19, weight: UIFontWeightThin)
    static let font18 = UIFont.systemFontOfSize(18, weight: UIFontWeightThin)
    static let font17 = UIFont.systemFontOfSize(17, weight: UIFontWeightThin)
    static let font16 = UIFont.systemFontOfSize(16, weight: UIFontWeightThin)
    static let font15 = UIFont.systemFontOfSize(15, weight: UIFontWeightThin)
    static let font14 = UIFont.systemFontOfSize(14, weight: UIFontWeightThin)
    static let font13 = UIFont.systemFontOfSize(13, weight: UIFontWeightThin)
    static let font12 = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
    static let font11 = UIFont.systemFontOfSize(11, weight: UIFontWeightThin)
    static let font10 = UIFont.systemFontOfSize(10, weight: UIFontWeightThin)
    
    // 判断是否是新版本
    static func isNewVersion() -> Bool
    {
        // 获取当前的版本号
        let versionString = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
        let currentVersion = Double(versionString)!
        print("versionString: \(versionString)")
        
        // 获取到之前的版本号
        let sandboxVersion = NSUserDefaults.standardUserDefaults().doubleForKey("sandboxVersionKey")
        print("sandboxVersion: \(sandboxVersion)")
        
        // 保存当前版本号
        NSUserDefaults.standardUserDefaults().setDouble(currentVersion, forKey: "sandboxVersionKey")
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // 对比
        return currentVersion > sandboxVersion
    }
    
    // 验证邮箱合法性
    static func isValidateEmail(email: String) -> Bool
    {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluateWithObject(email)
    }
    
    // leanCloud 错误码得到错误消息
    static func getErrorMessageByCode(code: Int) -> String
    {
        var errorMessage = ""
        switch code
        {
        case 125:
            errorMessage = "电子邮箱地址无效。"
        case 139:
            errorMessage = "角色名称非法，角色名称只能以英文字母、数字或下划线组成。"
        case 202:
            errorMessage = "用户名已经被占用。"
        case 203:
            errorMessage = "电子邮箱地址已经被占用。"
        case 204:
            errorMessage = "没有提供电子邮箱地址。"
        case 205:
            errorMessage = "找不到电子邮箱地址对应的用户。"
        case 210:
            errorMessage = "用户名和密码不匹配。"
        case 211:
            errorMessage = "找不到用户。"
        case 216:
            errorMessage = "未验证的邮箱地址。"
        case 217:
            errorMessage = "无效的用户名，不允许空白用户名。"
        case 218:
            errorMessage = "无效的密码，不允许空白密码。"
        default:
            errorMessage = "操作失败。"
        }
        return errorMessage
    }
    
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
    
    // 格式化日期字符串
    static func getStringWithDate(date: NSDate) -> String
    {
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return formatter.stringFromDate(date)
    }
}