//
//  SearchCell.swift
//  GankIO
//
//  Created by Bing on 7/22/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell
{
    // 标题
    var title: UILabel?
    // 名字
    var name: UILabel?
    // 时间
    var time: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.whiteColor()
        
        // 标题
        title = UILabel()
        title?.numberOfLines = 0
        title?.font = Common.font16
        title?.textColor = UIColor.flatBlackColor()
        self.contentView.addSubview(title!)
        
        // 名字
        name = UILabel()
        name?.font = Common.font10
        name?.textColor = UIColor.flatGrayColor()
        self.contentView.addSubview(name!)
        
        // 时间
        time = UILabel()
        time?.textAlignment = .Right
        time?.font = Common.font10
        time?.textColor = UIColor.flatGrayColor()
        self.contentView.addSubview(time!)
        
        // 布局
        name?.snp_makeConstraints(closure: { (make) in
            make.left.equalTo(15)
            make.width.equalTo(150)
            make.height.equalTo(20)
            make.bottom.equalTo(self.contentView)
        })
        time?.snp_makeConstraints(closure: { (make) in
            make.right.equalTo(self.contentView).offset(-15)
            make.width.equalTo(150)
            make.height.equalTo(20)
            make.bottom.equalTo(self.contentView)
        })
        title?.snp_makeConstraints(closure: { (make) in
            make.top.equalTo(self.contentView).offset(10)
            make.left.equalTo(self.contentView).offset(15)
            make.right.equalTo(self.contentView).offset(-15)
            make.bottom.equalTo((self.name?.snp_top)!).offset(-10)
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
