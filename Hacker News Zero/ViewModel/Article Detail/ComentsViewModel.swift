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
        
       
        return repository.getComments(from: currentArticle)
            .map { comments in
                self.viewModels = self.flattenToViewModels(comments: comments, level: 0)
            }
            .ignoreElements()
        
    }
    
    func flattenToViewModels(comments: [Comment], level: Int) -> [CommentItemViewModel] {
        var list = [CommentItemViewModel]()
        for comment in comments {
            
            let viewModel = CommentItemViewModel(with: comment, level: level)
            list.append(viewModel)
            
            if let childComments = comment.childComments {
                list.append(contentsOf: flattenToViewModels(comments: childComments, level: level + 1))
            }
        }
        
        return list
    }
    

}
