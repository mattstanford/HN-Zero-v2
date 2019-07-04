//
//  MasterViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/21/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import CoreData
import RxSwift
import UIKit

let articleTableViewCellIdentifier = "ArticleTableViewCellIdentifier"

class ArticleViewController: UIViewController {

    var navigator: AppNavigator?
    var selectedArticleView: SelectedView?
    var selectedArticle: Article?

    var viewModel: ArticleListViewModel
    let disposeBag = DisposeBag()

    @IBOutlet var tableView: UITableView!

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(handleRefresh(_:)), for: UIControl.Event.valueChanged)

        return refreshControl
    }()

    required init?(coder aDecoder: NSCoder) {

        self.viewModel = ArticleListViewModel(repository: HackerNewsRepository.shared)
        super.init(coder: aDecoder)

    }

    override func viewDidLoad() {
        super.viewDidLoad()

        set(scheme: HackerNewsRepository.shared.settingsCache.colorScheme)

        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.estimatedRowHeight = 60
        self.tableView.addSubview(refreshControl)

        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        refreshData(clearCurrentEntries: true)
    }

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        refreshData(clearCurrentEntries: false)
    }

    func refreshData(clearCurrentEntries: Bool) {
        refreshControl.beginManualRefresh(for: tableView)

        if clearCurrentEntries {
            viewModel.reset()
            tableView.reloadData()
        }

        viewModel.startedLoading()

        viewModel.refreshArticles()
            .subscribe({ _ in
                UIView.animate(withDuration: 0.3, animations: {
                    self.refreshControl.endRefreshing()
                    self.viewModel.finishedLoading()

                    self.tableView.reloadData()
                })

            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Tap actions
extension ArticleViewController {
    @IBAction func tappedHamburger() {
        navigator?.toggleMenu()
    }

    func tappedWeb(viewModel: ArticleViewModel) {
        selectedArticle = viewModel.article
        perform(action: viewModel.tappedWebAction)
    }

    func tappedComments(viewModel: ArticleViewModel) {
        self.selectedArticle = viewModel.article
        self.perform(action: viewModel.tappedCommentsAction)
    }

    func perform(action: ArticleViewAction) {
        switch action {
        case .viewWeb:
            self.selectedArticleView = .web
        case .viewComments:
            self.selectedArticleView = .comments
        }
        performSegue(withIdentifier: "showArticleDetail", sender: nil)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let navVC = segue.destination as? UINavigationController,
            let detailVC = navVC.topViewController as? ArticleContainerViewController {
            detailVC.navigator = navigator
            detailVC.currentArticle = selectedArticle
            if let selectedView = selectedArticleView {
                detailVC.showArticle(in: selectedView)
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ArticleViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.articleViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: articleTableViewCellIdentifier, for: indexPath) as? ArticleTableViewCell,
             viewModel.articleViewModels.count > indexPath.row else {
            return UITableViewCell()
        }

        let articleViewModel = self.viewModel.articleViewModels[indexPath.row]
        cell.configure(for: articleViewModel, commentHandler: tappedComments)

        return cell
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        let lastElement = viewModel.articleViewModels.count - 1
        if viewModel.shouldTryToLoadMorePages && indexPath.row == lastElement {

            viewModel.startedLoading()
            viewModel.getNextPageOfArticles()
                .subscribe({ _ in
                    self.tableView.reloadData()

                    self.viewModel.finishedLoading()
                })
                .disposed(by: disposeBag)
        }
    }
}

// MARK: - UITableViewDelegate
extension ArticleViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard  viewModel.articleViewModels.count > indexPath.row else {
            return
        }
        let articleViewModel = self.viewModel.articleViewModels[indexPath.row]
        tappedWeb(viewModel: articleViewModel)
    }
}

// MARK: - OptionsDelegate
extension ArticleViewController: OptionsDelegate {
    func refreshArticles(type: ArticleType) {

        switch type {
        case .frontpage:
            self.title = "Hacker News Zero"
        default:
            self.title = type.titleText
        }

        let isDifferentArticleType = viewModel.articleType != type
        viewModel.articleType = type
        refreshData(clearCurrentEntries: isDifferentArticleType)
    }
}

// MARK: - ColorChangeable Protocol
extension ArticleViewController: ColorChangeable {
    func switchScheme(to scheme: ColorScheme) {
        set(scheme: scheme)
        refreshData(clearCurrentEntries: true)
    }

    func set(scheme: ColorScheme) {
        setColorOfNavBar(to: scheme)
        self.view.backgroundColor = scheme.contentBackgroundColor
        self.tableView.backgroundColor = scheme.contentBackgroundColor
        self.refreshControl.tintColor = scheme.contentTextColor
    }
}
