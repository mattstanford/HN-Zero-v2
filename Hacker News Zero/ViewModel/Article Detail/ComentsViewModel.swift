//
//  ComentsViewModel.swift
//  Hacker News Zero
//
//  Created by Matt Stanford on 3/4/18.
//  Copyright © 2018 locacha. All rights reserved.
//

import Foundation
import RxSwift

class CommentsViewModel {

    let repository: HackerNewsRepository
    var article: Article?
    var viewModels = [CommentItemViewModel]()
    var sections: [CommentSection] = [.header, .comments]
    var colorScheme: ColorScheme

    private let infoSeparator: String = "•"

    init(with repository: HackerNewsRepository, colorScheme: ColorScheme) {
        self.repository = repository
        self.colorScheme = colorScheme
    }

    var numSections: Int {
        return sections.count
    }

    func numRows(sectionIndex: Int) -> Int {
        let section = sections[sectionIndex]
        switch section {
        case .comments:
            return viewModels.count
        default:
            return 1
        }
    }

    func reset() {
        viewModels = []
    }

    var infoString: String {
        //num commments * user * domain * time since
        var infoString = ""

        if let numComments = article?.numComments {
            infoString += String(numComments) + " " + "comments".localized
        }

        if infoString.count > 0 {
            infoString +=  " " + infoSeparator + " "
        }

        if let author = article?.author {
            infoString += author
        }

        return infoString
    }

    func clearData() {
        self.viewModels = [CommentItemViewModel]()
        sections = [.header, .refresh]
    }

    func updateCommentData() -> Completable {

        guard let currentArticle = article else {
            return Completable.empty()
        }

        return repository.getComments(from: currentArticle)
            .map { comments in
                self.viewModels = self.flattenToViewModels(comments: comments, level: 0)
                if self.viewModels.count > 0 {
                    self.sections = [.header, .comments]
                } else {
                    self.sections = [.header, .emptyComments]
                }
            }
            .ignoreElements()

    }

    func flattenToViewModels(comments: [Comment], level: Int) -> [CommentItemViewModel] {
        var list = [CommentItemViewModel]()
        for comment in comments {

            guard !comment.isDeleted || (comment.isDeleted && comment.hasChildComments) else {
                continue
            }

            let isOp = article?.author == comment.author

            let viewModel = CommentItemViewModel(with: comment, isOp: isOp, level: level, colorScheme: repository.settingsCache.colorScheme)
            list.append(viewModel)

            if let childComments = comment.childComments {
                list.append(contentsOf: flattenToViewModels(comments: childComments, level: level + 1))
            }
        }

        return list
    }

    func levelOfNextComment(index: Int) -> Int {
        guard viewModels.count > index else {
            return 0
        }

        //Is it the VERY last comment?
        if index == viewModels.count - 1 {
            return 0
        } else {
            let nextComment = viewModels[index + 1]
            return nextComment.displayedLevel
        }
    }

    func switchColor(scheme: ColorScheme) {
        self.colorScheme = scheme
        for itemViewModel in viewModels {
            itemViewModel.colorScheme = scheme
        }
    }

}
