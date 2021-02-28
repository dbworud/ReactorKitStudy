//
//  GithubSearchReactor.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/02/28.
//

import Foundation
import ReactorKit

class GithubSearchReactor: Reactor {
    
    let service = SearchService()
    
    enum Action {
        case updateQuery(String?)
        case loadNextPage
    }

    enum Mutation {
        case setQuery(String?)
        case setRepos([String], nextPage: Int?)
        case appendRepos([String], nexPage: Int?)
        case setLoadingNextPage(Bool)
    }

    struct State {
        var query: String?
        var repos: [String] = []
        var nextPage: Int?
        var isLoadingNextPage: Bool = false
    }
    
    var initialState = State()


    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case let .updateQuery(query):
            
            return Observable.concat([
                Observable.just(Mutation.setQuery(query)),
                
                // call API and set repos
                self.service.search(query: query, page: 1)
                    .takeUntil(self.action.filter(Action.isUpdateQueryAction)) // cancel previous request when the new `.updateQuery` action is fired.
                    .map{ Mutation.setRepos($0, nextPage: $1)}
            ])
            
        case .loadNextPage:
            // prevent from multiple requests. isLoadingNextPage가 false이면.. empty Observable보냄
            guard !self.currentState.isLoadingNextPage else { return Observable.empty() }
            
            // nextPage 없으면 empty Observable보냄
            guard let page = self.currentState.nextPage else { return Observable.empty() }
            
            return Observable.concat([
                Observable.just(Mutation.setLoadingNextPage(true)),
                
                // call API and append repos
                self.service.search(query: self.currentState.query, page: page)
                    .takeUntil(self.action.filter(Action.isUpdateQueryAction))
                    .map{ Mutation.appendRepos($0, nexPage: $1)},
        
                Observable.just(Mutation.setLoadingNextPage(false))

            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        
        switch mutation {
        case let .setQuery(query):
            var newState = state
            newState.query = query
            return newState
            
        case let .setRepos(repos, nextPage):
            var newState = state
            newState.repos = repos
            newState.nextPage = nextPage
            return newState
            
        case let .appendRepos(repos, nextPage):
            var newState = state
            newState.repos.append(contentsOf: repos)
            newState.nextPage = nextPage
            return newState
            
        case let .setLoadingNextPage(isLoadingNextPage):
            var newState = state
            newState.isLoadingNextPage = isLoadingNextPage
            return newState
            
        }
    }
}

extension GithubSearchReactor.Action {
    static func isUpdateQueryAction(_ action: GithubSearchReactor.Action) -> Bool {
        if case .updateQuery = action {
            return true
        } else {
            return false
        }
    }
    
}
