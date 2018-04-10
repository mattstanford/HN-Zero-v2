//
//  CommentsViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import RxSwift
import SafariServices

let CommentCellIdentifier = "ComentCellIdentifier"

class CommentsViewController: UIViewController, ArticleViewable {

    var navigator: AppNavigator?
    let disposeBag = DisposeBag()
    
    lazy var viewModel: CommentsViewModel = {
        let repository = HackerNewsRepository(client: HackerNewsApiClient(), cache: ApiCache())
        return CommentsViewModel(with: repository)
    }()
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var postTextLabel: UILabel!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

    }
    
    //MARK: ArticleViewable protocol
    
    func show(article: Article?) {
        
        if article?.id != viewModel.article?.id {
           gotNewArticle(article: article)
        }
        
    }
    
    func gotNewArticle(article: Article?)
    {
        viewModel.article = article
        setupHeader()
        
        viewModel.clearData()
        tableView.reloadData()
        
        loadCommentData()
    }
    
    func loadCommentData() {
        
        viewModel.updateCommentData()
            .subscribe({ (event) in
            
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Header view
    func setupHeader() {
        titleLabel.text = viewModel.article?.title
        infoLabel.text = viewModel.getInfoString()
        
        if let postText = viewModel.article?.articlePostText,
            postText.count > 0 {
            postTextLabel.isHidden = false
            postTextLabel.text = viewModel.article?.articlePostText
        }
        else {
            postTextLabel.isHidden = true
        }
        
        tableView.layoutTableHeaderView()
    }
    
    func linkClicked(url: URL) {
        let svc = SFSafariViewController(url: url)
        self.present(svc, animated: true, completion: nil)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CommentCellIdentifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = self.viewModel.viewModels[indexPath.row]
        
        cell.configure(with: cellViewModel, linkHandler: self.linkClicked)
    
        
        return cell
    }
}
