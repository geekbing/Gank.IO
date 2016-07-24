//
//  AdjustCell.swift
//  GankIO
//
//  Created by Bing on 7/24/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SnapKit

class AdjustCell: UITableViewCell
{
    // 左边的图标
    var icon: UIImageView?
    // 中间的标题
    var title: UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        // 左边的图标
        icon = UIImageView()
        self.contentView.addSubview(icon!)
        
        // 中间的标题
        title = UILabel()
        title?.textColor = UIColor.flatBlackColor()
        title?.font = Common.font16
        self.contentView.addSubview(title!)

        // 布局
        icon?.snp_makeConstraints(closure: { (make) in
            make.width.height.equalTo(20)
            make.left.top.equalTo(11)
        })
        title?.snp_makeConstraints(closure: { (make) in
            make.width.equalTo(150)
            make.height.equalTo(44)
            make.top.equalTo(0)
            make.left.equalTo((icon?.snp_right)!).offset(15)
        })
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}