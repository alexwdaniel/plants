//
//  DetailView.swift
//  Plants
//
//  Created by Alexander Daniel on 5/3/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

struct DetailView: View {
        
    @State var plant: Plant    
    @State private var bottomSheetShown = false        
    
    var body: some View {                        
        GeometryReader { geometry in
            if self.plant.uiImage != nil {
                Image(uiImage: self.plant.uiImage!).resizable().aspectRatio(nil, contentMode: .fill).position(CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2))
            } else {
                Color("Pink")
            }
            
            BottomSheetView(
                isOpen: self.$bottomSheetShown,
                maxHeight: geometry.size.height * 0.7
            ) {
                DetailSheetView(plant: self.plant)
            }
        }.edgesIgnoringSafeArea(.all)
    }
}
