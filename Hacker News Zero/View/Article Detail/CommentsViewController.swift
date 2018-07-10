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

class CommentsViewController: UIViewController, ArticleViewable, Shareable {
    
    let disposeBag = DisposeBag()
    weak var linkDelegate: LinkDelegate?
    
    lazy var viewModel: CommentsViewModel = {
        return CommentsViewModel(with: HackerNewsRepository.shared, colorScheme: HackerNewsRepository.shared.settingsCache.colorScheme)
    }()
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var postTextView: AttributedLabel!
    @IBOutlet weak private var infoLabel: UILabel!
    @IBOutlet weak private var headerSeparatorView: UIView!
    @IBOutlet weak private var tableView: UITableView!
    
    @IBOutlet internal weak var bottomBar: UIToolbar!
    @IBOutlet internal weak var bottomBarBottomConstraint: NSLayoutConstraint!
    
    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(handleRefresh(_:)), for: UIControlEvents.valueChanged)
    
        return refreshControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(scheme: viewModel.colorScheme)
        tableView.addSubview(refreshControl)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.layoutTableHeaderView()
    }
    
    @IBAction private func shareButtonTapped() {
        if let article = viewModel.article {
            share(article: article)
        }
    }
    
    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
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
        
        refreshData()
    }
    
    func refreshData() {
                
        viewModel.reset()
        tableView.reloadData()

        viewModel.updateCommentData()
            .subscribe({ (event) in
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: Header view
    func setupHeader() {
        titleLabel.text = viewModel.article?.title
        titleLabel.textColor = viewModel.colorScheme.contentTextColor
        infoLabel.text = viewModel.infoString
        infoLabel.textColor = viewModel.colorScheme.contentInfoTextColor
        headerSeparatorView.backgroundColor = viewModel.colorScheme.barColor
        
        if let postText = viewModel.article?.articlePostText,
            postText.count > 0 {
            postTextView.isHidden = false
            postTextView.backgroundColor = viewModel.repository.settingsCache.colorScheme.contentBackgroundColor
            postTextView.setHtmlText(text: postText, colorScheme: viewModel.colorScheme, linkHandler: self.linkClicked)
            
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

extension CommentsViewController: ColorChangeable {
    func switchScheme(to scheme: ColorScheme) {
        set(scheme: scheme)
        setupHeader()
        refreshData()
    }
    
    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        viewModel.colorScheme = scheme
        tableView.backgroundColor = scheme.contentBackgroundColor
        bottomBar.barTintColor = scheme.barColor
        bottomBar.tintColor = scheme.barTextColor
        refreshControl.tintColor = scheme.contentTextColor
    }
}

extension CommentsViewController: BottomBarHideable, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offset = scrollView.contentOffset.y
        
        if offset <= 0 {
            //show bar
            bottomBarBottomConstraint.constant = 0
        } else {
            //hide bar
            bottomBarBottomConstraint.constant = view.safeAreaInsets.bottom + bottomBar.frame.height
        }
        
        bottomBar.setNeedsUpdateConstraints()
        
        
        UIView.animate(withDuration: 0.3, animations: {
            self.view.layoutIfNeeded()
        })
    }
}
