//
//  OutsourcingCell.swift
//  GankIO
//
//  Created by Bing on 7/23/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SnapKit

class OutsourcingCell: UICollectionViewCell
{
    // 顶部大图
    var bigImg: UIImageView?
    // 标题
    var title: UILabel?
    // 小类型图标
    var typeImage: UIImageView?
    // 类型
    var type: UILabel?
    // 金额
    var money: UILabel?
    // 描述
    var desc: UILabel?
    // 状态
    var status: UILabel?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 6
        
        // 顶部大图
        bigImg = UIImageView()
        bigImg?.layer.masksToBounds = true
        bigImg?.contentMode = .ScaleAspectFill
        bigImg?.clipsToBounds = true
        self.contentView.addSubview(bigImg!)
        
        // 标题
        title = UILabel()
        title?.layer.borderWidth = 0
        title?.layer.borderColor = UIColor.flatRedColor().CGColor
        title?.numberOfLines = 0
        title?.font = Common.font16
        title?.textColor = UIColor.flatBlackColor()
        self.contentView.addSubview(title!)
        
        // 小类型图标
        typeImage = UIImageView()
        // typeImage?.layer.masksToBounds = true
        // typeImage?.layer.cornerRadius = 10
        self.contentView.addSubview(typeImage!)
        
        // 类型
        type = UILabel()
        type?.layer.borderWidth = 0
        type?.layer.borderColor = UIColor.flatRedColor().CGColor
        type?.font = Common.font12
        type?.textColor = UIColor.flatGrayColor()
        self.contentView.addSubview(type!)
        
        // 金额
        money = UILabel()
        money?.textAlignment = .Right
        money?.layer.borderWidth = 0
        money?.layer.borderColor = UIColor.flatRedColor().CGColor
        money?.font = Common.font27
        money?.textColor = UIColor.flatGrayColor()
        self.contentView.addSubview(money!)
        
        // 描述
        desc = UILabel()
        desc?.layer.borderWidth = 0
        desc?.layer.borderColor = UIColor.flatGreenColor().CGColor
        desc?.numberOfLines = 0
        desc?.font = Common.font14
        desc?.textColor = UIColor.blackColor()
        self.contentView.addSubview(desc!)
        
        // 状态
        status = UILabel()
        status?.textAlignment = .Center
        status?.layer.masksToBounds = true
        status?.layer.cornerRadius = 4
        status?.font = Common.font12
        status?.textColor = UIColor.whiteColor()
        self.contentView.addSubview(status!)
                
        // 顶部大图
        bigImg?.snp_makeConstraints(closure: { (make) in
            make.left.top.right.equalTo(self.contentView)
            make.height.equalTo(140)
        })
        // 状态
        status?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(60)
            make.height.equalTo(24)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo(self.contentView).offset(-15)
        })
        // 描述
        desc?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.bottom.equalTo((self.status?.snp_top)!).offset(-10)
            make.top.equalTo((self.typeImage?.snp_bottom)!).offset(10)
        })
        // 类型图标
        typeImage?.snp_makeConstraints(closure: { (make) in
            make.width.height.equalTo(20)
            make.left.equalTo(15)
            make.bottom.equalTo(self.desc!.snp_top).offset(-10)
        })
        // 类型
        type?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(60)
            make.height.equalTo(20)
            make.left.equalTo((typeImage?.snp_right)!).offset(10)
            make.top.equalTo((typeImage?.snp_top)!)
        })
        // 金额
        money?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo((type?.snp_right)!).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.height.equalTo(40)
            make.bottom.equalTo(type!)
        })
        // 标题
        title?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(15)
            make.right.equalTo(-15)
            make.top.equalTo((bigImg?.snp_bottom)!).offset(10)
            make.bottom.equalTo((money?.snp_top)!).offset(-10)
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}