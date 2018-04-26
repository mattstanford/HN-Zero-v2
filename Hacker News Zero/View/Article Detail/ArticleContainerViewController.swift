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

class ArticleContainerViewController: UIViewController {
    
    var navigator: AppNavigator?
    private var currentSelectedView: SelectedView = .comments
    private var currentVC: UIViewController?

    @IBOutlet weak var containerView: UIView!
    private var swapButton: UIBarButtonItem?
    
    //MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
    }
    
    private lazy var commentsVC: CommentsViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
   
        
        return viewController
    }()
    
    private lazy var webVC: WebViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        
        return viewController
    }()
    
    private func setupBarButtons() {

        swapButton = UIBarButtonItem(
            title: "Swap",
            style: .plain,
            target: self,
            action: #selector(swapVieControllers(sender:))
        )
        self.navigationItem.rightBarButtonItem = swapButton;
    }
    
    //MARK: - Public functions
    
    func showArticle(in selectedView: SelectedView) {
       
        guard let article = navigator?.currentArticle else {
            return
        }
        
        if article.numComments == nil || article.url == nil {
            navigationItem.rightBarButtonItem = nil
        } else {
            navigationItem.rightBarButtonItem = swapButton
        }
        
        set(selectedView: selectedView, animated: false)
    }
    
    @objc func swapVieControllers(sender: UIBarButtonItem) {
        
        swapViewControllers(animated: true)
    }
    
    //MARK: - Internal helper functions
    private func set(selectedView: SelectedView, animated: Bool) {
        
        let targetVC = viewControllerFor(selectedView: selectedView)
        
        if let current = currentVC {
            if currentSelectedView == selectedView {
                showArticleInView()
            } else {
                if animated {
                    animateCycle(from: current, to: targetVC)
                } else {
                    animateCycle(from: current, to: targetVC)
                }
            }
        } else {
            add(viewController: targetVC)
        }
        
        currentSelectedView = selectedView
    }
    
    private func swapViewControllers(animated: Bool) {
        
        let viewToSelect: SelectedView = currentSelectedView == .comments ? .web : .comments
        set(selectedView: viewToSelect, animated: true)
    }
    
    private func viewControllerFor(selectedView: SelectedView) -> UIViewController {
        switch selectedView {
        case .comments:
            return commentsVC
        case .web:
            return webVC
        }
    }
    
    private func add(viewController: UIViewController) {
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
        currentVC = viewController
        showArticleInView()
    }
    
    private func cycle(from oldVC: UIViewController, to newVC: UIViewController) {
        oldVC.willMove(toParentViewController: nil)
        self.addChildViewController(newVC)
        oldVC.removeFromParentViewController()
        newVC.didMove(toParentViewController: self)

        self.currentVC = newVC
        self.showArticleInView()
    }
    
    private func animateCycle(from oldVC: UIViewController, to newVC: UIViewController) {
        
        oldVC.willMove(toParentViewController: nil)
        self.addChildViewController(newVC)
        
        transition(from: oldVC,
                   to: newVC,
                   duration: 0.25,
                   options: .transitionCrossDissolve,
                   animations: {
                    
                    let newRect = CGRect(x: 0, y: 0,
                                         width: oldVC.view.bounds.size.width,
                                         height: oldVC.view.bounds.height)
                    newVC.view.frame = newRect
            
        }) { _ in
            
            oldVC.removeFromParentViewController()
            newVC.didMove(toParentViewController: self)
            
            self.currentVC = newVC
            self.showArticleInView()
        }
    }
    
    private func showArticleInView() {
        guard let articleVC = currentVC as? ArticleViewable else {
            return
        }
        articleVC.show(article: navigator?.currentArticle)
    }
    
    
}
