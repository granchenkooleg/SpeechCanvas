import SwiftUI

enum ImageError: Error {
    case inValidPrompt, badURL
}

class DallEImageGenerator {
    static let shared = DallEImageGenerator()
    let sessionID = UUID().uuidString
    
    private init() { }
    
    func makeSurePromptIsValid(
        _ prompt: String,
        apiKey: String
    ) async throws -> Bool {
        guard let url = URL(string: "https://api.openai.com/v1/moderations") else {
            throw ImageError.badURL
        }
        
        let parameters: [String: Any] = [
            "input" : prompt
        ]
        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        request.httpBody = data
        
        let (response, _) = try await URLSession.shared.data(for: request)
        let result = try JSONDecoder().decode(ModerationResponse.self, from: response)
        
        return result.hasIssues == false
    }

    func generateImage(
        forEditImage imageData: String? = nil,
        url: URL,
        withPrompt prompt: String,
        quantity: String,
        size: String
    ) async throws -> ImageGenerationResponse {

        //        guard try await makeSurePromptIsValid(prompt, apiKey: apiKey) else {
        //            throw ImageError.inValidPrompt
        //        }

        let parameters = [
            [
                "key": "prompt",
                "value": prompt,
                "type": "text"
            ],
            [
                "key": "n",
                "value": quantity,
                "type": "text"
            ],
            [
                "key": "size",
                "value": size,
                "type": "text"
            ]] as [[String: Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        let body = NSMutableData()

        for param in parameters {
            if param["disabled"] != nil { continue }
            let paramName = param["key"]!
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
            if param["contentType"] != nil {
                body.append("\r\nContent-Type: \(param["contentType"] as! String)".data(using: .utf8)!)
            }
            let paramType = param["type"] as! String
            if paramType == "text" {
                let paramValue = param["value"] as! String
                body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
            }
        }
        
        if let data = imageData {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("filename=\"image.png\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \"content-type header\"\r\n\r\n\(data)\r\n".data(using: .utf8)!)

//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//            body.append(data)
//            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        var request = URLRequest(url: url)
        request.addValue("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", forHTTPHeaderField: "Authorization")
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = body as Data

        let (response, _) = try await URLSession.shared.data(for: request)
        let responseString = String(data: response, encoding: .utf8)

        // Handle the response as per your requirement
        print("Server response: \(responseString ?? "")")
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)

        return result
    }

//    func generateImage(
//        apiKey: String,
//        forEditImage imageData: Data? = nil,
//        url: URL,
//        withPrompt prompt: String,
//        quantity: String,
//        size: String
//    ) async throws -> ImageGenerationResponse {
//        let parameters: [String: Any]
//
//        guard try await makeSurePromptIsValid(prompt, apiKey: apiKey) else {
//            throw ImageError.inValidPrompt
//        }
//
//        guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
//            throw ImageError.badURL
//        }
//
//        if let imageData = imageData {
//             parameters = [
//                    "prompt": prompt,
//                    "num_completions": 1,
//                    "top_p": 1.0,
//                    "n": 1,
//                    "images": [imageData.base64EncodedString()]
//                ]
//        } else {
//             parameters = [
//                "prompt" : prompt, // The maximum length is 1000 characters.
//                "n" : 1, // The number of images to generate. Must be between 1 and 10.
//                "size" : size, // The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
//                "user" : sessionID // Sending end-user IDs in your requests can be a useful tool to help OpenAI monitor and detect abuse. Username, email address or session ID
//            ]
//        }
//
//
//        let data: Data = try JSONSerialization.data(withJSONObject: parameters)
//
//        var request = URLRequest(url: url)
//        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
//        request.httpMethod = "POST"
//        request.httpBody = data
//
//        let (response, _) = try await URLSession.shared.data(for: request)
//        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)
//
//        return result
//    }
}
