import SwiftUI

@main
struct DallETutorialApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
        }

#if !os(watchOS)
        .commands {
            LandmarkCommands()
        }
#endif

#if os(macOS)
        Settings {
            LandmarkSettings()
        }
#endif
    }
}
