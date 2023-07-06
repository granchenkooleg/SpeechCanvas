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
    var images: [UIImage] = []
    @Published var drawable: [Drawable] = []
    var history: [History] = []
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

//            await MainActor.run {
                drawable.append(
                    Drawable(
                        prompt: prompt,
                        size: size,
                        quantity: quantity,
                        style: style,
                        images: images
                    )
                )

//            let date = Date()
//            let calendar = Calendar.current
//            let hour = calendar.component(.hour, from: date)
//            let minutes = calendar.component(.minute, from: date)

            history.append(History(date: Date(), images: images, transcript: prompt))
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
