//
//  CommentToolBar.swift
//  GankIO
//
//  Created by Bing on 7/14/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class CommentToolBar: UIView
{
    // 输入框
    var input: UITextField!
    // 评论按钮
    var comment: UIButton!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.flatWhiteColor()
        
        // 输入框
        input = UITextField()
        input.borderStyle = UITextBorderStyle.RoundedRect
        input.font = font14
        input.placeholder = "我来评论几句"
        self.addSubview(input)
        
        // 评论按钮
        comment = UIButton()
        comment.titleLabel?.font = font14
        comment.setTitle("发送", forState: .Normal)
        comment.setTitleColor(UIColor.flatBlackColor(), forState: .Normal)
        self.addSubview(comment)
        
        // 布局
        input.snp_makeConstraints { (make) in
            make.edges.equalTo(self).inset(UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 60))
        }
        comment.snp_makeConstraints { (make) in
            make.top.right.bottom.equalTo(0)
            make.width.equalTo(60)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}