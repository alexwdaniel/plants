//
//  DetailView.swift
//  Plants
//
//  Created by Alexander Daniel on 5/3/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct LabelStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(Color("LightGray"))
            .frame(width: 100, alignment: .leading)
    }
}

struct ValueStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .foregroundColor(Color("Gray"))
    }
}

struct ButtonTextStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .bold, design: .rounded))
            .foregroundColor(Color("Blue"))
    }
}

extension Text {
    func textStyle<Style: ViewModifier>(_ style: Style) -> some View {
        ModifiedContent(content: self, modifier: style)
    }
}

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var plant: Plant
    @State private var showingDeleteAlert = false
    
    static let dateFormat: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d h:mm a"
        return formatter
    }()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if plant.uiImage != nil {
                Image(uiImage: plant.uiImage!).resizable().aspectRatio(contentMode: .fit).frame(maxWidth: .infinity)
            }
            
            Text(plant.name ?? "Unknown").font(.system(size: 24, weight: .bold, design: .rounded)).foregroundColor(Color("Gray")).frame(maxWidth: .infinity, alignment: .center)
            
            Button(action: {
                let watering = Watering(context: self.moc)
                watering.happenedAt = Date()
                self.plant.addToWaterings(watering)
                
                // reset reminder
                Notifications.cancelReminder(plant: self.plant)
                Notifications.water(plant: self.plant)
                
                try? self.moc.save()
            }) {
                Text("WATER").textStyle(ButtonTextStyle()).frame(maxWidth: .infinity, alignment: .center)
            }
            
            Divider()
            
            Group {
                HStack {
                    Text("FREQUENCY").textStyle(LabelStyle())
                    if plant.waterFrequency > 0 {
                        Text("\(plant.waterFrequency) days").textStyle(ValueStyle())
                    } else {
                        Text("-").textStyle(ValueStyle())
                    }
                }
                
                if plant.latestWatering != nil {
                    HStack {
                        Text("WATERED").textStyle(LabelStyle())
                        Text("\(plant.latestWatering!.happenedAt!, formatter: Self.dateFormat)").textStyle(ValueStyle())
                    }
                }
                
                HStack {
                    Text("REMINDER").textStyle(LabelStyle())
                    Button(action: {
                        Notifications.cancelReminder(plant: self.plant)
                    }) {
                        Text("STOP").textStyle(ButtonTextStyle())
                    }
                }
            }.padding([.leading, .trailing], 20)
            
            Spacer()
            
            Group {
                Button(action: {
                    self.showingDeleteAlert = true
                }) {
                    Text("DELETE").textStyle(ButtonTextStyle())
                }
            }.padding([.leading, .trailing], 20)
            
            Spacer()
            
        }.alert(isPresented: $showingDeleteAlert) {
            Alert(title: Text("Delete Plant"), message: Text("Are you sure?"), primaryButton: .destructive(Text("Delete")) {
                self.deletePlant()
                }, secondaryButton: .cancel())
        }
    }
    
    func deletePlant() {
        if let url = self.plant.photo {
            let imageSaver = ImageSaver()
            imageSaver.delete(filename: url)
        }
        // clear notification
        Notifications.cancelReminder(plant: self.plant)
        self.moc.delete(self.plant)
        try? self.moc.save()
        self.presentationMode.wrappedValue.dismiss()
    }
}
