//
//  WebViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, ArticleViewable {
    
    @IBOutlet private weak var webView: WKWebView!
    
    var navigator: ArticleNavigator?
    var currentShowingArticle: Article?

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        showCurrentArticle()
    }
    
    //MARK: ArticleViewable protocol
    func gotNewArticle() {
        let blankUrl = URL(string:"about:blank")
        let blankRequest = URLRequest(url:blankUrl!)
        webView.load(blankRequest)
        
        guard let urlString = navigator?.currentArticle?.url,
            let url = URL(string: urlString) else {
            return
        }
        
        
        
        print("showing url: " + url.absoluteString)
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    

   
}
