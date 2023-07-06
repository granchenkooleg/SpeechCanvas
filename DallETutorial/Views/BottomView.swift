//
//  BottomView.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct BottomView: View {
    @State private var prompt: String = ""
    @Binding var quantity: String
    @Binding var style: String
    @Binding var size: String
    @EnvironmentObject var modelData: ModelData
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading: Bool = false

    private var promptWithSelectedStyle: String {
        prompt + "with \(style) style."
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                TextField("Enter prompt", text: $prompt, axis: .vertical)
                    .placeholder(when: prompt.isEmpty) {
                        Text("Enter prompt").foregroundColor(.gray)
                    }
                    .lineLimit(5)
                    .disableAutocorrection(true)
                    .frame(height: 77)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 16)
                    .background(colorScheme == .light ? .black : .white)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                HStack {
                    Button("Generate") {
                        //                        modelData.images.removeAll()
                        isLoading = true
                        Task {
                            try await modelData.generateImage(
                                url: URL(string: DallEAPI.generateURL)!,
                                with: promptWithSelectedStyle,
                                quantity: quantity,
                                size: size
                            )
                            isLoading = false
                        }
                    }
                    .frame(width: 190, height: 50)
                    .background(CustomColor.mint)
                    .foregroundColor(.black)
                    .controlSize(.large)
                    .cornerRadius(12)

                    ListenerView()
                }
            }
            .frame(width: geometry.size.width * 0.85, height: geometry.size.height, alignment: .bottom)
            .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.85) / 2)
        }
        .frame(height: 135)

    }
}
