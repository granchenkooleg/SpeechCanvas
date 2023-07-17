//
//  ImageDetails.swift
//
//  Created by Oleg Granchenko on 04.07.2023.
//

import SwiftUI

struct ImageDetails: View {
    @State private var tappedBoxes: [Int] = []
    @Binding var quantity: String
    @Binding var style: String
    @Binding var size: String
    @Binding var image: UIImage?
    @Environment(\.dismiss) var dismiss
    let gridSize: Int = 4

    var body: some View {
        ZStack(alignment: .trailing) {
            Color(uiColor: .clear)
                .overlay(alignment: .topTrailing) {

                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "x.circle.fill")
                            .padding(.trailing, 20)
                    }
                    .buttonStyle(.plain)

                    .imageScale(.large)
                    .padding(.top, 45)
                }
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 20) {
                Spacer()

                if let image = image {
                    ZStack {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 400, height: 400)

                        LazyVGrid(columns: createGridColumns(), spacing: 0) {
                            ForEach(0..<gridSize * gridSize, id: \.self) { index in
                                TappableSquare(index: index + 1, tappedBox: $tappedBoxes)
                            }
                        }
                    }
                    .frame(width: 400, height: 400)

                    let shareImage = Image(uiImage: image)
                    ShareLink(item: shareImage, preview: SharePreview("", image: shareImage))

                    Spacer()

                    BottomView(
                        tappedBoxes: tappedBoxes.sorted().map { "\($0)" }.joined(separator: ", "),
                        image: image,
                        quantitySelected: $quantity,
                        styleSelected: $style,
                        sizeSelected: $size
                    )
                    .offset(y: -20)
                }

            }

            SideButtons(
                quantitySelection: $quantity,
                styleSelection: $style,
                sizeSelection: $size
            )
            .offset(y: -170)
        }.keyboardAware()
    }

    private func createGridColumns() -> [GridItem] {
        Array(repeating: GridItem(.flexible(), spacing: 0), count: gridSize)
    }
}

struct TappableSquare: View {
    var index: Int
    @State private var isTapped = false
    @Binding var tappedBox: [Int]

    var body: some View {

        Rectangle()
            .fill(isTapped ? .blue.opacity(0.1) : .blue.opacity(0.0001))
            .frame(width: 100, height: 100)
            .gesture(TapGesture().onEnded { _ in
                isTapped.toggle()
                if isTapped {
                    tappedBox.append(index)
                } else {
                    tappedBox = tappedBox.filter { $0 != index }
                }
            })
    }
}
