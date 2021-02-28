//
//  CounterReactor.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/02/28.
//

import ReactorKit
import UIKit

/**
 
 Action: UI's Action
 Mutation : state changes
 State: current state
 
 mutate:  Observable<Mutation>  depending on Action
 reduce:  state + mutation  ->  new state
 
 */

final class CounterReactor: Reactor {
    
    enum Action {
        case decrease
        case increase
    }

    enum Mutation {
        case increaseValue
        case decreaseValue
        case setLoading(Bool)
    }
    
    struct State {
        var value: Int
        var isLoading: Bool
    }
    
    var initialState: State
    
    init() {
        initialState = State(value: 0, isLoading: false)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.concat([ // 동일한 type의 여러 Observable을 하나의 Observable
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.increaseValue)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .decrease:
            return Observable.concat([
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.decreaseValue)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
    
        var state = state
        
        switch mutation {
        
        case .decreaseValue:
            state.value -= 1
            
        case .increaseValue:
            state.value += 1
            
        case .setLoading(let isLoading):
            state.isLoading = isLoading
        }
        return state
        
    }
    
}

