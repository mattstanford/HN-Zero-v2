//
//  MainNavigationViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 4/5/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak private var menuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak private var menuLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak private var overlayView: UIView!
    @IBOutlet weak private var screenEdgePan: UIGestureRecognizer!
    @IBOutlet weak private var iPhoneXHidingView: UIView!

    var navigator: AppNavigator?

    private var menuViewController: OptionsViewController? {
        return children.last as? OptionsViewController
    }

    private var contentViewController: UISplitViewController? {
        return children.first as? UISplitViewController
    }

    private var menuIsHidden: Bool {
        return overlayView.isHidden
    }

    var isCollapsed: Bool {
        return contentViewController?.isCollapsed ?? true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        hideMenu()
        setupNavigator()

        set(scheme: HackerNewsRepository.shared.settingsCache.colorScheme)
    }

    private func setupNavigator() {

        guard let splitViewController = contentViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? ArticleViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = rightNavController.topViewController as? ArticleContainerViewController
            else { fatalError("Error setting up navigator!") }

        splitViewController.preferredDisplayMode = .allVisible

        let navigator = AppNavigator(with: self,
                                     articleList: masterViewController,
                                     articleDetail: detailViewController)

        menuViewController?.delegate = masterViewController
        menuViewController?.navigator = navigator

        masterViewController.navigator = navigator
        detailViewController.navigator = navigator

    }

    @IBAction private func overlayTapped() {
        hideMenu()
    }

    @IBAction private func swipedFromLeft() {
        showMenu()
    }

    @IBAction private func swipedFromRight() {
        hideMenu()
    }

    func toggleMenu() {
        if menuIsHidden {
            showMenu()
        } else {
            hideMenu()
        }
    }

    private func showMenu() {
        menuLeadingConstraint.constant = 0
        overlayView.isHidden = false

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0.33
        }, completion: { _ in

            self.screenEdgePan.isEnabled = false
        })
    }

    private func hideMenu() {

        menuLeadingConstraint.constant = -menuWidthConstraint.constant

        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0
        }, completion: { _ in

            self.screenEdgePan.isEnabled = true
            self.overlayView.isHidden = true
        })
    }
}

extension MainViewController: ColorChangeable {
    func switchScheme(to scheme: ColorScheme) {
        set(scheme: scheme)
    }

    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        self.view.backgroundColor = scheme.barColor
        self.iPhoneXHidingView.backgroundColor = scheme.barColor
    }
}
