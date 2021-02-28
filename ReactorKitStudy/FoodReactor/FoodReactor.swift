//
//  FoodReactor.swift
//  ReactorKitStudy
//
//  Created by jaekyung you on 2021/01/21.
//

import Foundation
import ReactorKit

class FruitReactor: Reactor {
   
    // MARK: Actions - represent user action
    enum Action {
        case apple
        case banana
        case grapes
    }

    // MARK: Mutations - represent state changes
    enum Mutation {
        case changeLabelApple
        case changeLabelBanana
        case changeLabelGrapes
        case setLoading(Bool)
    }
    
    // MARK: State - represent the current view state
    struct State {
        var fruitName: String
        var isLoading: Bool
    }
    
    let initialState: State
    
    init() {
        initialState = State(fruitName: "선택된 과일 없음", isLoading: false)
    }
    
    // MARK: Helpers
    // receive acition and generate Observable<Mutation>
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .apple:
            return Observable.concat([ // 여러 Sequence를 묶는다; 첫 번째 Sequence가 완료될 때까지 구독하고 다음 Sequence를 같은 방법으로 구독한다
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelApple)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .banana:
            return Observable.concat([ // 여러 Sequence를 묶는다; 첫 번째 Sequence가 완료될 때까지 구독하고 다음 Sequence를 같은 방법으로 구독한다
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelBanana)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
            
        case .grapes:
            return Observable.concat([ // 여러 Sequence를 묶는다; 첫 번째 Sequence가 완료될 때까지 구독하고 다음 Sequence를 같은 방법으로 구독한다
                Observable.just(Mutation.setLoading(true)),
                Observable.just(Mutation.changeLabelGrapes)
                    .delay(.milliseconds(500), scheduler: MainScheduler.instance),
                Observable.just(Mutation.setLoading(false))
            ])
        }
    }
    
    // generates a new state from a previous state and a mutation
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state // create a copy of old sate
        
        switch mutation {
        case .changeLabelApple:
            state.fruitName = "사과"
            
        case .changeLabelBanana:
            state.fruitName = "바나나"
            
        case .changeLabelGrapes:
            state.fruitName = "포도"
            
        case .setLoading(let val):
            state.isLoading = val
        }
        
        return state
    }
}
