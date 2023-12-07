//
//  PlusMinusButton.swift
//  TCAtutorrial
//
//  Created by Marcin Dytko on 05/11/2023.
//

import SwiftUI
import ComposableArchitecture


struct PlusMinusFeature: Reducer {
    struct State: Equatable {
        var counter = 0
    }
    
    enum Action: Equatable {
        case didTapPlusButton
        case didTapMinusButton
    }
    
    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        
        switch action {
        case .didTapPlusButton:
            state.counter += 1
            return .none
        case .didTapMinusButton:
            state.counter -= 1
            return .none
        }
    }
    
}


struct PlusMinusButton: View {
    let store: StoreOf<PlusMinusFeature>
    
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            HStack {
                Button {
                    viewStore.send(.didTapMinusButton)
                } label: {
                    Text("-")
                        .padding(10)
                        .background(.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .buttonStyle(.plain)
                
                Text(viewStore.counter.description)
                    .padding(5)
                
                Button {
                    viewStore.send(.didTapPlusButton)
                } label: {
                    Text("+")
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

#Preview {
    PlusMinusButton(
        store: Store(initialState: PlusMinusFeature.State()) {
            PlusMinusFeature()
        }
    )
}
