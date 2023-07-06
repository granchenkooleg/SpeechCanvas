//
//  CanvasContent.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct CollectionContent: View {
    @State private var selectedImage: UIImage?
    @EnvironmentObject var modelData: ModelData
    var isSideBar: Bool = true

    @State private var isPresented = false

    var gridItemLayoutSideBariPhone = [GridItem(.adaptive(minimum: 256), alignment: .center)]
    var gridItemLayoutSideBar = [GridItem(.adaptive(minimum: 50), spacing: 0, alignment: .center)]

    var body: some View {
        if isSideBar {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(modelData.histories) { history in
                    VStack(alignment: .leading, spacing: 5) {
                        VStack(spacing: 0) {
                            Text(history.date, format: .dateTime.day().month().year())
                            Text(history.transcript)
                        }
                        LazyVGrid(columns: gridItemLayoutSideBar, spacing: 0) {
                            sequenceImagesSideBar(of: history)
                        }
                    }
                    .padding(.bottom, 10)
                }
            }
            .padding(.horizontal, 5)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridItemLayoutSideBariPhone) {
                    sequenceOfImages()
                }
            }
            .padding(.horizontal, 5)
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
                        isPresented = true
                    }
            }
        .fullScreenCover(isPresented: $isPresented) {
            ImageDetails(image: $selectedImage)
        }
    }

    func sequenceOfImages() -> some View {
        ForEach(modelData.images, id: \.self) { image in
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .frame(width: 256, height: 256)
                .cornerRadius(8)
                .background(.brown)
                .onTapGesture {
                    selectedImage = image
                    isPresented = true
                }
        }
        .fullScreenCover(isPresented: $isPresented) {
            ImageDetails(image: $selectedImage)
        }
    }
}
