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
    //    @FetchRequest(entity: Plant.entity(), sortDescriptors: []) var plants: FetchedResults<Plant>
    
    @ObservedObject var viewModel = PlantViewModel()
    
    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            CollectionView(model: viewModel) { plant in
                Text(plant.name ?? "Unnamed")
            }
            .navigationBarTitle("My Plants")
            .navigationBarItems(trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                Image(systemName: "plus")
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
