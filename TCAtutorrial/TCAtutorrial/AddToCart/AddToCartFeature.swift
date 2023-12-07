//
//  AddToCartFeature.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 05/11/2023.
//

import Foundation
import ComposableArchitecture

struct AddToCartFeature: Reducer {
    struct State: Equatable { 
        var plusMinus = PlusMinusFeature.State()
    }
    
    enum Action: Equatable {
        case didTapAddToCart
        case plusMinus(PlusMinusFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.plusMinus, action: /Action.plusMinus, child: PlusMinusFeature.init)
        Reduce { state, action in
            switch action {
            case .didTapAddToCart:
                state.plusMinus.counter = 1
                return .none
            case .plusMinus:
                return .none
            }
        }
    }
}
