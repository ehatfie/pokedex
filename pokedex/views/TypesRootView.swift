//
//  TypesRootView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/20/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI


protocol TypesRootViewModelProtocol {
    
}

class TypesRootViewModel: TypesRootViewModelProtocol, ObservableObject{
    @Published var typesData: [PKType] = []
}

struct TypesRootView: View {
    var body: some View {
        VStack {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }
    }
}

struct TypesRootView_Previews: PreviewProvider {
    static var previews: some View {
        TypesRootView()
    }
}
