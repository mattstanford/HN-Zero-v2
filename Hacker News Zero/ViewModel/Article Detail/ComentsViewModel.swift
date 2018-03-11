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
    
    private let infoSeparator: String = "•"
    
    init(with repository: HackerNewsRepository) {
        self.repository = repository
    }
    
    func getInfoString() -> String {
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
    
    func updateCommentData() -> Completable {
        
        guard let currentArticle = article else {
            return Completable.empty()
        }
        
        return repository.getComments(for: currentArticle)
            .flatMap { comments in
                return Observable.from(comments)
            }
            .map { comment in
                return CommentItemViewModel(with: comment)
            }
            .toArray()
            .map { commentViewModels -> [CommentItemViewModel] in
                self.viewModels = commentViewModels
                return commentViewModels
            }
            .ignoreElements()
    }
    
}
