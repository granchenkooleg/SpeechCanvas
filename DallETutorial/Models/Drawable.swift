import Foundation
import SwiftUI

struct Drawable: Identifiable, Codable {
    let id: UUID
    var prompt: String
//    var title: String
//    var lengthInMinutes: Int
//    var lengthInMinutesAsDouble: Double { // length of characters
//        get {
//            Double(lengthInMinutes)
//        }
//        set {
//            lengthInMinutes = Int(newValue)
//        }
//    }
    var theme: Theme
    var history: [History] = []
    
    init(id: UUID = UUID(), prompt: String, theme: Theme) {
        self.id = id
        self.prompt = prompt
//        self.title = title
//        self.lengthInMinutes = lengthInMinutes
        self.theme = theme
    }
}

//extension Drawable {
//    static let sampleData: [Drawable] =
//    [
//        Drawable(title: "Design",
//                   lengthInMinutes: 10,
//                   theme: .yellow),
//        Drawable(title: "App Dev",
//                   lengthInMinutes: 5,
//                   theme: .orange),
//        Drawable(title: "Web Dev",
//                   lengthInMinutes: 5,
//                   theme: .poppy)
//    ]
//}
