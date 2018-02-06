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

class ArticleViewController: UITableViewController {

    var detailViewController: DetailViewController? = nil
    
    let disposeBag = DisposeBag()


    override func viewDidLoad() {
        super.viewDidLoad()
    
        
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
        
//        HackerNewsApiClient.getArticleList().subscribe(onNext: { arrayOfStoryIds in
//            print("got articles!!")
//            
//            let temp = arrayOfStoryIds[0]
//            
//            HackerNewsApiClient.getArticleData(articleId: temp).subscribe(onNext: { article in
//                print("got article!!")
//                
//            }, onError: { (error) in
//                print("got error getting article!")
//            }).disposed(by: self.disposeBag)
//           
//            
//        }, onError: { (error) in
//            print("got error!")
//        }).disposed(by: disposeBag)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
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
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
       
        return cell
    }


}

