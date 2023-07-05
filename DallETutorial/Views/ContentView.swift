import SwiftUI

struct ContentView: View {
    @State private var drawable = Drawable(prompt: "", theme: .indigo)
    @State private var selection: Tab = .canvas
    
    enum Tab {
        case canvas
        case list
    }
    
    var body: some View {
        NavigationView {
            if UIDevice.isIPad {
                CollectionContent(images: [])
//                LandmarkList()
                Panel()
            } else {
                TabView(selection: $selection) {
                    Panel()
                        .tabItem {
                            Label("Canvas", systemImage: "sprinkler.and.droplets.fill")
                        }
                        .tag(Tab.canvas)

                    CollectionContent(images: [])
//                    LandmarkList()
                        .tabItem {
                            Label("History", systemImage: "list.bullet")
                        }
                        .tag(Tab.list)
                }
            }
        }
        .background(Color.clear)
        .navigationBarTitle("")
        .navigationBarHidden(true)
        .navigationBarBackButtonHidden(true)
        .edgesIgnoringSafeArea(.top)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

