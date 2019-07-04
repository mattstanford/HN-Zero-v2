//
//  ArticleContainerViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

enum SelectedView {
    case comments
    case web
}

protocol LinkDelegate: class {
    func show(url: URL)
}

class ArticleContainerViewController: UIViewController, LinkDelegate {

    var navigator: AppNavigator = AppNavigator.shared
    var currentArticle: Article?
    private var currentSelectedView: SelectedView = .comments
    var currentVC: UIViewController?

    @IBOutlet weak var containerView: UIView!
    private var swapButton: UIBarButtonItem?

    // MARK: - Setup

    override func viewDidLoad() {
        super.viewDidLoad()
        navigator.articleDetail = self
        set(scheme: HackerNewsRepository.shared.settingsCache.colorScheme)
        setupBarButtons()
    }

    var currentCommentsVC: CommentsViewController?
    var currentWebVC: WebViewController?

    private func setupBarButtons() {

        swapButton = UIBarButtonItem(
            title: "",
            style: .plain,
            target: self,
            action: #selector(swapVieControllers(sender:))
        )
        self.navigationItem.rightBarButtonItem = swapButton
    }

    // MARK: - Public functions

    func showArticle(in selectedView: SelectedView) {
        set(selectedView: selectedView, animated: false)
    }

    @objc func swapVieControllers(sender: UIBarButtonItem) {
        swapViewControllers(animated: true)
    }

    func unsetOtherView(currentView: SelectedView) {
        switch currentView {
        case .comments:
            currentWebVC = nil
        case .web:
            currentCommentsVC = nil
        }
    }

    // MARK: - Internal helper functions
    private func set(selectedView: SelectedView, animated: Bool) {

        let targetVC = viewControllerFor(selectedView: selectedView)

        if let current = currentVC {
            if currentSelectedView == selectedView {
                showArticleInView()
            } else {
                if animated {
                    animateCycle(from: current, to: targetVC)
                } else {
                    cycle(from: current, to: targetVC)
                }
            }
        } else {
            add(viewController: targetVC)
        }

        setupFullScreenButton()
        setupSwapButton(selectedView: selectedView)
        currentSelectedView = selectedView

        //Make sure current view is assigned to the appropriate member variable
        if let commentsVC = targetVC as? CommentsViewController {
            currentCommentsVC = commentsVC
        } else if let webVC = targetVC as? WebViewController {
            currentWebVC = webVC
        }
    }

    private func setupFullScreenButton() {
        if UIDevice.isRunningOnIpad {

            let buttonTitle: String

            if splitViewController?.displayMode == .primaryHidden {
                buttonTitle = "Show Article List"
            } else {
                buttonTitle = "Full Screen"
            }

            let leftBarButton = UIBarButtonItem(
                title: buttonTitle,
                style: .plain,
                target: self,
                action: #selector(switchiPadScreenMode)
            )

            navigationItem.leftBarButtonItem = leftBarButton

        }
    }

    @objc private func switchiPadScreenMode() {
        if splitViewController?.displayMode == .allVisible {
            splitViewController?.preferredDisplayMode = .primaryHidden
        } else {
            splitViewController?.preferredDisplayMode = .allVisible
        }

        setupFullScreenButton()
    }

    private func setupSwapButton(selectedView: SelectedView) {
        guard let article = currentArticle else {
            return
        }

        if article.numComments == nil || article.url == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            swapButton?.title = swapButtonTitle(selectedView: selectedView)
            navigationItem.rightBarButtonItem = swapButton

        }
    }

    private func swapViewControllers(animated: Bool) {
        let viewToSelect: SelectedView = currentSelectedView == .comments ? .web : .comments
        set(selectedView: viewToSelect, animated: true)
    }

    private func viewControllerFor(selectedView: SelectedView) -> UIViewController {
        switch selectedView {
        case .comments:
            if let currentCommentsVC = currentCommentsVC {
                return currentCommentsVC
            } else {
                return  generateNewCommentsVC()
            }
        case .web:
            if let currentWebVC = currentWebVC {
                return currentWebVC
            } else {
                return generateNewWebVC()
            }
        }
    }

    func generateNewCommentsVC() -> CommentsViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as? CommentsViewController else {
            return CommentsViewController()
        }
        viewController.linkDelegate = self

        return viewController
    }

    func generateNewWebVC() -> WebViewController {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: "WebVC") as? WebViewController else {
            return WebViewController()
        }

        return viewController
    }

    private func swapButtonTitle(selectedView: SelectedView) -> String {
        switch selectedView {
        case .comments:
            return "Go To Article"
        case .web:
            return "Go To Comments"
        }
    }

    private func add(viewController: UIViewController) {

        addChild(viewController)
        view.addSubview(viewController.view)

        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        viewController.didMove(toParent: self)
        currentVC = viewController
        showArticleInView()
    }

    private func cycle(from oldVC: UIViewController, to newVC: UIViewController) {

        oldVC.willMove(toParent: nil)
        oldVC.view.removeFromSuperview()
        oldVC.removeFromParent()

        self.addChild(newVC)
        let newRect = CGRect(x: 0, y: 0,
                             width: oldVC.view.bounds.size.width,
                             height: oldVC.view.bounds.height)
        newVC.view.frame = newRect
        self.view.addSubview(newVC.view)
        newVC.didMove(toParent: self)

        self.currentVC = newVC
        self.showArticleInView()
    }

    private func animateCycle(from oldVC: UIViewController, to newVC: UIViewController) {

        oldVC.willMove(toParent: nil)
        self.addChild(newVC)

        transition(from: oldVC,
                   to: newVC,
                   duration: 0.25,
                   options: .transitionCrossDissolve,
                   animations: {

                    let newRect = CGRect(x: 0, y: 0,
                                         width: oldVC.view.bounds.size.width,
                                         height: oldVC.view.bounds.height)
                    newVC.view.frame = newRect

        }, completion: { _ in

            oldVC.removeFromParent()
            newVC.didMove(toParent: self)

            self.currentVC = newVC
            self.showArticleInView()
        })
    }

    private func showArticleInView() {
        guard let articleVC = currentVC as? ArticleViewable else {
            return
        }
        articleVC.show(article: currentArticle)
    }

    // MARK: LinkDelegate protocol
    func show(url: URL) {
        navigator.showLink(url: url)
    }
}

extension ArticleContainerViewController: ColorChangeable {
    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        view.backgroundColor = scheme.contentBackgroundColor
    }

    func switchScheme(to scheme: ColorScheme) {
        set(scheme: scheme)
    }
}
