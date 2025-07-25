//
//  Panel.swift
//
//  Created by Oleg Granchenko on 26.06.2023.
//

import SwiftUI

struct Panel: View {
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @State private var quantity: String = "1"
    @State private var style: String = "Pixar"
    @State private var size: String = "256x256"

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack {
                if !modelData.images.isEmpty, !modelData.isLoading {
                    CollectionContent(
                        isSideBar: false
                    )
                } else {
                    Rectangle()
                        .fill(.clear)
                        .overlay {
                            if modelData.isLoading {
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
                    sizeSelected: $size
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
        .alert(Text(modelData.descriptionAlert ?? "Something wrong ⚠️"), isPresented: $modelData.showingAlert) {
            Button("OK", role: .cancel) {
                modelData.isLoading = false
            }
        }
    }
}

