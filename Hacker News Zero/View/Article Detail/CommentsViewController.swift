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
        
        let start = Date()
        
        viewModel.updateCommentData()
            .subscribe({ (event) in
                let end = Date()
                
                let duration = end.timeIntervalSince(start)
                print("finished getting comment data: " + String(describing: duration) + " " + String(describing: event))
                print("num view models: " + String(self.viewModel.viewModels.count))
                self.tableView.reloadData()
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
        return self.viewModel.viewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TestCell", for: indexPath)
        let cellViewModel = self.viewModel.viewModels[indexPath.row]
        
        if let text = cellViewModel.comment.text {
            cell.textLabel?.text = text
        }
        else {
            cell.textLabel?.text = "<Deleted>"
        }
    
        
        return cell
    }
}
