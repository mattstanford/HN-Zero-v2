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

enum OptionSection {
    case main
    case themes
    case socialmedia
    
    var title: String? {
        switch self {
        case .main:
            return nil
        case .themes:
            return "Themes"
        case .socialmedia:
            return "Social Media"
        }
    }
}

enum ThemeSelection: String {
    case classic = "HN Zero Classic"
    case dark = "Dark Mode"
    
    var associatedTheme: ColorScheme {
        switch self {
        case .classic:
            return ColorScheme.standard
        case .dark:
            return ColorScheme.dark
        }
    }
}

enum SocialMediaSelection: String {
    case facebook = "Facebook"
    case twitter = "Twitter"
    
    var associatedUrl: String {
        switch self {
        case .facebook:
            return "https://www.facebook.com/1080017705457038"
        case .twitter:
            return "https://twitter.com/hackernewszero"
        }
    }
}

class OptionsViewController: UIViewController {
    
    @IBOutlet weak private var tableView: UITableView!
    @IBOutlet weak private var headerView: UIView!
    @IBOutlet weak private var headerLabel: UILabel!
    
    weak var delegate: OptionsDelegate?
    weak var navigator: AppNavigator?
    
    var colorScheme: ColorScheme = HackerNewsRepository.shared.settingsCache.colorScheme
    
    var sections: [OptionSection] = [.main, .themes, .socialmedia]
    var articleTypeSelections: [ArticleType] = [.frontpage, .askhn, .showhn, .jobs, .new]
    var themeSelections: [ThemeSelection] = [.classic, .dark]
    var socialMediaSelections: [SocialMediaSelection] = [.facebook, .twitter]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        set(scheme: colorScheme)
    }
}

extension OptionsViewController: ColorChangeable {
    func set(scheme: ColorScheme) {
        self.headerView.backgroundColor = scheme.barColor
        self.headerLabel.textColor = scheme.barTextColor
        self.tableView.backgroundColor = scheme.contentBackgroundColor
        self.tableView.tintColor = scheme.contentTextColor
        self.view.backgroundColor = scheme.barColor
    }
}

extension OptionsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard section < sections.count else {
            return nil
        }
        let section = sections[section]
        
        return section.title
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.backgroundView?.backgroundColor = HackerNewsRepository.shared.settingsCache.colorScheme.barColor
            headerView.textLabel?.textColor = HackerNewsRepository.shared.settingsCache.colorScheme.barTextColor
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        guard section < sections.count else {
            return 0
        }
        let section = sections[section]
        
        switch section {
        case .main:
            return articleTypeSelections.count
        case .themes:
            return themeSelections.count
        case .socialmedia:
            return socialMediaSelections.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell: UITableViewCell
        let section = sections[indexPath.section]
        
        switch section {
        case .main:
            cell = articleCell(tableView, indexPath: indexPath)
        case .themes:
            cell = themeCell(tableView, indexPath: indexPath)
        case .socialmedia:
            cell = socialMediaCell(tableView, indexPath: indexPath)
        }
        
        cell.backgroundColor = colorScheme.contentBackgroundColor
        cell.textLabel?.textColor = colorScheme.contentTextColor
        return cell
    }
    
    private func articleCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTypeCell", for: indexPath)

        let articleType = articleTypeSelections[indexPath.row]
        
        let cellText: String
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
        
        if HackerNewsRepository.shared.settingsCache.selectedArticleType == articleType {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        cell.textLabel?.text = cellText
    
        return cell
    }
    
    private func themeCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTypeCell", for: indexPath)
        
        let themeSelection = themeSelections[indexPath.row]
        cell.textLabel?.text = themeSelection.rawValue
        
        if HackerNewsRepository.shared.settingsCache.selectedTheme == themeSelection {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    
    private func socialMediaCell(_ tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ArticleTypeCell", for: indexPath)
        
        let selection = socialMediaSelections[indexPath.row]
        cell.textLabel?.text = selection.rawValue
        
        return cell
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard indexPath.section < sections.count else {
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        
        let section = sections[indexPath.section]
        switch section {
        case .main:
            selectedArticleCell(indexPath: indexPath)
        case .themes:
            selectedThemeCell(indexPath: indexPath)
        case .socialmedia:
            selectedSocialMediaCell(indexPath: indexPath)
        }
    }
    
    private func selectedArticleCell(indexPath: IndexPath) {
        let articleType = articleTypeSelections[indexPath.row]
        HackerNewsRepository.shared.settingsCache.selectedArticleType = articleType
        tableView.reloadData()
        delegate?.refreshArticles(type: articleType)
        navigator?.toggleMenu()
    }
    
    private func selectedThemeCell(indexPath: IndexPath) {
        let theme = themeSelections[indexPath.row]
        HackerNewsRepository.shared.settingsCache.selectedTheme = theme
        tableView.reloadData()
        print("selected theme!")
    }
    
    private func selectedSocialMediaCell(indexPath: IndexPath) {
        let socialMedia = socialMediaSelections[indexPath.row]
        
        if let url = URL(string: socialMedia.associatedUrl) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
