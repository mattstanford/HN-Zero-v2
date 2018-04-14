//
//  MasterViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 1/21/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

let ArticleTableViewCellIdentifier = "ArticleTableViewCellIdentifier"

class ArticleViewController: UIViewController {

    var navigator: AppNavigator?
    
    var viewModel : ArticleListViewModel
    let disposeBag = DisposeBag()
    
    @IBOutlet weak private var tableView: UITableView!

    
    required init?(coder aDecoder: NSCoder) {
        
        let repository = HackerNewsRepository(client: HackerNewsApiClient(),cache: ApiCache())
        self.viewModel = ArticleListViewModel(repository: repository)
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.estimatedRowHeight = 60
        
        refreshData()
        
    }
    
    func refreshData()
    {
        viewModel.clearArticles()
        tableView.reloadData()
        
        viewModel.refreshArticles()
            .subscribe({ (event) in
                self.tableView.reloadData()
            })
            .disposed(by: disposeBag)
    }
    
    @IBAction func tappedHamburger() {
        navigator?.toggleMenu()
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toArticleDetail",
            let detailVC = segue.destination as? ArticleContainerViewController {
            
            detailVC.selectedView = .comments
        }
    }
}

//MARK: - UITableViewDataSource
extension ArticleViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.articleViewModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCellIdentifier, for: indexPath) as! ArticleTableViewCell
        
        let articleViewModel = self.viewModel.articleViewModels[indexPath.row]
        cell.configure(for: articleViewModel)
        
        return cell
    }
    
    @IBAction private func commentsTapped() {
        
    }
    
}

//MARK: - UITableViewDelegate
extension ArticleViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let articleViewModel = self.viewModel.articleViewModels[indexPath.row]
        navigator?.show(article: articleViewModel.article)
        
    }
}

//MARK: - OptionsDelegate
extension ArticleViewController: OptionsDelegate {
    func refreshArticles(type: ArticleType) {
        
        viewModel.articleType = type
        refreshData()
    }
    
    
}

