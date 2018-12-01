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

    weak var delegate: OptionsDelegate?
    weak var navigator: AppNavigator?

    var colorScheme: ColorScheme = HackerNewsRepository.shared.settingsCache.colorScheme

    var sections: [OptionSection] = [.main, .themes, .socialmedia]
    var articleTypeSelections: [ArticleType] = [.frontpage, .askhn, .showhn, .jobs, .new]
    var themeSelections: [ColorScheme] = [.standard, .dark]
    var socialMediaSelections: [SocialMediaSelection] = [.facebook, .twitter]

    override func viewDidLoad() {
        super.viewDidLoad()
        set(scheme: colorScheme)
    }
}

extension OptionsViewController: ColorChangeable {
    func switchScheme(to scheme: ColorScheme) {
        set(scheme: colorScheme)
        tableView.reloadData()
    }

    func set(scheme: ColorScheme) {
        colorScheme = scheme
        self.headerView.backgroundColor = scheme.barColor
        self.tableView.backgroundColor = scheme.contentBackgroundColor
        self.tableView.tintColor = scheme.accentColor
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
            headerView.backgroundView?.backgroundColor = colorScheme.barColor
            headerView.textLabel?.textColor = colorScheme.barTextColor
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
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

        let cellText = articleType.titleText

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
        cell.textLabel?.text = themeSelection.displayTitle

        if HackerNewsRepository.shared.settingsCache.colorScheme == themeSelection {
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

    // MARK: UITableViewDelegate

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
        let scheme = themeSelections[indexPath.row]
        HackerNewsRepository.shared.settingsCache.colorScheme = scheme

        set(scheme: scheme)
        tableView.reloadData()

        navigator?.switchColorScheme(to: scheme)
    }

    private func selectedSocialMediaCell(indexPath: IndexPath) {
        let socialMedia = socialMediaSelections[indexPath.row]

        if let url = URL(string: socialMedia.associatedUrl) {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }
}

// Helper function inserted by Swift 4.2 migrator.
private func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value) })
}
