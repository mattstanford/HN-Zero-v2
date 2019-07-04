//
//  CommentsViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 2/24/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Atributika
import RxSwift
import UIKit

class CommentsViewController: UIViewController, ArticleViewable, Shareable {

    let disposeBag = DisposeBag()
    weak var linkDelegate: LinkDelegate?

    lazy var viewModel: CommentsViewModel = {
        return CommentsViewModel(with: HackerNewsRepository.shared, colorScheme: HackerNewsRepository.shared.settingsCache.colorScheme)
    }()

    let commentCellIdentifier = "ComentCellIdentifier"
    let loadingCellIdentifier = "LoadingCell"
    let commentHeaderCellIdentifier = "commentHeaderCellIdentifier"

    @IBOutlet var tableView: UITableView!

    @IBOutlet internal weak var bottomBar: UIToolbar!
    @IBOutlet internal weak var bottomBarBottomConstraint: NSLayoutConstraint!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)

        return refreshControl
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        registerCellIdentifiers()
        set(scheme: viewModel.colorScheme)
        tableView.addSubview(refreshControl)
    }

    private func registerCellIdentifiers() {
         tableView.register(UINib(nibName: "CommentHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: commentHeaderCellIdentifier)
    }

    @IBAction private func shareButtonTapped() {
        if let article = viewModel.article {
            share(article: article)
        }
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData()
    }

    // MARK: ArticleViewable protocol

    func show(article: Article?) {

        if article?.id != viewModel.article?.id {
           gotNewArticle(article: article)
        }

    }

    func gotNewArticle(article: Article?) {
        viewModel.article = article

        viewModel.clearData()
        tableView.reloadData()
        refreshData()
    }

    func refreshData() {
        viewModel.updateCommentData()
            .subscribe({ _ in
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    func linkClicked(url: URL) {
        linkDelegate?.show(url: url)
    }

}

extension CommentsViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numRows(sectionIndex: section)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = viewModel.sections[indexPath.section]
        switch section {
        case .header:
            return getHeaderCell(tableView, cellForRowAt: indexPath)
        case .comments:
            return getCommentCell(tableView, cellForRowAt: indexPath)
        case .refresh:
            return getLoadingCell(tableView, cellForRowAt: indexPath)
        }
    }

    private func getCommentCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentCellIdentifier, for: indexPath) as? CommentTableViewCell else {
            return UITableViewCell()
        }
        let cellViewModel = self.viewModel.viewModels[indexPath.row]
        let nextCommentLevel = viewModel.levelOfNextComment(index: indexPath.row)
        cell.configure(with: cellViewModel, nextCommentLevel: nextCommentLevel, linkHandler: self.linkClicked)

        tableView.separatorStyle = .none

        return cell
    }

    private func getHeaderCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: commentHeaderCellIdentifier, for: indexPath) as? CommentHeaderTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(viewModel: viewModel, linkClickedClosure: self.linkClicked)

        tableView.separatorStyle = .none

        return cell
    }

    private func getLoadingCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: loadingCellIdentifier, for: indexPath) as? LoadingSpinnerCell else {
            return UITableViewCell()
        }
        cell.configure(colorScheme: viewModel.colorScheme)

        tableView.separatorStyle = .none

        return cell
    }
}

extension CommentsViewController: ColorChangeable {
    func switchScheme(to scheme: ColorScheme) {
        set(scheme: scheme)
        refreshData()
    }

    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        viewModel.colorScheme = scheme
        view.backgroundColor = scheme.contentBackgroundColor
        tableView.backgroundColor = scheme.contentBackgroundColor
        bottomBar.barTintColor = scheme.barColor
        bottomBar.tintColor = scheme.barTextColor
        refreshControl.tintColor = scheme.contentTextColor
    }
}

extension CommentsViewController: BottomBarHideable, UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {

        let offset = scrollView.contentOffset.y
        let recommendedHeight: CGFloat

        if offset <= 0 {
            //show bar
            recommendedHeight = 0
        } else {
            //hide bar
            recommendedHeight = view.safeAreaInsets.bottom + bottomBar.frame.height
        }

        if recommendedHeight != bottomBarBottomConstraint.constant {
            bottomBarBottomConstraint.constant = recommendedHeight

            bottomBar.setNeedsUpdateConstraints()

            UIView.animate(withDuration: 0.3, animations: {
                self.view.layoutIfNeeded()
            })
        }
    }
}
