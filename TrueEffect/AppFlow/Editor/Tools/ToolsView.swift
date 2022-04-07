//
//  EditorView+ToolsView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 06.04.2022.
//

import SwiftUI
import ResizableLine

struct ToolsView: View {

    enum Id: Int {
        case focus
        case aperture
        case effect
    }
    
    @EnvironmentObject
    private var viewModel: EditorView.ViewModel
    private let ruler = Ruler(count: 40, step: 10)

    var body: some View {
        switch viewModel.id {
        case .focus:
            EditableLineView(
                a: 16,
                b: 4,
                rearColor: Color(white: 0.12),
                frontColor: .yellow,
                ruler: ruler,
                leftEnd: $viewModel.focus.rearDistance,
                rightEnd: $viewModel.focus.frontDistance) {
                RulerView(
                    a: 16,
                    majorHeight: 20,
                    minorHeight: 16,
                    ruler: ruler,
                    majorColor: .white,
                    minorColor: Color(white: 1, opacity: 0.5)
                ).background(.black)
            }
            .frame(maxHeight: 40)
            .padding(16)
        case .aperture:
            Color.green
        case .effect:
            Color.red
        }
    }
    
}
