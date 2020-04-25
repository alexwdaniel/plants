//
//  PlantView.swift
//  Plants
//
//  Created by Alex Daniel on 4/24/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct PlantView: View {
    
    var plant: Plant
    
    var body: some View {
        VStack {
            if plant.uiImage != nil {
                Image(uiImage: plant.uiImage!).resizable().cornerRadius(10).shadow(radius: 10)
            } else {
                Spacer()
                Image(systemName: "p.circle")
                Spacer()
            }
            Text(plant.name ?? "Unnamed")
        }
    }
}
