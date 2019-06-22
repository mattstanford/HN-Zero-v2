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

    private let baseMenuAnimationDuration: Double = 0.3

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

}

// MARK: Pan gesture handling
extension MainViewController {
    @IBAction private func overlayTapped() {
        hideMenu()
    }

    @IBAction private func didPanScreenEdge() {
        showMenu()
    }

    @IBAction private func didPanOnOverlay(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)

        if gestureRecognizer.state == .changed {
            if translation.x < 0 {
                let newTranslation = translation.x
                let newPosition = max((menuWidthConstraint.constant * -1), newTranslation)
                menuLeadingConstraint.constant = newPosition
            }
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            let dismissThreshold = (menuWidthConstraint.constant / 2) * -1
            let alreadyShowingPercent = (menuWidthConstraint.constant + translation.x) / menuWidthConstraint.constant
            let alreadyShowingDouble = Double(alreadyShowingPercent)
            if translation.x < dismissThreshold {
                hideMenu(alreadyShowingPercent: alreadyShowingDouble)
            } else {
                showMenu(alreadyShowingPercent: alreadyShowingDouble)
            }
        }
    }

    func toggleMenu() {
        if menuIsHidden {
            showMenu()
        } else {
            hideMenu()
        }
    }

    private func showMenu(alreadyShowingPercent: Double = 0) {
        menuLeadingConstraint.constant = 0
        overlayView.isHidden = false

        let adjustedDuration = baseMenuAnimationDuration * (1 - alreadyShowingPercent)

        UIView.animate(withDuration: adjustedDuration, animations: {
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0.33
        }, completion: { _ in

            self.screenEdgePan.isEnabled = false
        })
    }

    private func hideMenu(alreadyShowingPercent: Double = 1.0) {

        let adjustedDuration = baseMenuAnimationDuration * alreadyShowingPercent
        menuLeadingConstraint.constant = -menuWidthConstraint.constant

        UIView.animate(withDuration: adjustedDuration, animations: {
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0
        }, completion: { _ in

            self.screenEdgePan.isEnabled = true
            self.overlayView.isHidden = true
        })
    }
}

//MARK: - Colors
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
