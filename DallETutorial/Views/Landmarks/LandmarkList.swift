/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList: View {
//    @State var drawable: Drawable
    @EnvironmentObject var modelData: ModelData
    @State private var showFavoritesOnly = false
    @State private var filter = FilterCategory.all
    @State private var selectedLandmark: Landmark?

    enum FilterCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case lakes = "Lakes"
        case rivers = "Rivers"
        case mountains = "Mountains"

        var id: FilterCategory { self }
    }

    var filteredLandmarks: [Landmark] {
        modelData.landmarks.filter { landmark in
            (!showFavoritesOnly || landmark.isFavorite)
                && (filter == .all || filter.rawValue == landmark.category.rawValue)
        }
    }

    var title: String {
        let title = filter == .all ? "My Pictures" : filter.rawValue
        return showFavoritesOnly ? "Favorite \(title)" : title
    }

    var index: Int? {
        modelData.landmarks.firstIndex(where: { $0.id == selectedLandmark?.id })
    }

    var body: some View {
        NavigationView {
            List(selection: $selectedLandmark) {
                ForEach(filteredLandmarks) { landmark in
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)
                    } label: {
                        LandmarkRow(landmark: landmark)
                    }
                    .tag(landmark)
                }
            }
            .navigationTitle(title)
            .frame(minWidth: 300)
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker("Category", selection: $filter) {
                            ForEach(FilterCategory.allCases) { category in
                                Text(category.rawValue).tag(category)
                            }
                        }
                        .pickerStyle(.inline)
                        
                        Toggle(isOn: $showFavoritesOnly) {
                            Label("Favorites only", systemImage: "star.fill")
                        }
                    } label: {
                        Label("Filter", systemImage: "slider.horizontal.3")
                    }
                }
            }

            #if os(macOS)
            MacPanel()
            #endif
        }
//        .focusedValue(\.selectedLandmark, $modelData.landmarks[index ?? 0])
    }
}

//struct LandmarkList_Previews: PreviewProvider {
//    static var previews: some View {
//        LandmarkList()
//            .environmentObject(ModelData())
//    }
//}

//struct Canvass: View {
//    @Environment(\.colorScheme) var colorScheme
//    @State var drawable: Drawable = Drawable(prompt: "Prompt", theme: .bubblegum)
//    //    @State private var prompt: String = ""
//    @State private var image: UIImage? = nil
//    @State private var isLoading: Bool = false
//
//    var body: some View {
//        ZStack(alignment: .center) {
//            Color(uiColor: colorScheme == .light ? .white : .black)
//            VStack {
//                Spacer()
//                VStack {
//                    if let image {
//                        Image(uiImage: image)
//                            .resizable()
//                            .scaledToFit()
//
//                        Button("Save Image") {
//                            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
//                        }
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
//                }
//                .frame(width: 256, height: 256)
//                Spacer()
//
//                HStack {
////                    ListenerView(drawable: $drawable)
//                    Button {
//                        isLoading = true
//                        Task {
//                            do {
//                                //let response = try await DallEImageGenerator.shared.generateImage(withPrompt: drawable.title, apiKey: Secrets.apiKey)
//
//                                if let url = URL(string: "https://www.gstatic.com/webp/gallery3/2_webp_ll.png") {  //response.data.map(\.url).first {
//                                    let (data, _) = try await URLSession.shared.data(from: url)
//
//                                    image = UIImage(data: data)
//                                    isLoading = false
//                                }
//                            } catch {
//                                print(error)
//                            }
//                        }
//                    } label: {
//                        Image(systemName: "arrow.up")
//                            .frame(width: 1)
//                            .foregroundStyle(.white)
//                            .padding()
//                            .background(.blue)
//                            .clipShape(Circle())
//
//                    }
//                }
//
//            }
//            .padding()
//        }
//        .ignoresSafeArea(edges: .top)
//    }
//}
