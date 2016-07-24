//
//  Collection.swift
//  GankIO
//
//  Created by Bing on 7/24/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Collection: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "我的收藏"
        view.backgroundColor = UIColor.whiteColor()
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
