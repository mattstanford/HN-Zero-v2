//
//  ArticleContainerViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

class ArticleContainerViewController: UIViewController {
    
    enum SelectedView {
        case comments
        case web
    }
    
    var selectedView: SelectedView = .comments

    @IBOutlet weak var containerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBarButtons()
        
        switch selectedView {
        case .comments:
            add(asChildViewController: commentsVC)
        case .web:
            add(asChildViewController: webVC)
        }
    }
    
    private func setupBarButtons() {

        let swapButton = UIBarButtonItem(
            title: "Swap",
            style: .plain,
            target: self,
            action: #selector(swapVieControllers(sender:))
        )
        self.navigationItem.rightBarButtonItem = swapButton;
    }
    
    @objc func swapVieControllers(sender: UIBarButtonItem) {
        
        selectedView = selectedView == .comments ? .web : .comments
        
        switch selectedView {
        case .comments:
            swapToComments()
        case .web:
            swapToWeb()
        }
        
    }
    
    private func swapToComments() {
        cycle(from: webVC, to: commentsVC)
    }
    
    private func swapToWeb() {
        cycle(from: commentsVC, to: webVC)
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
    
    private func add(asChildViewController viewController: UIViewController) {
        
        addChildViewController(viewController)
        view.addSubview(viewController.view)
        
        viewController.view.frame = view.bounds
        viewController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        viewController.didMove(toParentViewController: self)
    }
    
    private func cycle(from oldVC: UIViewController, to newVC: UIViewController) {
        
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
        }
    }

}
