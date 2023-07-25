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

//            guard let url = URL(string: "https://api.openai.com/v1/images/generations") else {
//                throw ImageError.badURL
//            }

            let parameters: [String: Any] = [
                "prompt" : prompt, // The maximum length is 1000 characters.
                "n" : Int(quantity), // The number of images to generate. Must be between 1 and 10.
                "size" : size, // The size of the generated images. Must be one of 256x256, 512x512, or 1024x1024
                "user" : sessionID // Sending end-user IDs in your requests can be a useful tool to help OpenAI monitor and detect abuse. Username, email address or session ID
            ]
            let data: Data = try JSONSerialization.data(withJSONObject: parameters)

            var request = URLRequest(url: url)
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
            request.httpMethod = "POST"
            request.httpBody = data

            let (response, _) = try await URLSession.shared.data(for: request)
            let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)

            return result
        }

    func generateEditedImage(
        for imageData: Data? = nil,
        with mask: Data? = nil,
        url: URL,
        from prompt: String,
        quantity: String,
        size: String
    ) async throws -> ImageGenerationResponse  {

        let formFields: [String: String] = [
            "prompt": prompt,
            "size": size
        ]

        let multipart = MultipartFormDataRequest(url: url)
        if let imageData = imageData {
            multipart.addDataField(fieldName:  "image", fileName: "image.png", data: imageData, mimeType: "image/png")
    //        multipart.addDataField(fieldName:  "mask", fileName: "mask.png", data: maskData, mimeType: "image/png")
        }

        for (key, value) in formFields {
            multipart.addTextField(named: key, value: value)
        }

        var request = multipart.asURLRequest()
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")

        let (response, _) = try await URLSession.shared.data(for: request)

        let responseString = String(data: response, encoding: .utf8)

        //        // Handle the response as per your requirement
        print("Server response: \(responseString ?? "")")
        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)

        return result

    }

//    func generateImage(
//        for imageData: Data? = nil,
//        url: URL,
//        from prompt: String,
//        quantity: String,
//        size: String,
//        transparentSquares: String? = nil
//    ) async throws -> ImageGenerationResponse {
//
//        guard try await makeSurePromptIsValid(prompt) else {
//            throw ImageError.inValidPrompt
//        }
//
//        var parameters = [
//            [
//                "key": "prompt",
//                "value": prompt,
//                "type": "text"
//            ],
//            [
//                "key": "n",
//                "value": quantity,
//                "type": "text"
//            ],
//            [
//                "key": "size",
//                "value": size,
//                "type": "text"
//            ]
//        ] as [[String: Any]]
//
//        if let transparentSquares = transparentSquares {
//            let tappedSquares = [
//                "key": "transparent_squares",
//                "value": transparentSquares,
//                "type": "text"
//            ]
//            parameters.append(tappedSquares as [String : Any])
//        }
//
//
//        let boundary = "Boundary-\(UUID().uuidString)"
//        let body = NSMutableData()
//
//        for param in parameters {
//            if param["disabled"] != nil { continue }
//            let paramName = param["key"]!
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition:form-data; name=\"\(paramName)\"".data(using: .utf8)!)
//            if param["contentType"] != nil {
//                body.append("\r\nContent-Type: \(param["contentType"] as! String)".data(using: .utf8)!)
//            }
//            let paramType = param["type"] as! String
//            if paramType == "text" {
//                let paramValue = param["value"] as! String
//                body.append("\r\n\r\n\(paramValue)\r\n".data(using: .utf8)!)
//            }
//        }
//        
//        if let data = imageData {
//            let fileName = Helper.randomString(length: 5) + "image.png"
//            body.append("--\(boundary)\r\n".data(using: .utf8)!)
//            body.append("Content-Disposition: form-data; name=\"image\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
//            body.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
//            body.append(data)
//            body.append("\r\n".data(using: .utf8)!)
//        }
//
//        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
//
//        var request = URLRequest(url: url)
//        request.addValue(apiKey, forHTTPHeaderField: "Authorization")
//        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//        request.httpMethod = "POST"
//        request.httpBody = body as Data
//
//        let (response, _) = try await URLSession.shared.data(for: request)
//        let responseString = String(data: response, encoding: .utf8)
//
//        // Handle the response as per your requirement
//        print("Server response: \(responseString ?? "")")
//        let result = try JSONDecoder().decode(ImageGenerationResponse.self, from: response)
//
//        return result
//    }
}

struct MultipartFormDataRequest {

    private let boundaryString: String = "Boundary-\(UUID().uuidString)"
    var httpBody = NSMutableData()
    let url: URL

    init(url: URL) {
        self.url = url
    }

    func addTextField(named name: String, value: String) {
        httpBody.append(textFormField(named: name, value: value))
    }

    private func textFormField(named name: String, value: String) -> Data {
        var fieldString = Data("--\(boundaryString)\r\n".utf8)
        fieldString += Data("Content-Disposition: form-data; name=\"\(name)\"\r\n".utf8)
        fieldString += Data("Content-Type: text/plain; charset=ISO-8859-1\r\n".utf8)
        fieldString += Data("\r\n".utf8)
        fieldString += Data("\(value)\r\n".utf8)

        return fieldString
    }


    func addDataField(fieldName: String, fileName: String, data: Data, mimeType: String) {
        httpBody.append(dataFormField(fieldName: fieldName,fileName:fileName,data: data, mimeType: mimeType))
    }

    private func dataFormField(fieldName: String,
                               fileName: String,
                               data: Data,
                               mimeType: String) -> Data {

        var fieldData = Data("--\(boundaryString)\r\n".utf8)

        fieldData += Data("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(fileName)\"\r\n".utf8)
        fieldData += Data("Content-Type: \(mimeType)\r\n".utf8)
        fieldData += Data("\r\n".utf8)
        fieldData += data
        fieldData += Data("\r\n".utf8)
        return fieldData
    }

    func asURLRequest() -> URLRequest {
        var request = URLRequest(url: url)

        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundaryString)", forHTTPHeaderField: "Content-Type")

        httpBody.append(Data("--\(boundaryString)--".utf8))
        request.httpBody = httpBody as Data
        return request
    }
}

extension NSMutableData {
    func appendString(_ string: String) {
        if let data = string.data(using: .utf8) {
            self.append(data)
        }
    }
}

extension UIImage {

    var hasAlpha: Bool {
        guard let alphaInfo = self.cgImage?.alphaInfo else {return false}
        return alphaInfo != CGImageAlphaInfo.none &&
        alphaInfo != CGImageAlphaInfo.noneSkipFirst &&
        alphaInfo != CGImageAlphaInfo.noneSkipLast
    }

    func imageWithAlpha(alpha: CGFloat) throws -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPointZero, blendMode: .normal, alpha: alpha)
        guard let newImage = UIGraphicsGetImageFromCurrentImageContext() else{
            UIGraphicsEndImageContext()
            throw ImageError.unableToAddAplhaToImage
        }
        UIGraphicsEndImageContext()
        return newImage
    }
    enum ImageError: LocalizedError{
        case unableToAddAplhaToImage
    }
}
