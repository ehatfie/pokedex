//
//  TypesRootView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/20/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI


struct TypesRootView: View {
    @ObservedObject var viewModel: TypesRootViewModel
    var body: some View {
        VStack {
            Text("HI")
            List(viewModel.typesData, id: \.id) { item in
                HStack {
                    Text(item.name)
                    
                    createDamageRelation(damageRelations: item.damageRelations)
                }
            }
        }
    }
    
    func createDamageRelation(damageRelations: TypeRelations) -> some View {
        return VStack {
            Text("Damage")
            HStack {
                Text("No damage to")
                VStack {
                    ForEach(damageRelations.noDamageTo, id: \.id) { item in
                        Text(item.name)
                    }
                }
            }
            HStack {
                Text("Weak against")
                VStack {
                    ForEach(damageRelations.halfDamageTo, id: \.id) { item in
                        Text(item.name)
                    }
                }
            }
            
            HStack {
                Text("Strong against")
                VStack {
                    ForEach(damageRelations.doubleDamageTo, id: \.id) { item in
                        Text(item.name)
                    }
                }
            }
        }
    }
}

struct TypesRootView_Previews: PreviewProvider {
    static var previews: some View {
        TypesRootView(viewModel: TypesRootViewModel())
    }
}
