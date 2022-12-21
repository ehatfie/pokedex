//
//  PokedexRootView.swift
//  pokedex
//
//  Created by Erik Hatfield on 12/18/22.
//  Copyright © 2022 Erik Hatfield. All rights reserved.
//

import SwiftUI
import PokemonAPI

struct PokedexRootView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var selection = 0
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \TestPokedex.id, ascending: true)],
        animation: .default)
    private var items: FetchedResults<TestPokedex>
    
    
    let apiCaller = ApiCaller()
    
    @State var selectedPokedex: PKMPokedex?
    @State var selectedLocalDex: TestPokedex?
    
    @ObservedObject var testManager = TestManager()

 
    var body: some View {
        VStack {
            //
            HStack {
                Spacer()
                VStack {
                    List(testManager.pokedexList, id: \.name) { item in
                        Text(item.name ?? "").onTapGesture {
                            self.selectedPokedex = item
                        }
                    }
                    
                    List(items, id: \.id) { item in
                        Text(item.name ?? "\(item.id) - NO_NAME ")
                            .onTapGesture {
                                self.selectedLocalDex = item
                            }
                    }
                }

                VStack {
                    if let pkmPokedex = self.selectedPokedex {
                        PokemonEntryView(viewModel: PokemonEntryViewModel(pokedex: pkmPokedex))
                    }
                    
                    if let selectedLocalDex = self.selectedLocalDex {
                        PokedexDetailView(viewModel: PokedexDetailViewModel(dex: selectedLocalDex))
                            .frame(minWidth: 250)
                    }
                }.border(.red)
                Spacer()
            }.border(.green)
            
            HStack {
                Button(action: {
                    callSomething()
                }, label: {
                    Text("SOME TEXT")
                })
                Button(action: {
                    saveData()
                }, label: {
                    Text("Save")
                })
            }
            
        }.padding(.top)
    }
    
    func setData(data: FetchPokemonResponseOuter) {
    }
    
    func saveData() {
        let pokedexList = self.testManager.pokedexList
        guard !pokedexList.isEmpty else {
            print("no pokedex to save")
            return
        }
        
        for pkmPokedex in pokedexList {
            let testPokedex = TestPokedex(context: self.viewContext)
            
            testPokedex.id = Int16(pkmPokedex.id ?? -1)
            testPokedex.name = pkmPokedex.name
            testPokedex.regions = ""
            
            try? viewContext.save()
        }
    }
    
    func callSomething() {
        Task {
            try? await testManager.loadData()
        }
    }
}

struct PokedexRootView_Previews: PreviewProvider {
    static var previews: some View {
        PokedexRootView()
    }
}
