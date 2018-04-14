//
//  ArticleContainerViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class ArticleContainerViewController: UIViewController {
    
    var navigator: AppNavigator?
    var currentSelectedView: SelectedView = .comments
    var currentVC: UIViewController?

    @IBOutlet weak var containerView: UIView!
    
    //MARK: - Setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        
        switch currentSelectedView {
        case .comments:
            add(viewController: commentsVC)
        case .web:
            add(viewController: webVC)
        }
    }
    
    private lazy var commentsVC: CommentsViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "CommentsVC") as! CommentsViewController
        viewController.navigator = self.navigator
        
        return viewController
    }()
    
    private lazy var webVC: WebViewController = {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        var viewController = storyboard.instantiateViewController(withIdentifier: "WebVC") as! WebViewController
        viewController.navigator = self.navigator
        
        return viewController
    }()
    
    private func setupBarButtons() {

        let swapButton = UIBarButtonItem(
            title: "Swap",
            style: .plain,
            target: self,
            action: #selector(swapVieControllers(sender:))
        )
        self.navigationItem.rightBarButtonItem = swapButton;
    }
    
    //MARK: - Public functions
    
    func showArticle(in selectedView: SelectedView) {
       
        if selectedView != self.currentSelectedView {
            swapViewControllers(animated: false)
        } else {
            showArticleInView()
        }
    }
    
    @objc func swapVieControllers(sender: UIBarButtonItem) {
        
        swapViewControllers(animated: true)
    }
    
    //MARK: - Internal helper functions
    private func swapViewControllers(animated: Bool) {
        currentSelectedView = currentSelectedView == .comments ? .web : .comments
        
        switch currentSelectedView {
        case .comments:
            animateCycle(from: webVC, to: commentsVC)
        case .web:
            animateCycle(from: commentsVC, to: webVC)
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
