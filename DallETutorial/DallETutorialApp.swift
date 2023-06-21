// Created by Florian Schweizer on 09.11.22

import SwiftUI

@main
struct DallETutorialApp: App {
    @State private var drawable = Drawable(prompt: "", theme: .indigo)
    var body: some Scene {
        WindowGroup {
            ContentView(drawable: $drawable)
        }
    }
}
