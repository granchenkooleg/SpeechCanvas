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
                VStack(alignment: .leading, spacing: 10) {
                    Text(Date.now, format: .dateTime.day().month().year())
                    Text(modelData.drawable.first?.prompt ?? "")
                    LazyVGrid(columns: gridItemLayoutSideBar, spacing: 0) {
                        sequenceOfImages()
                    }
                }
            }
            .padding(.trailing, 16)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridItemLayoutSideBariPhone) {
                    sequenceOfImages()
                }
            }
            .padding(.horizontal, 16)
        }
    }

    func sequenceOfImages() -> some View {
        ForEach(modelData.images, id: \.self) { image in
            if isSideBar {
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
            } else {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
                    .cornerRadius(8)
                    .onTapGesture {
                        selectedImage = image
                        isPresented = true
                    }
            }
        }
        .fullScreenCover(isPresented: $isPresented) {
            ImageDetails(image: $selectedImage)
        }
    }
}
