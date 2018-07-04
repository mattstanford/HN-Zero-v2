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
    @IBOutlet private weak var progressView: UIProgressView!
    
    var viewModel = WebViewModel()
    
    var progressObserver: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.navigationDelegate = self
        setupProgressBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
   
        showNewArticleIfNecessary()
    }
    
    func setupProgressBar() {
        
        self.progressObserver = webView.observe(\.estimatedProgress) { [weak self] (webView, _) in
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)
            
            if webView.estimatedProgress >= 1 {
                
                UIView.animate(withDuration: 0.3, delay: 0.3, options: UIViewAnimationOptions.curveEaseOut, animations: {
                    self?.progressView.alpha = 0
                }, completion: { _ in
                    self?.progressView.setProgress(0, animated: false)
                })
            } else {
                self?.progressView.alpha = 1
            }
        }
        
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
        guard let url = viewModel.currentUrl else {
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
    
    func set(url: URL) {
        viewModel.currentUrl = url
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
