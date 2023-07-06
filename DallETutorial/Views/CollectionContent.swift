//
//  CanvasContent.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct CollectionContent: View {
    @State var selectedSymbol: String = ""
    @EnvironmentObject var modelData: ModelData
    var isSideBar: Bool = true

    @State private var isPresented = false

    var gridItemLayoutSideBariPhone = [GridItem(.adaptive(minimum: 256), alignment: .center)]
    var gridItemLayoutSideBar = [GridItem(.adaptive(minimum: 50), spacing: 0, alignment: .center)]
    
    var body: some View {
        if isSideBar {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
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
        ForEach(modelData.drawable.first?.symbols ?? [], id: \.self) { symbol in
            //        ForEach(images, id: \.self) { image in
                if isSideBar {
                    Image(systemName: symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                        .background(.brown)
                        .border(.black)
                        .onTapGesture {
                            selectedSymbol = symbol
                            isPresented = true
                        }
                } else {
                    Image(systemName: symbol)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 256, height: 256)
                        .cornerRadius(8)
                        .onTapGesture {
                            selectedSymbol = symbol
                            isPresented = true
                        }
                }


            //                Image(uiImage: image)
            //                    .resizable()
            //                    .scaledToFit()
        }
        .fullScreenCover(isPresented: $isPresented) {
            ImageDetails(image: $selectedSymbol)
        }
    }
}
