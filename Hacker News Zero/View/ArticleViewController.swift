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

class ArticleViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    var viewModel : ArticleListViewModel
    let disposeBag = DisposeBag()

    
    required init?(coder aDecoder: NSCoder) {
        
        let repository = HackerNewsRepository(client: HackerNewsApiClient(),cache: ApiCache())
        self.viewModel = ArticleListViewModel(repository: repository)
        
        super.init(coder: aDecoder)
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let split = splitViewController {
          //  let controllers = split.viewControllers
//            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
        getArticleData()
        
    }
 
    
    func getArticleData()
    {
        viewModel.getArticleListObservable()
            .subscribe({ (event) in
                
                print("finished getting articles!")
                print("got viemodels: " + String(self.viewModel.articleViewModels.count))
            })
            .disposed(by: disposeBag)
        
        self.tableView.reloadData()
    }


    // MARK: - Segues

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
        }
    }

    // MARK: - Table View

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return viewModel.articleViewModels.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ArticleTableViewCellIdentifier, for: indexPath)
        
        let articleViewModel = self.viewModel.articleViewModels[indexPath.row]
        
        articleViewModel.getArticleData()
            .subscribe { result in
                
                switch result {
                case .success(let article):
                    print("success!")
                    cell.textLabel?.text = article?.title
                    
                case .error(let error):
                    print("error!")
                    
                }
                
                
        }
        .disposed(by: disposeBag)
        
        
        cell.textLabel?.text = "hi"
       
        return cell
    }


}

