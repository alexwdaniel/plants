//
//  AddPlantView.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI
import Combine

struct CustomButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(Color.blue)
            .cornerRadius(10)
            .padding(.horizontal, 20)
    }
}

struct AddPlantView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State var uiImage: UIImage?
    @State var image: Image?
    @State var showCaptureImageView: Bool = false
    
    @State private var name = ""
    @State private var waterFrequency = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                VStack {
                    if image != nil {
                        image?.resizable().frame(width: 100, height: 100).cornerRadius(10)
                    }
                    Button(action: {
                        self.showCaptureImageView.toggle()
                    }) {
                        Text("Choose photos")
                    }.buttonStyle(CustomButtonStyle())
                    
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
                        
                        if let image = self.uiImage {
                            let imageSaver = ImageSaver()
                            if let file = imageSaver.save(image: image) {
                                plant.photo = file
                            }
                            
                        }
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }.buttonStyle(CustomButtonStyle())
                }
                
                
                if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image, uiImage: $uiImage)
                }
            }.navigationBarTitle("Add Plant")
        }
    }
}
