
//
//  ToolBarView.swift
//  GankIO
//
//  Created by Bing on 7/13/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

protocol ToolBarViewDelegate
{
    func clickShare(btn: UIButton)
    func clickComment(btn: UIButton)
    func clickZan(btn: UIButton)
    func clickCollection(btn: UIButton)
}

class ToolBarView: UIView
{
    var delegate: ToolBarViewDelegate!
    
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBStrokeColor(context, 231 / 255, 231 / 255, 231 / 255, 1)
        for i in 1...2
        {
            CGContextMoveToPoint(context, CGFloat(i) * rect.size.width / 3, rect.size.height * 0.1)
            CGContextAddLineToPoint(context, CGFloat(i) * rect.size.width / 3, rect.size.height * 0.9)
        }
        CGContextMoveToPoint(context, 8, 0)
        CGContextAddLineToPoint(context, rect.size.width - 8, 0)
        CGContextStrokePath(context)
    }
   
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let imgNames = ["Comment", "Collection", "Share"]
        for i in 0...2
        {
            let btn = UIButton(frame: CGRect(x: CGFloat(i) * frame.size.width / 3, y: 0, width: frame.size.width / 3, height: frame.size.height))
            btn.setImage(UIImage(named: imgNames[i])?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            btn.tintColor = UIColor.flatGrayColor()
            btn.tag = i
            btn.addTarget(self, action: .toolBarViewAction, forControlEvents: .TouchUpInside)
            self.addSubview(btn)
        }
    }
    
    // 点击分享点赞等4个按钮
    func toolBarViewAction(btn: UIButton)
    {
        switch btn.tag
        {
            case 0:
                delegate.clickZan(btn)
            case 1:
                delegate.clickComment(btn)
            case 2:
                delegate.clickCollection(btn)
            case 3:
                delegate.clickShare(btn)
            default:
                break
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Selector
{
    static let toolBarViewAction = #selector(ToolBarView.toolBarViewAction(_:))
}