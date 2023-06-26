import SwiftUI

struct ContentView: View {
    @State private var drawable = Drawable(prompt: "", theme: .indigo)
    @State private var selection: Tab = .canvas

    enum Tab {
        case canvas
        case list
    }

    var body: some View {
        TabView(selection: $selection) {
            Canvass()
            //            CategoryHome()
                .tabItem {
                    Label("Canvas", systemImage: "sprinkler.and.droplets.fill")
                }
                .tag(Tab.canvas)

            LandmarkList()
                .tabItem {
                    Label("List", systemImage: "list.bullet")
                }
                .tag(Tab.list)
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(ModelData())
//    }
//}



struct Canvass: View {
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ContentView(drawable: .constant(Drawable.sampleData[0]))
//        }
//    }
//}
