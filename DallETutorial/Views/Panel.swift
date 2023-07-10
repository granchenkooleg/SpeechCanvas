//
//  Panel.swift
//
//  Created by Oleg Granchenko on 26.06.2023.
//

import SwiftUI

struct Panel: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @Environment(\.colorScheme) var colorScheme
    @State private var quantity: String = "1"
    @State private var style: String = "Pixar"
    @State private var size: String = "256x256"
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                if !modelData.images.isEmpty, !isLoading {
                    CollectionContent(
                        isSideBar: false
                    )
                } else {
                    Rectangle()
                        .fill(.clear)
                        .overlay {
                            if isLoading {
                                VStack {
                                    ProgressView()
                                    Text("Loading...")
                                }
                            }
                        }
                }

                Spacer()
                BottomView(
                    quantitySelected: $quantity,
                    styleSelected: $style,
                    sizeSelected: $size,
                    isLoading: $isLoading
                )
            }
            .padding()
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }

            SideButtons(
                quantitySelection: $quantity,
                styleSelection: $style,
                sizeSelection: $size
            )
                .offset(y: -170)
        }
        .alert("Something wrong ⚠️", isPresented: $modelData.showingAlert) {
                    Button("OK", role: .cancel) { }
                }
    }
}

