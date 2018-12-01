//
//  WebViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController, ArticleViewable, Shareable {
    private var webView: WKWebView?
    @IBOutlet private weak var progressView: UIProgressView!

    @IBOutlet internal weak var bottomBar: UIToolbar!
    @IBOutlet internal weak var bottomBarBottomConstraint: NSLayoutConstraint!

    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var forwardButton: UIBarButtonItem!

    var lastScrollOffset: CGFloat = 0

    var viewModel = WebViewModel()

    var progressObserver: NSKeyValueObservation?
    var navBackObserver: NSKeyValueObservation?
    var navForwardObserver: NSKeyValueObservation?
    var urlObserver: NSKeyValueObservation?

    override func viewDidLoad() {
        super.viewDidLoad()
        set(scheme: HackerNewsRepository.shared.settingsCache.colorScheme)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNewArticleIfNecessary()
    }

    @IBAction private func shareButtonTapped() {
        if let article = viewModel.article {
            share(article: article)
        }
    }

    @IBAction private func backButtonTapped() {
        if let webView = webView, webView.canGoBack {
            webView.goBack()
        }
    }

    @IBAction private func forwardButtonTapped() {
        if let webView = webView, webView.canGoForward {
            webView.goForward()
        }
    }

    @IBAction private func showInSafari() {
        if let urlString = viewModel.article?.url,
            let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }

    }
    func setupProgressBar() {

        guard let webView = webView else {
            return
        }

        self.progressObserver = webView.observe(\.estimatedProgress) { [weak self] webView, _ in
            self?.progressView.setProgress(Float(webView.estimatedProgress), animated: true)

            if webView.estimatedProgress >= 1 {

                UIView.animate(withDuration: 0.3, delay: 0.3, options: UIView.AnimationOptions.curveEaseOut, animations: {
                    self?.progressView.alpha = 0
                }, completion: { _ in
                    self?.progressView.setProgress(0, animated: false)
                })
            } else {
                self?.progressView.alpha = 1
            }
        }
    }

    func setupNavigationButtons() {
        guard let webView = webView else {
            return
        }
        //Initially these should be disabled when first loading the web view
        self.backButton.isEnabled = false
        self.forwardButton.isEnabled = false

        //Trying in vain to detect when WKWebView changes up its backForward list for history
        let changeClosure: (WKWebView) -> Void = { [weak self] webView in
            self?.backButton.isEnabled = webView.canGoBack
            self?.forwardButton.isEnabled = webView.canGoForward
        }

        self.navBackObserver = webView.observe(\.canGoBack) {webView, _  in
            changeClosure(webView)
        }

        self.navForwardObserver = webView.observe(\.canGoForward) {webView, _  in
            changeClosure(webView)
        }

        self.urlObserver = webView.observe(\.url) {webView, _  in
            changeClosure(webView)
        }
    }

    func showNewArticleIfNecessary() {

        if(viewModel.needsReset) {
            viewModel.needsReset = false
            reloadWebViewWithCurrentArticle()
        }
    }

    func reloadWebViewWithCurrentArticle() {
        if webView != nil {
            webView?.removeFromSuperview()
        }

        webView = WKWebView()

        webView?.frame = view.bounds
        webView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        if let webView = webView {
            view.addSubview(webView)
            view.bringSubviewToFront(progressView)
            view.bringSubviewToFront(bottomBar)
            webView.scrollView.delegate = self
            setupProgressBar()
            setupNavigationButtons()

            showCurrentArticle()
        }
    }

    func showCurrentArticle() {
        guard let url = viewModel.currentUrl,
            let webView = webView else {
                return
        }

        print("showing url: " + url.absoluteString)
        let urlRequest = URLRequest(url: url)
        webView.load(urlRequest)
    }

    // MARK: - ArticleViewable protocol

    func show(article: Article?) {
        viewModel.article = article
        showNewArticleIfNecessary()
    }

    func set(url: URL) {
        viewModel.currentUrl = url
    }
}

// MARK: - Color changeable
extension WebViewController: ColorChangeable {
    func switchScheme(to scheme: ColorScheme) {
        set(scheme: scheme)
    }

    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        bottomBar.barTintColor = scheme.barColor
        bottomBar.tintColor = scheme.barTextColor
        progressView.tintColor = scheme.accentColor
    }
}

// MARK: - ScrollView Delegate
extension WebViewController: UIScrollViewDelegate, BottomBarHideable {

    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y
        let maxheight = abs(scrollView.contentSize.height - scrollView.bounds.height) + scrollView.contentInset.bottom

        let offsetDiff = (lastScrollOffset - offset)
        if offset > maxheight {
            //Always hide when at the bottom
            animateBar(show: false)
        } else if offset <= 0.0 {
            //Always show when reaching the top
            animateBar(show: true)
        } else if offset > lastScrollOffset {
            //Scrolling down, should always trigger a hide
            animateBar(show: false)
        } else if offsetDiff > 10 {
            //Scrolling up, but diff needs to be enough to trigger
            animateBar(show: true)
        }

        lastScrollOffset = offset
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
}
