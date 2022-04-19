//
//  ToolsView+TopBarItemView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 05.04.2022.
//

import SwiftUI

extension ToolsView {
    
    struct TopBarItemView: View {
        
        struct ViewModel: Identifiable {
            
            let id: Id
            let title: String
            let image: Image
            let color: Color
            let fontWeight: Font.Weight
        }
        
        @State var viewModel: ViewModel
        
        var body: some View {
            VStack {
                viewModel.image
                    .foregroundColor(viewModel.color)
                Text(viewModel.title)
                    .font(.callout)
                    .fontWeight(viewModel.fontWeight)
                    .foregroundColor(viewModel.color)
                    .padding(.top, 4)
            }.frame(maxWidth: .infinity)
        }
        
    }
}


extension ToolsView.TopBarItemView.ViewModel: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
        && lhs.color == rhs.color
        && lhs.fontWeight == rhs.fontWeight
    }
}
