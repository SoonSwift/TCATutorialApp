//
//  AddToCartButton.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct AddToCartButton: View {
    let store: StoreOf<AddToCartFeature>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            if viewStore.plusMinus.counter > 0 {
                PlusMinusButton(store: self.store.scope(state: \.plusMinus, action: AddToCartFeature.Action.plusMinus))
            } else {
                Button {
                    viewStore.send(.didTapAddToCart)
                } label: {
                    Text("Add to Cart")
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
            }
        }
    }
}

//#Preview {
//    AddToCartButton(store: Store(initialState: AddToCartFeature.State(plusMinus: <#PlusMinusFeature.State#>)) {
//        AddToCartFeature()
//        }
//    )
//}
