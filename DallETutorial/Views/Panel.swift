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
    @State private var size: String = "256x256"
    @State private var quantity: String = "1"
    @State private var image: UIImage?
    @State private var images: [UIImage] = []
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack(alignment: .trailing) {
            VStack {
//                    if !images.isEmpty, !isLoading {
                    CanvasContent(images: images)
//                    } else {
//                        Rectangle()
//                            .fill(.clear)
//                            .overlay {
//                                if isLoading {
//                                    VStack {
//                                        ProgressView()
//                                        Text("Loading...")
//                                    }
//                                }
//                            }
//                    }

//                SideBarButtons()
//                    .offset(y: -100)

                Spacer()
                BottomView(
                    size: $size,
                    quantity: $quantity,
                    drawable: $drawable,
                    isLoading: $isLoading,
                    imageData: $imageData,
                    image: $image,
                    images: $images
                )
            }
            .padding()
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

struct SideBarButtons: View {
    @State private var quantitySelection = "2"
    let quantity = [
        "1","2","3","4","5","6","7","8","9","10"
    ]

    @State private var selection = "Pixar"
    @State private var styles = [
        "Pixar": "figure.american.football",
        "Surrealism": "figure.archery",
        "Pointillism": "figure.australian.football",
        "Pop Art": "figure.badminton",
        "Abstract Expressionism": "figure.barre",
        "Fauvism": "figure.baseball",
        "Realism": "figure.basketball",
        "Romanticism": "figure.bowling",
        "Symbolism": "figure.boxing"]
    //        "Minimalism",
    //        "Post-Impressionism",
    //        "Art Nouveau",
    //        "Expressionism",
    //        "Constructivism",
    //        "Dadaism",
    //        "Renaissance",
    //        "Baroque",
    //        "Rococo",
    //        "Neoclassicism",
    //        "Abstract Art",
    //        "Op Art",
    //        "Photorealism",
    //        "Street Art",
    //        "Conceptual Art"]

    @State private var sizeSelection = "2"
    let sizes = [
        "256x256","512x512","1024x1024"
    ]
    //    @State private var selection1: String = "4"
    //    @State private var selection: String = "Pixar"
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .trailing) {
            Picker("", selection: $quantitySelection) {
                ForEach(quantity, id: \.self) {
                    Text($0)
                }
            }

            Picker("", selection: $selection) {
                ForEach(styles.sorted(by: >), id: \.key) { style in
                    HStack {
                        Image(systemName: style.value)
                        Text(style.key)


                    }
                }
            }

            Picker("", selection: $sizeSelection) {
                ForEach(sizes, id: \.self) {
                    Text($0)
                }
            }
        }
        .accentColor(colorScheme == .dark ? .white : .black)
        .pickerStyle(.menu)
//        .padding(.trailing, 16)
    }
}

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
        VStack {
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
    }
}

struct CanvasContent: View {
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

    var gridItemLayout = [GridItem(.adaptive(minimum: 256))]
//    var threeColumnGrid: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var images: [UIImage]
    var body: some View {
        ScrollView(.vertical) {
            LazyVGrid(columns: gridItemLayout, spacing: 5) {
                sequenceOfImages()
            }
//            .padding(200)
        }
    }

    func sequenceOfImages() -> some View {
        ForEach(symbols, id: \.self) { symbol in
//        ForEach(images, id: \.self) { image in
            VStack {
                Image(systemName: symbol)
                    .resizable()
                    .scaledToFit()
//                    .frame(height: 150)
                    .cornerRadius(8)


//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//                Button("Save Image") {
//                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                }
            }
            .padding()
//            .frame(width: 256, height: 256)
        }
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

            ZStack(alignment: alignment) {
                placeholder().opacity(shouldShow ? 1 : 0)
                self
            }
        }
}

