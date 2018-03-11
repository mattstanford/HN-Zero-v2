//
//  CommentsViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import RxSwift

class CommentsViewController: UIViewController, ArticleViewable {

    var navigator: ArticleNavigator?
    let disposeBag = DisposeBag()
    
    lazy var viewModel: CommentsViewModel = {
        let repository = HackerNewsRepository(client: HackerNewsApiClient(), cache: ApiCache())
        return CommentsViewModel(with: repository)
    }()
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    //MARK: ArticleViewable protocol
    
    func show(article: Article?) {
        viewModel.article = article
        
        loadCommentData()
    }
    
    func gotNewArticle() {
        
        titleLabel.text = navigator?.currentArticle?.title
        infoLabel.text = "Info stuff"
        
        tableView.layoutTableHeaderView()
        loadCommentData()
    }
    
    func loadCommentData() {
        viewModel.updateCommentData()
            .subscribe({ (event) in
                
                print("finished getting comment data: " + String(describing: event))
            })
            .disposed(by: disposeBag)
    }
}

extension CommentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        
    
        
        return cell
    }
}
