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
            .cornerRadius(7)
    }
}

struct AddPlantView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var uiImage: UIImage?
    @State private var image: Image?
    @State private var showCaptureImageView: Bool = false
    @State private var createReminder: Bool = false
    
    @State private var name = ""
    @State private var waterFrequency = ""
    @State private var notes = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(alignment: .leading, spacing: 20) {
                        Text("Add a\nnew plant").font(.system(size: 36, weight: .bold, design: .rounded)).frame(alignment: .leading)
                        if image != nil {
                            image?.resizable().frame(width: 120, height: 160).cornerRadius(7)
                        } else {
                            Button(action: {
                                self.showCaptureImageView.toggle()
                            }) {
                                Image(systemName: "photo").padding([.top, .bottom], 80).padding([.leading, .trailing], 60).overlay(
                                    RoundedRectangle(cornerRadius: 7)
                                        .stroke(Color.gray, lineWidth: 1)
                                )
                                Text("Choose a photo")
                            }
                        }
                        
                        TextField("What is the plant's name?", text: $name).padding(15).overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        TextField("How often does it like water?", text: $waterFrequency)
                            .padding(15).overlay(
                                RoundedRectangle(cornerRadius: 7)
                                    .stroke(Color.gray, lineWidth: 1)
                        )
                            .keyboardType(.numberPad)
                            .onReceive(Just(waterFrequency)) { newValue in
                                let filtered = newValue.filter { "0123456789".contains($0) }
                                if filtered != newValue {
                                    self.waterFrequency = filtered
                                }
                        }
                        
                        Group {
                            Toggle(isOn: $createReminder) {
                                Text("Need a reminder?")
                            }
                            Button(action: {
                                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
                                    if success {
                                        print("All set!")
                                    } else if let error = error {
                                        print(error.localizedDescription)
                                    }
                                }
                            }) {
                                Text("Give Permission")
                            }
                        }
                        
                        
                        TextField("Any other notes about it?", text: $notes).padding(15).overlay(
                            RoundedRectangle(cornerRadius: 7)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        
                        Spacer()
                        Button("Add") {
                            let plant = Plant(context: self.moc)
                            plant.name = self.name
                            if let frequency = Int16(self.waterFrequency) {
                                plant.waterFrequency = frequency
                            }
                            plant.notes = self.notes
                            plant.createdAt = Date()
                            plant.id = UUID()
                            
                            if let image = self.uiImage {
                                let imageSaver = ImageSaver()
                                if let file = imageSaver.save(image: image) {
                                    plant.photo = file
                                }
                                
                            }
                            try? self.moc.save()
                            
                            if self.createReminder {
                                Notifications.water(plant: plant)
                            }
                            
                            self.presentationMode.wrappedValue.dismiss()
                        }.buttonStyle(CustomButtonStyle())
                    }.padding([.leading, .trailing], 20)
                    
                    
                    
                }.navigationBarItems(trailing: Button(action: {
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "xmark.circle")
                        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/).foregroundColor(Color.black)
                    }).adaptiveKeyboard()
                
                if (showCaptureImageView) {
                    CaptureImageView(isShown: $showCaptureImageView, image: $image, uiImage: $uiImage)
                }
            }
        }
    }
}

struct AddPlantView_Previews: PreviewProvider {
    static var previews: some View {
        AddPlantView()
    }
}
