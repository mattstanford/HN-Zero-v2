//
//  OptionsViewController.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/28/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import UIKit

protocol OptionsDelegate: class {
    func refreshArticles(type: ArticleType)
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    weak var delegate: OptionsDelegate?
    weak var navigator: AppNavigator?
    
    var articleTypeSelections: [ArticleType] = [.frontpage, .askhn, .showhn, .jobs, .new]
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return articleTypeSelections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTypeCell", for: indexPath)
        
        let articleType = articleTypeSelections[indexPath.row]
        var cellText = ""
        
        switch articleType {
        case .frontpage:
            cellText = "Front Page"
        case .askhn:
            cellText = "Ask HN"
        case .showhn:
            cellText = "Show HN"
        case .jobs:
            cellText = "Jobs"
        case .new:
            cellText = "New"
        }
        
        cell.textLabel?.text = cellText
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let articleType = articleTypeSelections[indexPath.row]
        delegate?.refreshArticles(type: articleType)
        navigator?.toggleMenu()
    }
    
}
