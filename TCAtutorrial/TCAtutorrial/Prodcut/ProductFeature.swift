//
//  ProductFeature.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 05/11/2023.
//

import Foundation
import ComposableArchitecture

struct ProductFeature: Reducer {
    
    struct State: Equatable, Identifiable {
        let id: UUID
        let product: Product
        var addToCartState = AddToCartFeature.State()
        
        var count: Int {
            get { addToCartState.plusMinus.counter }
            set { addToCartState.plusMinus.counter = newValue }
            
        }
    }
    
    enum Action: Equatable {
        case addToCart(AddToCartFeature.Action)
    }
    
    var body: some ReducerOf<Self> {
        Scope(state: \.addToCartState, action: /Action.addToCart, child: AddToCartFeature.init)._printChanges()
    }
    
}
