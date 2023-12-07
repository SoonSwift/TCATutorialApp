//
//  ProductListView.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 16/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductListView: View {
    // MARK: - PROPETRIES
    let store: StoreOf<ProductListFeature>
    // MARK: - BODY
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.productList,
                            action: ProductListFeature.Action.product(id:action:)
                        )
                    ) {
                        ProductCell(store: $0)
                    }
                }
                .task {
                    viewStore.send(.fetchProducts)
                }
                .navigationTitle("Products")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            viewStore.send(.setCartView(isPresented: true))
                        } label: {
                            Text("Go to Cart")
                        }
                    }
                }
                .sheet(
                    isPresented: viewStore.binding(
                        get: \.shouldOpenCart,
                        send: ProductListFeature.Action.setCartView(isPresented:)
                    )
                ) {
                    IfLetStore(
                        self.store.scope(
                            state: \.cartState,
                            action: ProductListFeature.Action.cart
                        )
                    ) {
                        CartListView(store: $0)
                    }
                }
            }
        }
    }
}

// MARK: - PREVIEW

#Preview {
    ProductListView(
        store: Store(
            initialState: ProductListFeature.State()
        ) {
            ProductListFeature(
                fetchProducts: { Product.sample }, sendOrder: { _ in "ok"}
            )
        }
    )
}
