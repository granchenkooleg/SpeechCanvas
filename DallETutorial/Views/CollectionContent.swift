//
//  CanvasContent.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct CollectionContent: View {
    @State var selectedSymbol: String = ""
    @State var drawable: Drawable?
    var isSideBar: Bool = true
    var symbols = [
        "keyboard",
        "hifispeaker.fill",
        "printer.fill",
        "tv.fill",
        "desktopcomputer",
        "headphones",
        "tv.music.note",
        "mic",
        "plus.bubble",
        "video"
    ]

    @State private var isPresented = false

    var gridItemLayoutiPhone = [GridItem(.adaptive(minimum: 256), alignment: .center)]
    var gridItemLayoutSideBar = [GridItem(.adaptive(minimum: 50), spacing: 0, alignment: .center)]
    //    var threeColumnGrid: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var images: [UIImage]
    var body: some View {
        if isSideBar {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(drawable?.prompt ?? "Prompt, prompt, prompt")
                    LazyVGrid(columns: gridItemLayoutSideBar, spacing: 0) {
                        sequenceOfImages()
                    }
                }
            }
            .padding(.trailing, 16)
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridItemLayoutiPhone) {
                    sequenceOfImages()
                }
            }
            .padding(.horizontal, 16)
        }
    }

    func sequenceOfImages() -> some View {
        ForEach(symbols, id: \.self) { symbol in
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
