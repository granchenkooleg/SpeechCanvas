/*
 See LICENSE folder for this sample’s licensing information.

 Abstract:
 Storage for model data.
 */

import Foundation
import Combine
import SwiftUI

final class ModelData: ObservableObject {
    @Published var showingAlert = false
    @Published var images: [UIImage] = [UIImage(systemName: "figure.stand.line.dotted.figure.stand")!, UIImage(systemName: "figure.roll")!, UIImage(systemName: "mic")!]
    @Published var histories: [History] = [
        History(
            date: Date.now,
            images: [UIImage(systemName: "figure.stand.line.dotted.figure.stand")!, UIImage(systemName: "figure.roll")!, UIImage(systemName: "mic")!],
            transcript: "I am here 1"
        ),
        History(
            date: Date.now + 2,
            images: [UIImage(systemName: "cursorarrow.rays")!, UIImage(systemName: "cursorarrow.motionlines")!, UIImage(systemName: "cursorarrow.motionlines.click")!, UIImage(systemName: "dot.circle.and.hand.point.up.left.fill")!, UIImage(systemName: "dot.circle.and.cursorarrow")!, UIImage(systemName: "plus.magnifyingglass")!, UIImage(systemName: "circle.hexagonpath")!, UIImage(systemName: "smallcircle.filled.circle.fill")!, UIImage(systemName: "smallcircle.filled.circle")!, UIImage(systemName: "minus.magnifyingglass")!],
            transcript: "I am here 2"
        ),
        History(
            date: Date.now + 4,
            images: [UIImage(systemName: "cursorarrow.click.badge.clock")!, UIImage(systemName: "cursorarrow.and.square.on.square.dashed")!, UIImage(systemName: "cursorarrow.click")!],
            transcript: "I am here 3"
        )
    ]
    @Published var profile = Profile.default

    //    var features: [Landmark] {
    //        landmarks.filter { $0.isFeatured }
    //    }
    //
    //    var categories: [String: [Landmark]] {
    //        Dictionary(
    //            grouping: landmarks,
    //            by: { $0.category.rawValue }
    //        )
    //    }

    func generateImage(
        url: URL,
        with prompt: String,
        quantity: String,
        style: String,
        size: String
    ) async throws {
        do {
            let response = try await DallEImageGenerator.shared.generateImage(
                url: url,
                withPrompt: prompt,
                quantity: quantity,
                size: size
            )

            for data in response.data {
                let (data, _) = try await URLSession.shared.data(from: data.url)
                //                modelData.imageData = data
                images.append(UIImage(data: data)!)
            }

//            let date = Date()
//            let calendar = Calendar.current
//            let hour = calendar.component(.hour, from: date)
//            let minutes = calendar.component(.minute, from: date)

            histories.append(History(date: Date(), images: images, transcript: prompt))
//            }
        } catch {
            DispatchQueue.main.async {
                self.showingAlert = true
            }
            print("⚠️⚠️⚠️ \(error.localizedDescription)")
        }
    }
}

//func load<T: Decodable>(_ filename: String) -> T {
//    let data: Data
//
//    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
//        else {
//            fatalError("Couldn't find \(filename) in main bundle.")
//    }
//
//    do {
//        data = try Data(contentsOf: file)
//    } catch {
//        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
//    }
//
//    do {
//        let decoder = JSONDecoder()
//        return try decoder.decode(T.self, from: data)
//    } catch {
//        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
//    }
//}
