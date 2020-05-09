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
        VStack(alignment: .center) {
            GeometryReader { geo in
                if self.plant.uiImage != nil {
                    Image(uiImage: self.plant.uiImage!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: geo.size.width, height: geo.size.height)
                        .cornerRadius(7)
                        .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 8)
                } else {
                    Spacer()
                    Image(systemName: "p.circle")
                    Spacer()
                }
            }
            Text(self.plant.name ?? "Unnamed").font(.system(size: 16, weight: .heavy, design: .rounded))
        }.padding([.leading, .trailing], 8)
    }
}
