import SwiftUI

enum ImageError: Error {
    case inValidPrompt, badURL
}

class DallEImageGenerator {
    let api_key = Secrets.apiKey
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

//    func generateImage(
//        from prompt: String,
//        quantity: String,
//        size: String
//    ) async throws -> ImageGenerationResponse {
//        var request = URLRequest(url: URL(string: VoiceDrawEndpoint.generateURL)!)
//        request.setValue("Bearer \(api_key)", forHTTPHeaderField: "Authorization")
//        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
//        request.httpMethod = "POST"
//
//        //        guard try await makeSurePromptIsValid(prompt, apiKey: apiKey) else {
//       //        //            throw ImageError.inValidPrompt
//       //        //        }
//
//        let parameters: [String: Any] = [
//            "prompt": prompt,
//            "n": quantity,
//            "size": size
//        ]
//
//        let jsonData = try? JSONSerialization.data(withJSONObject: parameters)
//
//        request.httpBody = jsonData
//
//        let (response, _) = try await URLSession.shared.data(for: request)
//        let responseString = String(data: response, encoding: .utf8)
//
//        // Handle the response as per your requirement
//        print("Server response: \(responseString ?? "")")
//        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)
//
//        return result
//
//    }

    func generateImage(
        from prompt: String,
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
        
//        if let data = imageData {
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            let fileContent = String(data: data, encoding: .utf8)!
//            body.append("filename=\"image.png\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n".data(using: .utf8)!)

//            let paramSrc = param["src"] as! String
//                let fileData = try NSData(contentsOfFile: paramSrc, options: []) as Data
//                let fileContent = String(data: fileData, encoding: .utf8)!
//                body += "; filename=\"\(paramSrc)\"\r\n"
//                  + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
//
////            body.append("--\(boundary)\r\n".data(using: .utf8)!)
////            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.png\"\r\n".data(using: .utf8)!)
////            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
////            body.append(data)
////            body.append("\r\n".data(using: .utf8)!)
//        }

        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        var request = URLRequest(url: URL(string: VoiceDrawEndpoint.generateURL)!)
        request.addValue(Secrets.apiKey, forHTTPHeaderField: "Authorization")
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

//    func generateEditedImage(from image: UIImage, with mask: UIImage) async throws -> [Photo]  {
//
//        guard let imageData = image.pngData() else{return []}
//        guard let maskData = mask.pngData() else{return []}
//
//        let formFields: [String: String] = [
//            "prompt": "A woman wearing a red dress with a laughter face expression",
//            "size": "256x256"
//        ]
//
//        let multipart = MultipartFormDataRequest(url: OpenAIEndpoint.edits.url)
//        multipart.addDataField(fieldName:  "image", fileName: "image.png", data: imageData, mimeType: "image/png")
//        multipart.addDataField(fieldName:  "mask", fileName: "mask.png", data: maskData, mimeType: "image/png")
//
//        for (key, value) in formFields {
//            multipart.addTextField(named: key, value: value)
//        }
//
//        var request = multipart.asURLRequest()
//        request.setValue("Bearer \(api_key_free)", forHTTPHeaderField: "Authorization")
//
//        let (data, _) = try await URLSession.shared.data(for: request)
//        let dalleResponse = try? JSONDecoder().decode(DALLEResponse.self, from: data)
//
//        return dalleResponse?.data ?? []
//
//    }
}
