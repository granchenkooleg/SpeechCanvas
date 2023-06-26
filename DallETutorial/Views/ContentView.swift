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
            Panel()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}

