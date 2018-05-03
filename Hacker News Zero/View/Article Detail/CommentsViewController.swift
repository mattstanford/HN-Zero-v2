//
//  CommentsViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import RxSwift
import Atributika

let CommentCellIdentifier = "ComentCellIdentifier"

class CommentsViewController: UIViewController, ArticleViewable {
    
    let disposeBag = DisposeBag()
    weak var linkDelegate: LinkDelegate?
    
    lazy var viewModel: CommentsViewModel = {
        let repository = HackerNewsRepository(client: HackerNewsApiClient(), cache: ApiCache())
        return CommentsViewModel(with: repository)
    }()
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var postTextView: AttributedLabel!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var tableView: UITableView!
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
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
    
    //MARK: Header view
    func setupHeader() {
        titleLabel.text = viewModel.article?.title
        infoLabel.text = viewModel.infoString
        
        if let postText = viewModel.article?.articlePostText,
            postText.count > 0 {
            postTextView.isHidden = false
            postTextView.setHtmlText(text: postText, linkHandler: self.linkClicked)
            
        }
        else {
            postTextView.isHidden = true
        }
    }
    
    func linkClicked(url: URL) {
        linkDelegate?.show(url: url)
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
