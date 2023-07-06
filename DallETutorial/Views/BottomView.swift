//
//  BottomView.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct BottomView: View {
    @State private var prompt: String = ""
    @Binding var quantitySelected: String
    @Binding var styleSelected: String
    @Binding var sizeSelected: String
    @EnvironmentObject var modelData: ModelData
    @Environment(\.colorScheme) var colorScheme
    @Binding var isLoading: Bool

    private var promptWithSelectedStyle: String {
        prompt + "with \(styleSelected) style."
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                TextField("Enter prompt", text: $prompt, axis: .vertical)
                    .placeholder(when: prompt.isEmpty) {
                        Text("Enter prompt").foregroundColor(.gray)
                    }
                    .lineLimit(5)
                    .autocorrectionDisabled(true)
                    .frame(height: 77)
                    .textFieldStyle(PlainTextFieldStyle())
                    .padding([.horizontal], 16)
                    .background(colorScheme == .light ? .black : .white)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .cornerRadius(16)
                    .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                HStack {
                    Button("Generate") {
                        modelData.images.removeAll()
                        isLoading = true
                        Task {
                            try await modelData.generateImage(
                                url: URL(string: DallEAPI.generateURL)!,
                                with: promptWithSelectedStyle,
                                quantity: quantitySelected,
                                style: styleSelected,
                                size: sizeSelected
                            )
                            isLoading = false
                        }
                    }
                    .disabled(prompt.isEmpty)
                    .frame(width: 190, height: 50)
                    .background(prompt.isEmpty ? Color(UIColor.systemGray5) : CustomColor.mint)
                    .foregroundColor(prompt.isEmpty ? Color(UIColor.systemGray3) : .black)
                    .controlSize(.large)
                    .cornerRadius(12)

                    ListenerView(prompt: $prompt)
                }
            }
            .frame(width: geometry.size.width * 0.85, height: geometry.size.height, alignment: .bottom)
            .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.85) / 2)
        }
        .frame(height: 135)

    }
}
