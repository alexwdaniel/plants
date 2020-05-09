//
//  DetailView.swift
//  Plants
//
//  Created by Alexander Daniel on 5/3/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct DetailView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    @State var plant: Plant
    @State private var showingDeleteAlert = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            if plant.uiImage != nil {
                Image(uiImage: plant.uiImage!).resizable().aspectRatio(contentMode: .fit)
            }
            Group {
                Text(plant.name ?? "Unknown").font(.system(size: 24, weight: .bold, design: .rounded))
                if plant.waterFrequency > 0 {
                    Text("💦 Water every \(plant.waterFrequency) days.").font(.system(size: 18, weight: .semibold, design: .rounded))
                }
                Button(action: {
                    // clear notification
                    Notifications.cancelReminder(plant: self.plant)
                }) {
                    Text("Stop Reminder")
                }
            }.padding([.leading, .trailing], 20)
            Spacer()
            Group {
                Button(action: {
                    self.showingDeleteAlert = true
                }) {
                    Text("Delete").foregroundColor(Color.red)
                }
            }.padding([.leading, .trailing], 20)
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
