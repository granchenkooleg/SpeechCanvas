import SwiftUI

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var drawable: Drawable
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


                TextField("Enter prompt", text: $drawable.prompt, axis: .vertical)
                    .textFieldStyle(.roundedBorder)


                MeetingView(drawable: $drawable)

                Button("Generate") {
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
                }
                .buttonStyle(.borderedProminent)
            }
            .padding()
        }
        .ignoresSafeArea(.all)
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationStack {
//            ContentView(drawable: .constant(Drawable.sampleData[0]))
//        }
//    }
//}
