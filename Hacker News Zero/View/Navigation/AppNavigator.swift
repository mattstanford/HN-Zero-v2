//
//  ArticleNavigator.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/26/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class AppNavigator {

    private var mainViewController: MainViewController
    private var articleList: ArticleViewController!

    var currentArticle: Article?

    init(with mainView: MainViewController,
         articleList: ArticleViewController) {

        self.mainViewController = mainView
        self.articleList = articleList
    }

    lazy var articleDetailNavVC: UINavigationController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let navVC = storyboard.instantiateViewController(withIdentifier: "DetailNavVC") as? UINavigationController else {
            return nil
        }

        return navVC
    }()

    lazy var articleDetail: ArticleContainerViewController? = {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "ArticleContainerViewController") as? ArticleContainerViewController else {
            return nil
        }
        viewController.navigator = self

        return viewController
    }()

    func showLink(url: URL) {
        guard let navController = articleDetail?.navigationController else {
            return
        }

        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let webVC = storyboard.instantiateViewController(withIdentifier: "WebVC") as? WebViewController else {
            return
        }

        webVC.set(url: url)
        navController.pushViewController(webVC, animated: true)
    }

    func switchColorScheme(to scheme: ColorScheme) {
        HackerNewsRepository.shared.settingsCache.colorScheme = scheme

        mainViewController.switchScheme(to: scheme)
        articleList.switchScheme(to: scheme)

        if let loaded = articleDetail?.isViewLoaded, loaded {
            articleDetail?.switchScheme(to: scheme)
        }

        if let commentsVC = articleDetail?.currentCommentsVC,
            commentsVC.isViewLoaded {
            commentsVC.switchScheme(to: scheme)
        }

        if let webVC = articleDetail?.currentWebVC,
            webVC.isViewLoaded {
            webVC.switchScheme(to: scheme)
        }

        //If we're on iPad, we need to switch the color of the separate nav bar
        if let navController = articleDetail?.navigationController {
            navController.navigationItem.backBarButtonItem?.tintColor = scheme.barTextColor
            navController.navigationItem.rightBarButtonItem?.tintColor = scheme.barTextColor
            navController.navigationBar.tintColor = scheme.barTextColor
        }
    }

    func toggleMenu() {
        mainViewController.toggleMenu()
    }
}
