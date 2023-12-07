//
//  ProductCell.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

struct ProductCell: View {
    let store: StoreOf<ProductFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                AsyncImage(url: URL(string: viewStore.product.imageString)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 300)
                } placeholder: {
                    ProgressView()
                        .frame(height: 300)
                }
                
                
                Text(viewStore.product.imageString)
                VStack(alignment: .leading) {
                    Text(viewStore.product.title)
                    HStack {
                        Text("$\(viewStore.product.price.description)")
                            .font(.custom("AmericanTypewriter", size: 25))
                            .fontWeight(.bold)
                        Spacer()
                        AddToCartButton(store: self.store.scope(
                            state: \.addToCartState,
                            action: ProductFeature.Action.addToCart))
                    }
                }
                .font(.custom("AmericanTypewriter", size: 20))
            }
            .padding(20)
        }
    }
}


#Preview {
    ProductCell(
        store: Store(
            initialState: ProductFeature.State(
                id: UUID(), product: Product.sample[0]
            )
        ) {
            ProductFeature()
        }
    )
}
