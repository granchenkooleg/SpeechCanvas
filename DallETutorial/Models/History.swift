/*
 See LICENSE folder for this sample’s licensing information.
 */

import Foundation
import UIKit

struct History: Identifiable {
    let id = UUID()
    let date: Date
    var images: [UIImage]
    var transcript: String
    let quantity: String
    let style: String
    let size: String
}
