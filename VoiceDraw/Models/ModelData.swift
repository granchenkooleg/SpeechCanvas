/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Storage for model data.
 */

import Foundation
import Combine
import SwiftUI

final class ModelData: ObservableObject {
    @Published var isLoading = false
    @Published var showingAlert = false
    @Published var images: [UIImage] = [
//                UIImage(systemName: "figure.stand.line.dotted.figure.stand")!, UIImage(systemName: "figure.roll")!, UIImage(systemName: "mic")!, UIImage(systemName: "cursorarrow.motionlines.click")!
    ]
    @Published var histories: [History] = [
//                History(
//                    date: Date.now,
//                    images: [UIImage(systemName: "figure.stand.line.dotted.figure.stand")!, UIImage(systemName: "figure.roll")!, UIImage(systemName: "mic")!],
//                    transcript: "I am here 1", quantity: "1", style: "Pixar", size: "256x256"
//                ),
//                History(
//                    date: Date.now + 2,
//                    images: [UIImage(systemName: "cursorarrow.rays")!, UIImage(systemName: "cursorarrow.motionlines")!, UIImage(systemName: "cursorarrow.motionlines.click")!, UIImage(systemName: "dot.circle.and.hand.point.up.left.fill")!, UIImage(systemName: "dot.circle.and.cursorarrow")!, UIImage(systemName: "plus.magnifyingglass")!, UIImage(systemName: "circle.hexagonpath")!, UIImage(systemName: "smallcircle.filled.circle.fill")!, UIImage(systemName: "smallcircle.filled.circle")!, UIImage(systemName: "minus.magnifyingglass")!],
//                    transcript: "I am here 2", quantity: "1", style: "Pixar", size: "256x256"
//                ),
//                History(
//                    date: Date.now + 4,
//                    images: [UIImage(systemName: "cursorarrow.click.badge.clock")!, UIImage(systemName: "cursorarrow.and.square.on.square.dashed")!, UIImage(systemName: "cursorarrow.click")!],
//                    transcript: "I am here 3", quantity: "1", style: "Pixar", size: "256x256"
//                )
    ]
    @Published var profile = Profile.default

    @MainActor func generateImage(
        for imageData: Data? = nil,
        url: URL,
        with prompt: String,
        quantity: String,
        style: String,
        size: String
    ) async throws {
        do {
            images.removeAll()
            isLoading = true
            let response = try await DallEImageGenerator.shared.generateImage(
                for: imageData,
                url: url,
                from: prompt,
                quantity: quantity,
                size: size
            )

            for data in response.data {
                let (data, _) = try await URLSession.shared.data(from: data.url)
                images.append(UIImage(data: data)!)
            }

            histories.append(
                History(
                    date: Date(),
                    images: images,
                    transcript: prompt,
                    quantity: quantity,
                    style: style,
                    size: size
                )
            )
            isLoading = false
        } catch {
            await MainActor.run {
                self.showingAlert = true
            }
            print("⚠️⚠️⚠️ \(error.localizedDescription)")
        }
    }
}
