//
//  CollectionContent.swift
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct CollectionContent: View {
    @State var isLoading: Bool = false
    @Environment(\.colorScheme) var colorScheme
    @State private var selectedImage: UIImage?
    @State private var selectedQuantity: String = ""
    @State private var selectedStyle: String = ""
    @State private var selectedSize: String = ""
    @EnvironmentObject var modelData: ModelData
    var isSideBar: Bool = true

    @State private var isPresented = false

    var gridItemLayoutSideBariPhone = [GridItem(.adaptive(minimum: 256), alignment: .center)]
    var gridItemLayoutSideBar = [GridItem(.adaptive(minimum: 50), spacing: 0, alignment: .center)]

    var body: some View {
        GeometryReader { geometry in
            if isSideBar {
                ScrollView(.vertical, showsIndicators: false) {
                    ForEach(modelData.histories) { history in
                        VStack(alignment: .leading, spacing: 5) {
                            VStack(alignment: .leading, spacing: 0) {
                                Text(history.date, format: .dateTime
                                    .hour().minute().day().month().year())
                                Text(history.transcript)
                            }
                            .padding(10)
                            .background(CustomColor.lightOrange)
                            .cornerRadius(4)
                            .foregroundColor(colorScheme == .dark ? .black : .white)

                            LazyVGrid(columns: gridItemLayoutSideBar, spacing: 0) {
                                sequenceImagesSideBar(of: history)
                            }
                        }
                        .padding([.leading, .bottom, .trailing], 10)
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
                .background(.white)
                .padding(.horizontal, 5)
                .fullScreenCover(isPresented: $isPresented) {
                    ImageDetails(
                        quantity: $selectedQuantity,
                        style: $selectedStyle,
                        size: $selectedSize,
                        isLoading: $isLoading,
                        image: $selectedImage
                    )
                }
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVGrid(columns: gridItemLayoutSideBariPhone) {
                        sequenceOfImages()
                    }
                }
                .padding(.horizontal, 5)
                .fullScreenCover(isPresented: $isPresented) {
                    ImageDetails(
                        quantity: $selectedQuantity,
                        style: $selectedStyle,
                        size: $selectedSize,
                        isLoading: $isLoading,
                        image: $selectedImage
                    )
                }
            }
        }
    }

    func sequenceImagesSideBar(of history: History) -> some View {
        ForEach(history.images, id: \.self) { image in
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                .background(.brown)
                .border(.black)
                .onTapGesture {
                    selectedImage = image
                    selectedQuantity = history.quantity
                    selectedStyle = history.style
                    selectedSize = history.size
                    isPresented = true
                }
        }
    }

    func sequenceOfImages() -> some View {
        ForEach(modelData.images, id: \.self) { image in
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 256, height: 256)
                .background(.brown)
                .onTapGesture {
                    selectedImage = image
                    selectedQuantity = modelData.histories.last?.quantity ?? ""
                    selectedStyle = modelData.histories.last?.style ?? ""
                    selectedSize = modelData.histories.last?.size ?? ""
                    isPresented = true
                }
        }
        .padding(.bottom, 20)
    }
}
