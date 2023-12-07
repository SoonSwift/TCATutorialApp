//
//  CartListView.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 03/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct CartListView: View {
    let store: StoreOf<CartListFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                List {
                    ForEachStore(
                        self.store.scope(
                            state: \.cartItems,
                            action: CartListFeature.Action
                                .cartItem(id:action:)
                        )
                    ) {
                        CartCell(store: $0)
                    }
                }
                .onAppear {
                    viewStore.send(.getTotalPrice)
                }
                .safeAreaInset(edge: .bottom) {
                    Button {
                        viewStore.send(.didPressPayButton)
                    } label: {
                        HStack(alignment: .center) {
                            Spacer()
                            Text("Pay $ \(viewStore.totalPrice.formatted())")
                                .font(.custom("AmericanTypewriter", size: 30))
                                .foregroundColor(.white)
                            
                            Spacer()
                        }
                    }

                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(
                        viewStore.isPayButtonDisable ?
                            .gray : .blue
                    )
                    .cornerRadius(10)
                    .padding()
                    .disabled(viewStore.isPayButtonDisable)
                }
                .navigationTitle("Cart")
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            viewStore.send(.didPressCloseButton)
                        } label: {
                            Text("Close")
                        }
                    }
                }
                .alert(
                    self.store.scope(
                        state: \.confirmationAlert,
                        action: { $0 }
                    ),
                    dismiss: .didCancelConfirmation
                )
            }
        }
    }
}

#Preview {
    CartListView(store: Store(initialState: CartListFeature.State(cartItems: IdentifiedArrayOf(uniqueElements: CartItem.sample.map {
        CartItemFeature.State(id: UUID(), cartItem: $0)
    })
        )
    ) {
        CartListFeature(sendOrder: {_ in "ok"})
    }
    
    )
}
