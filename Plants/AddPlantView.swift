//
//  AddPlantView.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI
import Combine

struct AddPlantView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var name = ""
    @State private var waterFrequency = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Plant Name", text: $name)
                    TextField("Water every", text: $waterFrequency)
                        .keyboardType(.numberPad)
                        .onReceive(Just(waterFrequency)) { newValue in
                            let filtered = newValue.filter { "0123456789".contains($0) }
                            if filtered != newValue {
                                self.waterFrequency = filtered
                            }
                    }
                }

                Section {
                    TextField("About me", text: $notes)
                }

        
                Button("Save") {
                    // add the plant
                    let plant = Plant(context: self.moc)
                    plant.name = self.name
                    if let frequency = Int16(self.waterFrequency) {
                        plant.waterFrequency = frequency
                    }
                    plant.notes = self.notes
                    plant.createdAt = Date()

                    try? self.moc.save()
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Add Plant")
        }
    }
}
