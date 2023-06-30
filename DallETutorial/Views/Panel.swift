//
//  Panel.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 26.06.2023.
//

import SwiftUI

struct Panel: View {
    @AppStorage("imageURL") private var imageData: Data?
    @EnvironmentObject var modelData: ModelData
    @State private var showingProfile = false
    @Environment(\.colorScheme) var colorScheme
    @State var drawable: Drawable = Drawable(prompt: "", theme: .bubblegum)
    //    @State private var prompt: String = ""
    @State private var image: UIImage?
    @State private var images: [UIImage] = []
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack(alignment: .center) {
            Color(uiColor: colorScheme == .light ? .white : .black)
            VStack {
                Spacer()
                VStack {
                    if !images.isEmpty, !isLoading {
                        CanvasContent(images: images)
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

                Spacer()
                BottomView(
                    drawable: $drawable,
                    isLoading: $isLoading,
                    imageData: imageData,
                    image: $image,
                    images: $images
                )
            }
            .padding()
            .navigationTitle("Canvas")
            .toolbar {
                Button {
                    showingProfile.toggle()
                } label: {
                    Label("User Profile", systemImage: "person.crop.circle")
                }
            }
            .sheet(isPresented: $showingProfile) {
                ProfileHost()
                    .environmentObject(modelData)
            }
        }
        .ignoresSafeArea(edges: .top)
    }
}

struct BottomView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var drawable: Drawable
    @Binding var isLoading: Bool
    var imageData: Data?
    @Binding var image: UIImage?
    @Binding var images: [UIImage]

    var body: some View {
        VStack {
            TextField("Enter prompt", text: $drawable.prompt, axis: .vertical)
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
                Button("Edit") {
                    isLoading = true
                    Task {
                        do {
                            let response = try await DallEImageGenerator.shared.generateImage(
                                forEditImage: imageData,
                                url: URL(string: "http://74.235.97.111/api/edit/")!,
                                withPrompt: drawable.prompt,
                                quantity: "1",
                                size: "256x256"
                            )

                            if let url = response.data.map(\.url).first {
                                let (data, _) = try await URLSession.shared.data(from: url)

                                image = UIImage(data: data)
                                isLoading = false
                                drawable.prompt = ""
                            }
                        } catch {
                            print(error)
                        }
                    }
                }
                .frame(width: 50, height: 50)
                .background(colorScheme == .light ? .black : .white)
                .foregroundColor(colorScheme == .dark ? .black : .white)
                .cornerRadius(12)

                Button("Generate") {
                    isLoading = true
                    Task {
                        do {
                            let response = try await DallEImageGenerator.shared.generateImage(
                                url: URL(string: "http://74.235.97.111/api/generate/")!,
                                withPrompt: drawable.prompt,
                                quantity: "4",
                                size: "256x256"
                            )

                            for data in response.data {
                                let (data, _) = try await URLSession.shared.data(from: data.url)
                                //                                                                                            imageData = data

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
    }
}

struct CanvasContent: View {
    var images: [UIImage]
    var body: some View {
        if UIDevice.isIPad {
            ScrollView(.horizontal) {
                LazyHStack(spacing: 5) {
                    sequenceOfImages()
                }
            }
        } else {
            ScrollView(.vertical) {
                LazyVStack(spacing: 5) {
                    sequenceOfImages()
                }
            }
        }

    }

    func sequenceOfImages() -> some View {
        ForEach(images, id: \.self) { image in
            VStack {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                Button("Save Image") {
                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
                }
            }
            .frame(width: 256, height: 256)
        }
    }
}
