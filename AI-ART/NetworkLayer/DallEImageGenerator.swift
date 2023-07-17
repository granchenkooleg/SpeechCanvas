import SwiftUI

enum ImageError: Error {
    case inValidPrompt, badURL
}

class DallEImageGenerator {
    let apiKey = Secrets.apiKey
    static let shared = DallEImageGenerator()
    let sessionID = UUID().uuidString
    
    private init() { }
    
    func makeSurePromptIsValid(
        _ prompt: String
//        apiKey: String
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
        let responseString = String(data: response, encoding: .utf8)

        print("Server response: \(responseString ?? "")")

        return result.hasIssues == false
    }

    func generateImage(
        for imageData: Data? = nil,
        url: URL,
        from prompt: String,
        quantity: String,
        size: String,
        transparentSquares: String? = nil
    ) async throws -> ImageGenerationResponse {

        guard try await makeSurePromptIsValid(prompt) else {
            throw ImageError.inValidPrompt
        }

        var parameters = [
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
            ]
        ] as [[String: Any]]

        if let transparentSquares = transparentSquares {
            let tappedSquares = [
                "key": "transparent_squares",
                "value": transparentSquares,
                "type": "text"
            ]
            parameters.append(tappedSquares as [String : Any])
        }


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
            let fileName = Helper.randomString(length: 5) + "image.png"
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
            body.append(data)
            body.append("\r\n".data(using: .utf8)!)
        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        var request = URLRequest(url: url)
        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
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
}
