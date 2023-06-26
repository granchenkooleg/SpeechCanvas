//
//  Panel.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 26.06.2023.
//

import SwiftUI

struct Panel: View {
    @Environment(\.colorScheme) var colorScheme
    @State var drawable: Drawable = Drawable(prompt: "", theme: .bubblegum)
    //    @State private var prompt: String = ""
    @State private var image: UIImage? = nil
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            Color(uiColor: colorScheme == .light ? .white : .black)
            VStack {
                Spacer()
                VStack {
                    if let image {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()

                        Button("Save Image") {
                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                        }
                    } else {
                        Rectangle()
                            .fill(.clear)
                            .overlay {
                                if isLoading {
                                    VStack {
                                        ProgressView()
                                        Text("Loading...")
                                    }
                                }
                            }
                    }
                }
                .frame(width: 256, height: 256)
                Spacer()

                HStack {
                    ListenerView(drawable: $drawable)
                    Button {
                        isLoading = true
                        Task {
                            do {
                                //let response = try await DallEImageGenerator.shared.generateImage(withPrompt: drawable.title, apiKey: Secrets.apiKey)

                                if let url = URL(string: "https://www.gstatic.com/webp/gallery3/2_webp_ll.png") {  //response.data.map(\.url).first {
                                    let (data, _) = try await URLSession.shared.data(from: url)

                                    image = UIImage(data: data)
                                    isLoading = false
                                }
                            } catch {
                                print(error)
                            }
                        }
                    } label: {
                        Image(systemName: "arrow.up")
                            .frame(width: 1)
                            .foregroundStyle(.white)
                            .padding()
                            .background(.blue)
                            .clipShape(Circle())

                    }
                }

            }
            .padding()
        }
        .ignoresSafeArea(edges: .top)
    }
}
