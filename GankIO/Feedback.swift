//
//  Feedback.swift
//  GankIO
//
//  Created by Bing on 7/24/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit

class Feedback: RCConversationViewController
{
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "随意吐槽"
        view.backgroundColor = UIColor.whiteColor()

        self.targetId = "578cde816be3ff006ceaffc0"
        self.setMessageAvatarStyle(.USER_AVATAR_CYCLE)
        self.conversationType = .ConversationType_PRIVATE
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

