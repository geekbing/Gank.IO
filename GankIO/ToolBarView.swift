
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
    func clickShare(btn: UIButton, event: UIEvent)
    func clickComment(btn: UIButton, event: UIEvent)
    func clickZan(btn: UIButton, event: UIEvent)
    func clickCollection(btn: UIButton, event: UIEvent)
}

class ToolBarView: UIView
{
    var delegate: ToolBarViewDelegate!
    
    override func drawRect(rect: CGRect)
    {
        let context = UIGraphicsGetCurrentContext()
        CGContextSetLineWidth(context, 0.5)
        CGContextSetRGBStrokeColor(context, 231 / 255, 231 / 255, 231 / 255, 1)
        for i in 1...3
        {
            CGContextMoveToPoint(context, CGFloat(i) * rect.size.width / 4, rect.size.height * 0.1)
            CGContextAddLineToPoint(context, CGFloat(i) * rect.size.width / 4, rect.size.height * 0.9)
        }
        CGContextMoveToPoint(context, 8, 0)
        CGContextAddLineToPoint(context, rect.size.width - 8, 0)
        CGContextStrokePath(context)
    }
   
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        let imgNames = ["Zan-Fill", "Comment", "Collection-Fill", "Share"]
        for i in 0...3
        {
            let btn = UIButton(frame: CGRect(x: CGFloat(i) * frame.size.width / 4, y: 0, width: frame.size.width / 4, height: frame.size.height))
            btn.setImage(UIImage(named: imgNames[i])?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
            btn.tintColor = UIColor.flatGrayColor()
            btn.tag = i
            btn.addTarget(self, action: .toolBarViewAction, forControlEvents: .TouchUpInside)
            self.addSubview(btn)
        }
    }
    
    // 点击分享点赞等4个按钮
    func toolBarViewAction(btn: UIButton, event: UIEvent)
    {
        switch btn.tag
        {
            case 0:
                delegate.clickZan(btn, event: event)
            case 1:
                delegate.clickComment(btn, event: event)
            case 2:
                delegate.clickCollection(btn, event: event)
            case 3:
                delegate.clickShare(btn, event: event)
            default:
                break
        }
    }
    
    // 设置是否点赞
    func isZanOrNot(isZan: Bool)
    {
        let zanBtn = self.viewWithTag(0) as? UIButton
        if isZan
        {
            zanBtn?.setImage(UIImage(named: "Zan-Fill")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        else
        {
            zanBtn?.setImage(UIImage(named: "Zan")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
    }
    
    // 设置是否收藏
    func isCollectionOrNot(isCollection: Bool)
    {
        let collectionBtn = self.viewWithTag(2) as? UIButton
        if isCollection
        {
            collectionBtn?.setImage(UIImage(named: "Collection-Fill")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
        else
        {
            collectionBtn?.setImage(UIImage(named: "Collection")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Selector
{
    static let toolBarViewAction = #selector(ToolBarView.toolBarViewAction(_:event:))
}