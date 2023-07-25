//
//
//  Created by Oleg Granchenko on 06.07.2023.
//

import Foundation

struct VoiceDrawEndpoint {
    static var generateURL: String {
        "https://api.openai.com/v1/images/generations"
    }

    static var editImageURL: String {
        "https://api.openai.com/v1/images/edits"
    }

}
