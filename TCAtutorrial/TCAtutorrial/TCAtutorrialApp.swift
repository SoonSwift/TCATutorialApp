//
//  TCAtutorrialApp.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture

@main
struct TCAtutorrialApp: App {
    var body: some Scene {
        WindowGroup {

            ProductListView(
                store: Store(initialState: ProductListFeature.State()) {
                    ProductListFeature(fetchProducts: {
                        Product.sample
                    }, sendOrder: {_ in "ok"})
                }
            )

        }
    }
}
