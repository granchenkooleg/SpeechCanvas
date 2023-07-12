import Foundation

struct ImageGenerationResponse: Codable {
    let created: Int
    let data: [ImageResponse]
}

// MARK: - Datum
struct ImageResponse: Codable {
    let url: URL
}

//struct ImageGenerationResponse: Codable {
//    struct ImageResponse: Codable {
//        let url: URL
//    }
//
//    let created: Int
//    let data: [ImageResponse]
//}
