//
//  CartItemFeature.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 03/12/2023.
//

import Foundation
import ComposableArchitecture

struct CartItemFeature: Reducer {
    struct State: Equatable, Identifiable {
        let id: UUID
        let cartItem: CartItem
    }
    
    enum Action: Equatable {
        case deleteCartItem(product: Product)
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .deleteCartItem:
                return .none
            }
        }
    }
}
