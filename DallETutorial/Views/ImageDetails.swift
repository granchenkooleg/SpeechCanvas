//
//  ImageDetails.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 04.07.2023.
//

import SwiftUI

struct ImageDetails: View {
    private let url = URL(string: "https://www.appcoda.com")!
    @State private var quantity: String = "1"
    @State private var style: String = ""
    @State private var size: String = ""
    @State private var isLoading: Bool = false
    @Binding var image: UIImage?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Color(uiColor: .clear)//colorScheme == .light ? .white : .black)
                .overlay(alignment: .topTrailing) {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .padding(.trailing, 20)
                    }
                    .buttonStyle(.plain)

                    .imageScale(.large)
                    .padding(.top, 35)
                }
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                if let image = image {
                    HStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 256, height: 256)

                        let shareImage = Image(uiImage: image)
                        ShareLink(item: shareImage, preview: SharePreview("", image: shareImage))
                    }

                    Button("Save Image") {
                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                    .frame(width: 190, height: 50)
                    .background(colorScheme == .dark ? .white : .black)
                    .foregroundColor(colorScheme == .light ? .white : .black)
                    .controlSize(.large)
                    .cornerRadius(12)
                }

                Spacer()

                BottomView(
                    image: image,
                    quantitySelected: $quantity,
                    styleSelected: $style,
                    sizeSelected: $size,
                    isLoading: $isLoading
                )
                .offset(y: -20)
            }

            SideButtons(
                quantitySelection: $quantity,
                styleSelection: $style,
                sizeSelection: $size
            )
            .offset(y: -170)
        }.keyboardAware()
    }
}
