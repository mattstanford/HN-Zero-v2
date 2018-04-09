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
    
    var navigator: ArticleNavigator?
    
    private var menuViewController: OptionsViewController? {
        return childViewControllers.last as? OptionsViewController
    }
    
    private var contentViewController: UISplitViewController? {
        return childViewControllers.first as? UISplitViewController
    }
    
    private var menuIsHidden: Bool {
        return overlayView.isHidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideMenu()
        setupNavigator()
    }
    
    private func setupNavigator() {
        
        guard let splitViewController = contentViewController,
            let leftNavController = splitViewController.viewControllers.first as? UINavigationController,
            let masterViewController = leftNavController.topViewController as? ArticleViewController,
            let rightNavController = splitViewController.viewControllers.last as? UINavigationController,
            let detailViewController = rightNavController.topViewController as? ArticleContainerViewController
            else { fatalError() }
        
        let navigator = ArticleNavigator(with: self,
                                         articleList: masterViewController,
                                         articleDetail: detailViewController)
        
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
        }
        else
        {
            hideMenu()
        }
    }
    
    private func showMenu()
    {
        menuLeadingConstraint.constant = 0
        overlayView.isHidden = false
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0.33
        }, completion: { (complete) in
            
            self.screenEdgePan.isEnabled = false
        })
    }
    
    private func hideMenu() {
  
        menuLeadingConstraint.constant = -menuWidthConstraint.constant
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
            self.overlayView.alpha = 0
        }, completion: { (complete) in
            
            self.screenEdgePan.isEnabled = true
            self.overlayView.isHidden = true
        })
    }
}
