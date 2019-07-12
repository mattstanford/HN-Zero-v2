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

    var navigator = AppNavigator.shared

    private let baseMenuAnimationDuration: Double = 0.3
    private let maxOverlayAlpha: CGFloat = 0.33

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
        navigator.mainViewController = self

        hideMenu()
        setupUI()

        set(scheme: HackerNewsRepository.shared.settingsCache.colorScheme)
    }

    private func setupUI() {

        guard let splitViewController = contentViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? ArticleViewController else {
                fatalError("Error setting up navigator!")
            }

        splitViewController.preferredDisplayMode = .allVisible
        menuViewController?.delegate = masterViewController
    }

}

// MARK: Pan gesture handling
extension MainViewController {
    @IBAction private func overlayTapped() {
        hideMenu()
    }

    @IBAction private func didPanScreenEdge(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)

        if gestureRecognizer.state == .changed {
            if translation.x > 0 {
                let newTranslation = translation.x - menuWidthConstraint.constant
                let newPosition = min(0, newTranslation)
                menuLeadingConstraint.constant = newPosition

                //Partially start showing overlay
                overlayView.isHidden = false
                let overlayPercentShowing = (menuWidthConstraint.constant + newPosition) / menuWidthConstraint.constant
                overlayView.alpha = CGFloat(maxOverlayAlpha) * overlayPercentShowing
            }
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            let alreadyShowingPercent = getAlreadyShowingPercent(translationPoint: translation)
            if alreadyShowingPercent > 0.0 {
                showMenu(alreadyShowingPercent: alreadyShowingPercent)
            }
        }
    }

    @IBAction private func didPanOnOverlay(_ gestureRecognizer: UIPanGestureRecognizer) {
        let translation = gestureRecognizer.translation(in: self.view)

        if gestureRecognizer.state == .changed {
            if translation.x < 0 {
                let newPosition = max((menuWidthConstraint.constant * -1), translation.x)
                menuLeadingConstraint.constant = newPosition
            }
        } else if gestureRecognizer.state == .ended || gestureRecognizer.state == .cancelled {
            let alreadyShowingPercent = getAlreadyShowingPercent(translationPoint: translation)
            if alreadyShowingPercent < 1.0 {
                hideMenu(alreadyShowingPercent: alreadyShowingPercent)
            }
        }
    }

    func getAlreadyShowingPercent(translationPoint: CGPoint) -> Double {
        let alreadyShowingPercent = (menuWidthConstraint.constant + translationPoint.x) / menuWidthConstraint.constant
        return Double(alreadyShowingPercent)
    }

    private func snapToClosestEdge(translationPoint: CGPoint) {
        let dismissThreshold = (menuWidthConstraint.constant / 2) * -1
        let alreadyShowingPercent = (menuWidthConstraint.constant + translationPoint.x) / menuWidthConstraint.constant
        let alreadyShowingDouble = Double(alreadyShowingPercent)
        if translationPoint.x < dismissThreshold {
            hideMenu(alreadyShowingPercent: alreadyShowingDouble)
        } else {
            showMenu(alreadyShowingPercent: alreadyShowingDouble)
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
            self.overlayView.alpha = self.maxOverlayAlpha
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

// MARK: - Colors
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
