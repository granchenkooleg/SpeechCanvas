//
//  ImageDetails.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 04.07.2023.
//

import SwiftUI

struct ImageDetails: View {
    @State var image: String?
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.dismiss) var dismiss

    var body: some View {
        ZStack() {
            Color(uiColor: .clear)//colorScheme == .light ? .white : .black)
                .overlay(alignment: .topTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .imageScale(.large)
                            .padding(.top, 35)
                            .padding(.trailing, 20)
                    }
                    .buttonStyle(.plain)
                }
                .edgesIgnoringSafeArea(.all)

            VStack {
                if let image = image {
                    Image(systemName: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 256, height: 256)

                    Button("Save Image") {
                        //                        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                    }
                }
            }
            .background(.red)
        }
    }
}
