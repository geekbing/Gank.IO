//
//  Feedback.swift
//  GankIO
//
//  Created by Bing on 7/24/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Feedback: UIViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "随意吐槽"
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

