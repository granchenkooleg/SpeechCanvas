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
        ZStack(alignment: .bottomTrailing) {
            VStack {
                //                    if !images.isEmpty, !isLoading {
                CanvasContent(
                    drawable: drawable,
                    isSideBar: false,
                    images: images
                )
                
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
            //            .ignoresSafeArea(edges: .top)
            
            SideBarButtons()
                .offset(y: -170)
        }
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
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))
            
            Picker("", selection: $selection) {
                ForEach(styles.sorted(by: >), id: \.key) { style in
                    HStack {
                        Image(systemName: style.value)
                        Text(style.key)
                        
                        
                    }
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))
            
            Picker("", selection: $sizeSelection) {
                ForEach(sizes, id: \.self) {
                    Text($0)
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))
        }
        .accentColor(colorScheme == .dark ? .white : .black)
        .pickerStyle(.menu)
        .padding(.horizontal, 8)
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

struct CanvasContent: View {
    @State var drawable: Drawable?
    var isSideBar: Bool = true
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
    
    var gridItemLayout = [GridItem(.adaptive(minimum: 256), alignment: .center)]
    var gridItemLayoutSideBar = [GridItem(.adaptive(minimum: 50), spacing: 0, alignment: .center)]
    //    var threeColumnGrid: [GridItem] = Array(repeating: .init(.flexible()), count: 3)
    var images: [UIImage]
    var body: some View {
        if isSideBar {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(drawable?.prompt ?? "Prompt, prompt, prompt")
                    LazyVGrid(columns: gridItemLayoutSideBar, spacing: 0) {
                        sequenceOfImages()
                    }
                }
            }
        } else {
            ScrollView(.vertical, showsIndicators: false) {
                LazyVGrid(columns: gridItemLayout) {
                    sequenceOfImages()
                }
            }
            .padding(.horizontal, 16)
        }
        
    }
    
    func sequenceOfImages() -> some View {
        ForEach(symbols, id: \.self) { symbol in
            //        ForEach(images, id: \.self) { image in
            if isSideBar {
                Image(systemName: symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50)
                    .background(.brown)
                    .border(.black)
                //                        .padding()
            } else {
                Image(systemName: symbol)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
                    .cornerRadius(8)
            }
            
            
            //                Image(uiImage: image)
            //                    .resizable()
            //                    .scaledToFit()
            //                                Button("Save Image") {
            //                    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
            //                                }
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

