//
//  ContentView.swift
//  Plants
//
//  Created by Alexander Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @ObservedObject var viewModel = PlantViewModel()
    @State private var showingAddScreen = false
    
    init() {        
        let appearance = UINavigationBarAppearance()
                
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        appearance.shadowColor = .clear
        
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().tintColor = .black
    }
    
    var body: some View {
        NavigationView {
            CollectionView(items: $viewModel.items) { plant in
                NavigationLink(destination: DetailView(plant: plant)) {
                    PlantView(plant: plant)
                }.buttonStyle(PlainButtonStyle())
            }
            .padding([.leading, .trailing], 8)
            .navigationBarTitle("My Plants", displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                Image(uiImage: UIImage(systemName: "plus", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))!)
            })
                .sheet(isPresented: $showingAddScreen) {
                    AddPlantView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
