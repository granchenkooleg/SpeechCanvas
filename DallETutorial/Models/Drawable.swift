import Foundation
import SwiftUI

struct Drawable: Identifiable, Codable {
    let id: UUID
    var prompt: String
    var size: String
    var quantity: String
    var style: Style
//    var images: [UIImage] = []
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

    init(id: UUID = UUID(), prompt: String, size: String, quantity: String, style: Style) {
        self.id = id
        self.prompt = prompt
        self.size = size
        self.quantity = quantity
        self.style = style
    }
}
