//
//  CommentToolBar.swift
//  GankIO
//
//  Created by Bing on 7/14/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

protocol CommentToolBarDelegate: class
{
    func commentBtnClick(content: String)
}

class CommentToolBar: UIView
{
    // 输入框
    var input: UITextField!
    // 评论按钮
    var comment: UIButton!
    
    weak var delegate: CommentToolBarDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.flatWhiteColor()
        
        // 输入框
        input = UITextField()
        input.borderStyle = UITextBorderStyle.RoundedRect
        input.font = Common.font14
        input.placeholder = "我来评论几句"
        self.addSubview(input)
        
        // 评论按钮
        comment = UIButton()
        comment.titleLabel?.font = Common.font14
        comment.setTitle("发送", forState: .Normal)
        comment.setTitleColor(UIColor.flatBlackColor(), forState: .Normal)
        comment.addTarget(self, action: .commentBtnClick, forControlEvents: .TouchUpInside)
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
    
    // 点击评论按钮
    func commentBtnClick()
    {
        let content = self.input.text
        delegate.commentBtnClick(content!)
    }
    
    // 清空评论框数据
    func clearInput()
    {
        input.text = ""
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension Selector
{
    static let commentBtnClick = #selector(CommentToolBar.commentBtnClick)
}