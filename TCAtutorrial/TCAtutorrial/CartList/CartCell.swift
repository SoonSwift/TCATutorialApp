//
//  CartCell.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 03/12/2023.
//

import SwiftUI
import ComposableArchitecture

struct CartCell: View {
    // MARK: - PROPERTIES
    let store: StoreOf<CartItemFeature>
    // MARK: - BODY
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    AsyncImage(
                        url: URL(
                            string: viewStore.cartItem.product.imageString
                        )
                    ) {
                        $0
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                    } placeholder: {
                        ProgressView()
                            .frame(width: 100, height: 100)
                    }
                    VStack(alignment: .leading) {
                        Text(viewStore.cartItem.product.title)
                            .lineLimit(3)
                            .minimumScaleFactor(0.5)
                        HStack {
                            Text("$\(viewStore.cartItem.product.price.description)")
                                .font(.custom("AmericanTypewriter", size: 25))
                                .fontWeight(.bold)
                        }
                    }
                    
                }
                ZStack {
                    Group {
                        Text("Quantity: ")
                        +
                        Text("\(viewStore.cartItem.quantity)")
                            .fontWeight(.bold)
                    }
                    .font(.custom("AmericanTypewriter", size: 25))
                    HStack {
                        Spacer()
                        Button {
                            viewStore.send(
                                .deleteCartItem(
                                product: viewStore.cartItem.product
                                )
                            )
                        } label: {
                            Image(systemName: "trash.fill")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
            }
            .font(.custom("AmericanTypewriter", size: 20))
            .padding([.bottom, .top], 10)
        }
    }
}


#Preview {
    CartCell(
        store: Store(
            initialState: CartItemFeature.State(id: UUID(), cartItem: CartItem.sample.first!)
        ) {
            CartItemFeature()
        }
    )
}
