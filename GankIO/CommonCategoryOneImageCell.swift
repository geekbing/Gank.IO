//
//  CommonCategoryOneImageCell.swift
//  GankIO
//
//  Created by Bing on 7/22/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

protocol CommonCategoryOneImageCellDelegate: class
{
    func clickImageView(sender: UITapGestureRecognizer)
}

class CommonCategoryOneImageCell: UITableViewCell
{
    // 描述
    var desc: UILabel?
    // 发布人名称
    var who: UILabel?
    // 发布人头像
    var avatar: UIImageView?
    // 发布时间
    var publishedAt: UILabel?
    // 演示图片
    var imgView: YYAnimatedImageView?
    
    weak var delegate: CommonCategoryOneImageCellDelegate!
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
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
        
        // 演示图片
        imgView = YYAnimatedImageView()
        imgView?.layer.masksToBounds = true
        imgView?.contentMode = .ScaleAspectFit
        imgView?.tag = 1
        imgView?.userInteractionEnabled = true
        
        let tapSingle = UITapGestureRecognizer(target: self, action: .tapSingleDid)
        imgView?.addGestureRecognizer(tapSingle)
        
        self.contentView.addSubview(imgView!)
        
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
        imgView?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(Common.screenWidth - 30)
            make.left.equalTo(self.contentView).offset(15)
            make.bottom.equalTo(self.contentView).offset(-15)
            make.height.equalTo(200)
        })
        desc?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(Common.screenWidth - 30)
            make.left.equalTo(avatar!)
            make.top.equalTo(avatar!.snp_bottom).offset(15)
            make.bottom.equalTo((self.imgView?.snp_top)!).offset(-15)
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapSingleDid(sender: UITapGestureRecognizer)
    {
        delegate.clickImageView(sender)
    }
    
    deinit
    {
        print("NewCommentOneImageCell")
    }
}

private extension Selector
{
    static let tapSingleDid = #selector(CommonCategoryOneImageCell.tapSingleDid(_:))
}