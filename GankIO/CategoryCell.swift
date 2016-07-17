//
//  CategoryCell.swift
//  GankIO
//
//  Created by Bing on 7/13/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import LTMorphingLabel

class CategoryCell: UITableViewCell
{
    var imgView: UIImageView?
    var title: LTMorphingLabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        imgView = UIImageView(frame: CGRect(x: Common.screenWidth / 2 - 32, y: (Common.screenHeight - 64 - 49) / 6 - 48, width: 64, height: 64))
        self.addSubview(imgView!)
        
        title = LTMorphingLabel(frame: CGRect(x: Common.screenWidth / 2 - 100, y: (Common.screenHeight - 64 - 49) / 6 + 16, width: 200, height: 40))
        title?.textAlignment = .Center
        title?.textColor = UIColor.whiteColor()
        title?.font = UIFont.boldSystemFontOfSize(20)
        title?.morphingEffect = .Sparkle
        title?.morphingDuration = 0.8
        self.addSubview(title!)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}