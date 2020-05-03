//
//  CollectionView.swift
//  Plants
//
//  Created by Alex Daniel on 4/19/20.
//  Copyright © 2020 adaniel. All rights reserved.
//

import SwiftUI

extension Array {
    func chunk(size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            return Array(self[$0..<Swift.min($0 + size, count)])
        }
    }
}

extension Array: Identifiable where Element: Identifiable {
    public var id: String {
        let result =  map({ "\($0.id)" }).joined(separator: ":")
        return result
    }
}

struct CollectionView<Content: View>: View {
    @State var width = 2
    @State var spacing: CGFloat = 0
    let contentRatio: CGFloat = 3 / 2
    
    @Binding var items: [Plant];
    let content: (Plant) -> Content

    var body: some View {
        GeometryReader { proxy in
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading) {
                    ForEach(self.items.chunk(size: self.width), id: \.self) { row in
                        HStack(alignment: .center, spacing: self.spacing) {
                            ForEach(row, id: \.self) { item in
                                self.content(item)
                                    .frame(
                                        width: proxy.frame(in: .local).width / CGFloat(self.width) - self.spacing,
                                        height: proxy.frame(in: .local).width * self.contentRatio / CGFloat(self.width) - self.spacing
                                )
                            }
                        }
                    }
                }
            }
        }
    }
}

