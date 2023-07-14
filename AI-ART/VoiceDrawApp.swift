import SwiftUI

@main
struct VoiceDrawApp: App {
    @StateObject private var modelData = ModelData()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(modelData)
                .onAppear(perform: UIApplication.shared.addTapGestureRecognizer)
        }
    }
}
