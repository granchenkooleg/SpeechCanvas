//
//  Panel.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 26.06.2023.
//

import SwiftUI

struct Panel: View {
    @AppStorage("imageURL") private var imageData: Data?
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @Environment(\.colorScheme) var colorScheme
    @State var drawable: Drawable = Drawable(prompt: "", theme: .bubblegum)
    @State private var size: String = "256x256"
    @State private var quantity: String = "1"
    @State private var image: UIImage?
    @State private var images: [UIImage] = []
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                //                    if !images.isEmpty, !isLoading {
                CanvasContent(
                    drawable: drawable,
                    isSideBar: false,
                    images: images
                )

                //                    } else {
                //                        Rectangle()
                //                            .fill(.clear)
                //                            .overlay {
                //                                if isLoading {
                //                                    VStack {
                //                                        ProgressView()
                //                                        Text("Loading...")
                //                                    }
                //                                }
                //                            }
                //                    }

                Spacer()
                BottomView(
                    size: $size,
                    quantity: $quantity,
                    drawable: $drawable,
                    isLoading: $isLoading,
                    imageData: $imageData,
                    image: $image,
                    images: $images
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
            //            .ignoresSafeArea(edges: .top)

            SideBarButtons()
                .offset(y: -170)
        }
    }
}

