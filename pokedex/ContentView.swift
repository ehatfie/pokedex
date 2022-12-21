//
//  ContentView.swift
//  pokedex
//
//  Created by Erik Hatfield on 6/24/20.
//  Copyright © 2020 Erik Hatfield. All rights reserved.
//

import SwiftUI
import PokemonAPI

struct ContentView: View {
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
        NavigationView {
            List {
                NavigationLink {
                    PokedexRootView()
                } label: {
                    Text("Pokedex Views")
                }
                
                NavigationLink {
                    PokemonRootView()
                } label: {
                    Text("Pokemon Views")
                }
                
                NavigationLink {
                    TypesRootView()
                } label: {
                    Text("Types")
                }
            }
        }
        
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct MyView: View {
    var body: some View {
        Text("Hello")
    }
}

//        TabView(selection: $selection) {
//            Text("First View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("first")
//                        Text("First")
//                    }
//                }
//                .tag(0)
//
//            Text("Second View")
//                .font(.title)
//                .tabItem {
//                    VStack {
//                        Image("second")
//                        Text("Second")
//                    }
//                }
//                .tag(1)
//        }
