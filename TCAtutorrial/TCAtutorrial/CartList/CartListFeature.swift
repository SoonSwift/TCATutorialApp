//
//  CartListFeature.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 03/12/2023.
//

import Foundation
import ComposableArchitecture

struct CartListFeature: Reducer {
    struct State: Equatable {
        var cartItems: IdentifiedArrayOf<CartItemFeature.State> = []
        var totalPrice: Double =  0.0
        var isPayButtonDisable = false
        var confirmationAlert: AlertState<Action>?
    }
    
    enum Action: Equatable {
        case didPressCloseButton
        case cartItem(id: CartItemFeature.State.ID, action: CartItemFeature.Action)
        case getTotalPrice
        case didPressPayButton
        case didReceivePurscheseResponse(TaskResult<String>)
        case didConfirmPursches
        case didCancelConfirmation
    }
    
    private func verifyPayButtonVisibility(
        state: inout State
    ) -> Effect<Action> {
        state.isPayButtonDisable = state.totalPrice == 0.0
        return .none
    }
    
    let sendOrder: ([CartItem]) async throws -> String

    
    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
                
            case .didPressCloseButton:
                return .none
                
            case .cartItem(let id, let action):
                switch action {
                case .deleteCartItem:
                    state.cartItems.remove(id: id)
                    
                }
                return .send(.getTotalPrice)
                
            case .getTotalPrice:
                let items = state.cartItems.map { $0.cartItem }
                state.totalPrice = items.reduce(0.0, { $0 + ($1.product.price * Double($1.quantity))})
                return verifyPayButtonVisibility(state: &state)
                
            case .didPressPayButton:
                state.confirmationAlert = AlertState(title: TextState("Confirm"),
                                                     message: TextState("Do you want to procced?"),
                                                     primaryButton: .default(TextState("Confirm"), action: .send(.didConfirmPursches)),
                                                     secondaryButton: .cancel(TextState("Cancel"))
                                                     )
                return .none
            case .didReceivePurscheseResponse(.success(let message)):
                print(message)
                return .none
                
            case .didReceivePurscheseResponse(.failure(let error)):
                print(error.localizedDescription)
                return .none
                
            case .didConfirmPursches:
                state.confirmationAlert = nil
                let items = state.cartItems.map { $0.cartItem}
                return .run { send in
                    await send(
                        .didReceivePurscheseResponse(TaskResult {
                            try await self.sendOrder(items)
                        })
                    )
                }
                
            case .didCancelConfirmation:
                state.confirmationAlert = nil
                return .none
            }
            
        }
        .forEach(\.cartItems, action: /Action.cartItem(id: action:)) {
            CartItemFeature()
        }
    }
    

}
