//
//  Common.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

// 屏幕的长和宽
let screenWidth = UIScreen.mainScreen().bounds.size.width
let screenHeight = UIScreen.mainScreen().bounds.size.height

// 应用主颜色
let mainColor = UIColor(red: 97.0 / 255.0, green: 197.0 / 255.0, blue: 170.0 / 255.0, alpha: 1.0)
let tabbarColor = UIColor(red: 146.0 / 255.0, green: 146.0 / 255.0, blue: 146.0 / 255.0, alpha: 1.0)

// 字体
let font20 = UIFont.systemFontOfSize(20, weight: UIFontWeightThin)
let font19 = UIFont.systemFontOfSize(19, weight: UIFontWeightThin)
let font18 = UIFont.systemFontOfSize(18, weight: UIFontWeightThin)
let font17 = UIFont.systemFontOfSize(17, weight: UIFontWeightThin)
let font16 = UIFont.systemFontOfSize(16, weight: UIFontWeightThin)
let font15 = UIFont.systemFontOfSize(15, weight: UIFontWeightThin)
let font14 = UIFont.systemFontOfSize(14, weight: UIFontWeightThin)
let font13 = UIFont.systemFontOfSize(13, weight: UIFontWeightThin)
let font12 = UIFont.systemFontOfSize(12, weight: UIFontWeightThin)
let font11 = UIFont.systemFontOfSize(11, weight: UIFontWeightThin)
let font10 = UIFont.systemFontOfSize(10, weight: UIFontWeightThin)

// 判断是否是新版本
func isNewVersion() -> Bool
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