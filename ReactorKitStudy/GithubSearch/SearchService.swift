//
//  SearchService.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/02/28.
//

import UIKit
import ReactorKit
import RxCocoa
import RxSwift

class SearchService {
    
    func search(query: String?, page: Int) -> Observable<(repos: [String], nextPage: Int?)> {
        
        let emptyResult: ([String], Int?) = ([], nil)
        guard let url = self.url(for: query, page: page) else { return .just(emptyResult)}
        
        return URLSession.shared.rx.json(url: url)
            .map { json -> ([String], Int?) in
                guard let dict = json as? [String: Any] else { return emptyResult }
                guard let items = dict["items"] as? [[String:Any]] else { return emptyResult }
                
                let repos = items.compactMap{ $0["full_name"] as? String}
                let nextPage = repos.isEmpty ? nil : page + 1
                
                return (repos, nextPage)
            }
            .do(onError: { _ in
                print("Github API Rate limit exceed. ")
            })
            .catchErrorJustReturn(emptyResult)

    }
    
    // "https://api.github.com/search/repositories?q=\(query)&page=\(page)"
    private func url(for query: String?, page: Int?) -> URL? {
        
        guard let query = query, !query.isEmpty else { return nil }
        return URL(string: "https://api.github.com/search/repositories?q=\(query)&page=\(page)")
    }
    
}

