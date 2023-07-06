import Foundation
import SwiftUI

struct Drawable: Identifiable {
    var id = UUID()
    var prompt: String
    var size: String
    var quantity: String
    var style: String
    var images: [UIImage]
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
}
