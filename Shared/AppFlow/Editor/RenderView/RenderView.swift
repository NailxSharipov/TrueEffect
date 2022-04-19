//
//  RenderView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 18.04.2022.
//

import SwiftUI
import HotMetal

struct RenderView: View {
    
    @StateObject
    private var viewModel = ViewModel()
    private let projectState: ProjectState
    
    init(projectState: ProjectState) {
        self.projectState = projectState
    }
    
    var body: some View {
        HotMetalView(render: viewModel.render).onAppear() {
            viewModel.projectState = projectState
        }
    }
}
