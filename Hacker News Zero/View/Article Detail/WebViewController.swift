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
    
    var navigator: AppNavigator?
    var viewModel = WebViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        showNewArticleIfNecessary()
    }
    
    func showNewArticleIfNecessary() {
        
        if(viewModel.needsReset) {
            let blankUrl = URL(string:"about:blank")
            let blankRequest = URLRequest(url:blankUrl!)
            webView.load(blankRequest)
            //Once this is finished loading, will call showCurrentArticle()

        }
    }
    
    func showCurrentArticle() {
        guard let urlString = viewModel.article?.url,
            let url = URL(string: urlString) else {
                return
        }
        
        print("showing url: " + url.absoluteString)
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }
    
    //MARK: ArticleViewable protocol
    
    func show(article: Article?)
    {
        viewModel.article = article
        showNewArticleIfNecessary()
    }
    
}

extension WebViewController: WKNavigationDelegate {
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        if viewModel.needsReset {
            viewModel.needsReset = false
            showCurrentArticle()
        }
    }
}
