//
//  ArticleDetail.swift
//  GankIO
//
//  Created by Bing on 7/12/16.
//  Copyright © 2016 Bing. All rights reserved.
//

import UIKit
import SVProgressHUD

class ArticleDetail: UIViewController
{
    var url: String
    var webView: UIWebView!
    
    init(url: String)
    {
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = true
        self.navigationController?.navigationBar.hidden = false
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.title = "Github"
        
        SVProgressHUD.show()
        webView = UIWebView(frame: self.view.bounds)
        let nsurlRequest = NSURLRequest(URL: NSURL(string: url)!)
        webView.loadRequest(nsurlRequest)
        self.view.addSubview(webView)
        SVProgressHUD.dismiss()
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
}
