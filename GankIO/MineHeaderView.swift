//
//  MineHeaderView.swift
//  GankIO
//
//  Created by Bing on 7/14/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

protocol MineHeaderViewDelegate
{
    // 点击设置按钮
    func clickSettingBtn()
    // 点击头像
    func clickAvatar()
}

class MineHeaderView: UIView
{
    // 头像
    var avatar: UIImageView!
    // 用户名
    var username: UILabel!
    // 设置按钮
    var setting: UIButton!
    
    var delegate: MineHeaderViewDelegate!
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        // 背景图
        let background = UIImageView()
        background.image = UIImage(named: "background")
        self.addSubview(background)
        
        // 头像
        avatar = UIImageView()
        avatar.image = UIImage(named: "DefaultAvatar")
        avatar.layer.masksToBounds = true
        avatar.layer.cornerRadius = 36
        self.addSubview(avatar)
        
        // 用户名
        username = UILabel()
        username.font = Common.font16
        username.text = "每日黑大熊"
        username.textAlignment = .Center
        username.textColor = UIColor.flatWhiteColor()
        self.addSubview(username)
        
        // 设置按钮
        setting = UIButton()
        setting.setImage(UIImage(named: "Setting")?.imageWithRenderingMode(.AlwaysTemplate), forState: .Normal)
        setting.tintColor = UIColor.flatWhiteColor()
        setting.addTarget(self, action: .clickSettingBtn, forControlEvents: .TouchUpInside)
        self.addSubview(setting)
        
        // 布局
        background.snp_makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        avatar.snp_makeConstraints { (make) in
            make.width.height.equalTo(72)
            make.center.equalTo(self.snp_center)
        }
        username.snp_makeConstraints { (make) in
            make.width.equalTo(Common.screenWidth)
            make.height.equalTo(20)
            make.top.equalTo(avatar.snp_bottom).offset(20)
            make.centerX.equalTo(self.snp_centerX)
        }
        setting.snp_makeConstraints { (make) in
            make.width.height.equalTo(50)
            make.top.equalTo(40)
            make.right.equalTo(-5)
        }
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // 点击设置按钮
    func clickSettingBtn()
    {
        delegate.clickSettingBtn()
    }
}

private extension Selector
{
    static let clickSettingBtn = #selector(MineHeaderView.clickSettingBtn)
}