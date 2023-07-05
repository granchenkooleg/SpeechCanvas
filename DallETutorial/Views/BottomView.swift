//
//  BottomView.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct BottomView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var size: String
    @Binding var quantity: String
    @Binding var drawable: Drawable
    @Binding var isLoading: Bool
    @Binding var imageData: Data?
    @Binding var image: UIImage?
    @Binding var images: [UIImage]

    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .center) {
                TextField("Enter prompt", text: $drawable.prompt, axis: .vertical)
                    .placeholder(when: drawable.prompt.isEmpty) {
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
                        images.removeAll()
                        isLoading = true
                        Task {
                            do {
                                let response = try await DallEImageGenerator.shared.generateImage(
                                    url: URL(string: "http://74.235.97.111/api/generate/")!,
                                    withPrompt: drawable.prompt,
                                    quantity: quantity,
                                    size: size
                                )

                                for data in response.data {
                                    let (data, _) = try await URLSession.shared.data(from: data.url)
                                    imageData = data

                                    images.append(UIImage(data: data)!)

                                    isLoading = false
                                    drawable.prompt = ""
                                }
                            } catch {
                                print(error)
                            }
                        }
                    }
                    .frame(width: 190, height: 50)
                    .background(CustomColor.mint)
                    .foregroundColor(.black)
                    .controlSize(.large)
                    .cornerRadius(12)

                    ListenerView(drawable: $drawable)
                }
            }
            .frame(width: geometry.size.width * 0.85, height: geometry.size.height, alignment: .bottom)
            .padding(.horizontal, (geometry.size.width - geometry.size.width * 0.85) / 2)
        }
        .frame(height: 135)

    }
}
