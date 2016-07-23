//
//  ArticleDetail.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SVProgressHUD

class ArticleDetail: CYWebViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Github"
        self.view.backgroundColor = UIColor.whiteColor()
        self.loadingBarTintColor = UIColor.flatRedColor()
    }

    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func viewDidAppear(animated: Bool)
    {
        super.viewDidAppear(animated)
        self.title = "Github"
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
