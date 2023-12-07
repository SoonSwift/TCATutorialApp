//
//  ProductListDomain.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 16/11/2023.
//

import Foundation
import ComposableArchitecture

struct ProductListFeature: Reducer {

    struct State: Equatable {
        var productList: IdentifiedArrayOf<ProductFeature.State> = []
        var cartState: CartListFeature.State?
        var shouldOpenCart = false
    }
    
    enum Action: Equatable {
        case fetchProducts
        case fetchProductsResponse(TaskResult<[Product]>)
        case product(id: ProductFeature.State.ID, action: ProductFeature.Action)
        case setCartView(isPresented: Bool)
        case cart(CartListFeature.Action)
    }
    
    var fetchProducts: @Sendable () async throws -> [Product]
    var sendOrder:  @Sendable ([CartItem]) async throws -> String

    var body: some ReducerOf<Self> {
        Reduce { state , action in
            switch action {
            case .fetchProducts:
                return .run { send in
                    await send(
                        .fetchProductsResponse(
                            TaskResult {
                                try await self.fetchProducts()
                            }
                        )
                    )
                }
                
                
            case .fetchProductsResponse(.success(let products)):
                state.productList = IdentifiedArrayOf(uniqueElements: products.map {
                    ProductFeature.State(id: UUID(), product: $0)
                })
                return .none
                
            case .fetchProductsResponse(.failure(let error)):
                print("Eroor getting products try agian later")
                print(error)
                return .none
                
            case .product:
                return .none
                
            case .setCartView(let isPresented):
                state.shouldOpenCart = isPresented
                state.cartState = isPresented ? CartListFeature.State(cartItems: IdentifiedArray(uniqueElements: state.productList.compactMap { state in
                    state.addToCartState.plusMinus.counter > 0 ?
                    CartItemFeature.State(id: UUID(), cartItem: CartItem(product: state.product, quantity: state.addToCartState.plusMinus.counter)) : nil
                })) : nil
                return .none
                
            case .cart(let action):
                switch action {
                case .didPressCloseButton:
                    state.shouldOpenCart = false
                case .cartItem(_, action: let action):
                    switch action {
                    case .deleteCartItem(let product):
                        guard let index = state.productList.firstIndex(
                            where: { $0.product.id == product.id }
                        )
                        else { return .none }
                        let productStateId = state.productList[index].id
                        
                        state.productList[id: productStateId]?.count = 0
                    }
                    return .none
                default:
                    break
                }
                return .none

            }
            
        }._printChanges()
        .forEach(
            \.productList,
            action: /ProductListFeature.Action.product(id:action:)
        ) {
            ProductFeature()
        }
        .ifLet(\.cartState, action: /Action.cart) {
          CartListFeature(sendOrder: sendOrder)
        }
    }
    
}
