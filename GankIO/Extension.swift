//
//  Extension.swift
//  GankIO
//
//  Created by Bing on 7/13/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import NVActivityIndicatorView

extension String
{
    // 获得string内容高度
    func stringHeightWith(font: UIFont, width: CGFloat) -> CGFloat
    {
        let size = CGSize(width: width, height: CGFloat.max)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .ByWordWrapping
        let attributes = [NSFontAttributeName: font, NSParagraphStyleAttributeName: paragraphStyle.copy()]
        let text = self as NSString
        let rect = text.boundingRectWithSize(size, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.size.height
    }
    
    // 去掉字符串首尾的空格
    func removeSpace() -> String
    {
        let whitespace = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        return self.stringByTrimmingCharactersInSet(whitespace)
    }
}

extension UIViewController: NVActivityIndicatorViewable
{
    func showLoding(message: String)
    {
        self.startActivityAnimating(CGSize(width: 100, height: 100), message: message, type: .BallScaleMultiple, color: UIColor.flatWhiteColor(), padding: 10)
    }
}