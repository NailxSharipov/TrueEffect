//
//  EditorView.swift
//  TrueEffect
//
//  Created by Nail Sharipov on 02.04.2022.
//

import SwiftUI

struct EditorView: View {

    @StateObject
    private var viewModel = ViewModel(projectStore: ServiceLayer.shared.projectStore)
    
    private let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    var body: some View {
        ZStack {
            if viewModel.projectState.isReady {
                VStack() {
                    RenderView(projectState: viewModel.projectState)
                    ToolsView().padding(8)
                }
            }
            if viewModel.isProgress {
                ProgressView().frame(alignment: .center)
            }
        }
        .onAppear() {
            viewModel.onAppear()
        }
        .task {
            await viewModel.load(fileName: fileName)
        }
        .navigationTitle("Editor")
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("", action: { debugPrint("Cancel") })
            }
            ToolbarItem(placement: .primaryAction) {
                Button("Save") {
                    Task {
                        await viewModel.save()
                    }
                }
            }
            ToolbarItemGroup(placement: .bottomBar) {
                HStack {
                    ForEach(viewModel.topBarItems, id: \.self) { item in
                        ToolsView.TopBarItemView(viewModel: item)
                            .onTapGesture() {
                                viewModel.onTapTopBar(id: item.id)
                            }
                    }
                }
            }
        }.environmentObject(viewModel)
    }
    
}
