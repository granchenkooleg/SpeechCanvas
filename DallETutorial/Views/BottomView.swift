//
//  BottomView.swift
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct BottomView: View {
    @State var image: UIImage?
    @Environment(\.dismiss) var dismiss
    @State private var prompt: String = ""
    @Binding var quantitySelected: String
    @Binding var styleSelected: String
    @Binding var sizeSelected: String
    @EnvironmentObject var modelData: ModelData
    @Environment(\.colorScheme) var colorScheme
    @Binding var isLoading: Bool

    private var promptWithSelectedStyle: String {
        prompt + ", with \(styleSelected) style."
    }

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center, spacing: 0) {
                VStack(spacing: 0) {
                    TextField("Enter prompt", text: $prompt, axis: .vertical)
                        .placeholder(when: prompt.isEmpty) {
                            Text("Enter prompt").foregroundColor(.gray)
                        }
                        .lineLimit(5)
                        .autocorrectionDisabled(true)
                        .frame(height: 113)
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding([.horizontal], 16)
                        .background(colorScheme == .light ? .black : .white)
                        .foregroundColor(colorScheme == .dark ? .black : .white)
                        .cornerRadius(16)
                        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.gray))
                    Button {} label: {
                        Text("Actions")
                            .frame(height: 36)
                            .frame(minWidth: 0, maxWidth: .infinity)
                    }
                    .padding(.horizontal, 20)
                    .background(CustomColor.lightOrange)
                    .foregroundColor(colorScheme == .dark ? .black : .white)
                    .cornerRadius(12)
                    .offset(y: -36)
                }

                HStack {
                    Button("Generate") {
                        isLoading = true
                        prompt = ""
                        modelData.images.removeAll()
                        dismiss()
                        Task {
                            if let image = image {
                                try await modelData.generateImage(
                                    for: image.pngData(),
                                    url: URL(string: VoiceDrawEndpoint.editImageURL)!,
                                    with: promptWithSelectedStyle,
                                    quantity: quantitySelected,
                                    style: styleSelected,
                                    size: sizeSelected
                                )
                                isLoading = false
                            } else {
                                try await modelData.generateImage(
                                    url: URL(string: VoiceDrawEndpoint.generateURL)!,
                                    with: promptWithSelectedStyle,
                                    quantity: quantitySelected,
                                    style: styleSelected,
                                    size: sizeSelected
                                )
                                isLoading = false
                            }
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
