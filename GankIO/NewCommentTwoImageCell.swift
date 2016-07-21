//
//  NewCommentTwoImageCell.swift
//  GankIO
//
//  Created by Bing on 7/19/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

protocol NewCommentTwoImageCellDelegate: class
{
    func leftImgSingleTip(sender: UITapGestureRecognizer)
    func rightImgSingleTip(sender: UITapGestureRecognizer)
}

class NewCommentTwoImageCell: UICollectionViewCell
{
    // 描述
    var desc: UILabel?
    // 发布人名称
    var who: UILabel?
    // 发布人头像
    var avatar: UIImageView?
    // 发布时间
    var publishedAt: UILabel?
    // 左边图片
    var leftImg: YYAnimatedImageView?
    // 右边图片
    var rightImg: YYAnimatedImageView?
    // 底部工具条
    var toolBar: ToolBarView?
    
    weak var delegate: NewCommentTwoImageCellDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        // 发布人头像
        avatar = UIImageView()
        avatar?.layer.masksToBounds = true
        avatar?.layer.cornerRadius = 15
        self.contentView.addSubview(avatar!)
        
        // 发布人名称
        who = UILabel()
        who?.font = Common.font16
        who?.textColor = UIColor.flatGrayColor()
        self.contentView.addSubview(who!)
        
        // 发布时间
        publishedAt = UILabel()
        publishedAt?.font = Common.font10
        publishedAt?.textColor = UIColor.flatGrayColor()
        self.contentView.addSubview(publishedAt!)
        
        // 描述
        desc = UILabel()
        desc?.numberOfLines = 0
        desc?.font = Common.font16
        desc?.textColor = UIColor.flatBlackColor()
        self.contentView.addSubview(desc!)
        
        // 左边点击手势
        let leftTap = UITapGestureRecognizer(target: self, action: .leftImgSingleTip)
        // 右边点击手势
        let rightTap = UITapGestureRecognizer(target: self, action: .rightImgSingleTip)
        
        // 左边的图片
        leftImg = YYAnimatedImageView()
        leftImg?.layer.masksToBounds = true
        leftImg?.contentMode = .ScaleAspectFit
        leftImg?.tag = 1
        leftImg?.userInteractionEnabled = true
        self.contentView.addSubview(leftImg!)
        leftImg?.addGestureRecognizer(leftTap)

        // 右边的图片
        rightImg = YYAnimatedImageView()
        rightImg?.layer.masksToBounds = true
        rightImg?.contentMode = .ScaleAspectFit
        rightImg?.tag = 2
        rightImg?.userInteractionEnabled = true
        self.contentView.addSubview(rightImg!)
        rightImg?.addGestureRecognizer(rightTap)

        // 底部工具条
        toolBar = ToolBarView(frame: CGRect(x: 0, y: frame.height - 40, width: Common.screenWidth, height: 40))
        self.contentView.addSubview(toolBar!)
        
        // 布局
        avatar?.snp_makeConstraints(closure: { (make) in
            make.width.height.equalTo(30)
            make.left.top.equalTo(self.contentView).offset(15)
        })
        who?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.left.equalTo(avatar!.snp_right).offset(15)
            make.top.equalTo(self.contentView).offset(15)
        })
        publishedAt?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(200)
            make.height.equalTo(12)
            make.left.equalTo(who!)
            make.top.equalTo(who!.snp_bottom)
        })
        toolBar?.snp_makeConstraints(closure: { (make) in
            make.height.equalTo(40)
            make.left.right.equalTo(self.contentView)
            make.bottom.equalTo(self.contentView)
        })
        leftImg?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo((Common.screenWidth - 45) / 2)
            make.left.equalTo(self.contentView).offset(15)
            make.bottom.equalTo((toolBar?.snp_top)!).offset(-15)
            make.height.equalTo(200)
        })
        rightImg?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo((Common.screenWidth - 45) / 2)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo((toolBar?.snp_top)!).offset(-15)
            make.height.equalTo(200)
        })
        desc?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(Common.screenWidth - 30)
            make.left.equalTo(avatar!)
            make.top.equalTo(avatar!.snp_bottom)
            make.bottom.equalTo((self.leftImg?.snp_top)!)
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func leftImgSingleTip(sender: UITapGestureRecognizer)
    {
        delegate.leftImgSingleTip(sender)
    }
    
    func rightImgSingleTip(sender: UITapGestureRecognizer)
    {
        delegate.rightImgSingleTip(sender)
    }
    
    deinit
    {
        print("NewCommentTwoImageCell")
    }
}

private extension Selector
{
    static let leftImgSingleTip = #selector(NewCommentTwoImageCell.leftImgSingleTip(_:))
    static let rightImgSingleTip = #selector(NewCommentTwoImageCell.rightImgSingleTip(_:))
}