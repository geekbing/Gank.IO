//
//  CommentUpViewTwoImage.swift
//  GankIO
//
//  Created by Bing on 7/20/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class CommentUpViewTwoImage: UIView
{
    // 描述
    var desc: UILabel?
    // 发布人名称
    var who: UILabel?
    // 发布人头像
    var avatar: UIImageView?
    // 发布时间
    var publishedAt: UILabel?
    // 左边的图片
    var leftImg: YYAnimatedImageView?
    // 右边的图片
    var rightImg: YYAnimatedImageView?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        
        // 发布人头像
        avatar = UIImageView()
        avatar?.layer.masksToBounds = true
        avatar?.layer.cornerRadius = 15
        self.addSubview(avatar!)
        
        // 发布人名称
        who = UILabel()
        who?.font = Common.font16
        who?.textColor = UIColor.flatGrayColor()
        self.addSubview(who!)
        
        // 发布时间
        publishedAt = UILabel()
        publishedAt?.font = Common.font10
        publishedAt?.textColor = UIColor.flatGrayColor()
        self.addSubview(publishedAt!)
        
        // 描述
        desc = UILabel()
        desc?.numberOfLines = 0
        desc?.font = Common.font16
        desc?.textColor = UIColor.flatBlackColor()
        self.addSubview(desc!)
        
        // 左边的图片
        leftImg = YYAnimatedImageView()
        leftImg?.layer.masksToBounds = true
        leftImg?.contentMode = .ScaleAspectFit
        self.addSubview(leftImg!)
        
        // 右边的图片
        rightImg = YYAnimatedImageView()
        rightImg?.layer.masksToBounds = true
        rightImg?.contentMode = .ScaleAspectFit
        self.addSubview(rightImg!)

        // 布局
        avatar?.snp_makeConstraints(closure: { (make) in
            make.width.height.equalTo(30)
            make.left.top.equalTo(self).offset(15)
        })
        who?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(200)
            make.height.equalTo(20)
            make.left.equalTo(avatar!.snp_right).offset(15)
            make.top.equalTo(self).offset(15)
        })
        publishedAt?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(200)
            make.height.equalTo(12)
            make.left.equalTo(who!)
            make.top.equalTo(who!.snp_bottom)
        })
        desc?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(Common.screenWidth - 30)
            make.left.equalTo(avatar!)
            make.top.equalTo(avatar!.snp_bottom).offset(15)
            make.bottom.equalTo(self.snp_bottom)
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
