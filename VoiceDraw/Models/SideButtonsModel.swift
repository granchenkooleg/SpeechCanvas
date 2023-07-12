//
//  SideButtonsModel.swift
//
//  Created by Oleg Granchenko on 06.07.2023.
//

import Foundation
import SwiftUI

struct DropdownOption: Hashable {
    let key: String
    let value: String
    public static func == (lhs: DropdownOption, rhs: DropdownOption) -> Bool {
        return lhs.key == rhs.key
    }
}

struct SideButtonsModel {
    static var uniqueKey: String {
        UUID().uuidString
    }
    static let quantity: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "1"),
        DropdownOption(key: uniqueKey, value: "2"),
        DropdownOption(key: uniqueKey, value: "3"),
        DropdownOption(key: uniqueKey, value: "4"),
        DropdownOption(key: uniqueKey, value: "5"),
        DropdownOption(key: uniqueKey, value: "6"),
        DropdownOption(key: uniqueKey, value: "7"),
        DropdownOption(key: uniqueKey, value: "8"),
        DropdownOption(key: uniqueKey, value: "9"),
        DropdownOption(key: uniqueKey, value: "10")
    ]
    static let sizes: [DropdownOption] = [
        DropdownOption(key: uniqueKey, value: "256x256"),
        DropdownOption(key: uniqueKey, value: "512x512"),
        DropdownOption(key: uniqueKey, value: "1024x1024"),
    ]
    static let styles: [DropdownOption] = [
        DropdownOption(key: "figure.american.football", value: "Pixar"),
        DropdownOption(key: "figure.archery", value: "Ukiyo-e print"),
        DropdownOption(key: uniqueKey, value: "Minimalism"),
        DropdownOption(key: uniqueKey, value: "Poster"),
        DropdownOption(key: uniqueKey, value: "Pointillism"),
        DropdownOption(key: uniqueKey, value: "Street Art"),
        DropdownOption(key: uniqueKey, value: "Pop Art"),
        DropdownOption(key: uniqueKey, value: "Baroque"),
        DropdownOption(key: uniqueKey, value: "Abstract"),
        DropdownOption(key: uniqueKey, value: "Surrealism"),
        DropdownOption(key: uniqueKey, value: "Sci-Fi"),
        DropdownOption(key: uniqueKey, value: "Expressionism"),
        DropdownOption(key: uniqueKey, value: "Photorealism"),
        DropdownOption(key: uniqueKey, value: "Retro/Vintage"),
        DropdownOption(key: uniqueKey, value: "Van Gogh"),
        DropdownOption(key: uniqueKey, value: "Art Deco")
//        DropdownOption(key: uniqueKey, value: "3"),
//        DropdownOption(key: uniqueKey, value: "4"),
//        DropdownOption(key: uniqueKey, value: "5"),
//        DropdownOption(key: uniqueKey, value: "6"),
//        DropdownOption(key: uniqueKey, value: "7"),
//        DropdownOption(key: uniqueKey, value: "8"),
//        DropdownOption(key: uniqueKey, value: "9"),
//        DropdownOption(key: uniqueKey, value: "10")
    ]
//    static let quantity = ["1","2","3","4","5","6","7","8","9","10"]
//    static let sizes = ["256x256","512x512","1024x1024"]
//    static let styles = [
//        "Pixar": "figure.american.football",
//        "Surrealism": "figure.archery",
//        "Pointillism": "figure.australian.football",
//        "Pop Art": "figure.badminton",
//        "Abstract Expressionism": "figure.barre",
//        "Fauvism": "figure.baseball",
//        "Realism": "figure.basketball",
//        "Romanticism": "figure.bowling",
//        "Symbolism": "figure.boxing",
//        "Minimalism": "",
//        "Post-Impressionism": "",
//        "Art Nouveau": "",
//        "Expressionism": "",
//        "Constructivism": "",
//        "Dadaism": "",
//        "Renaissance": "",
//        "Baroque": "",
//        "Rococo": "",
//        "Neoclassicism": "",
//        "Abstract Art": "",
//        "Op Art": "",
//        "Photorealism": "",
//        "Street Art": "",
//        "Conceptual Art": "",
//        "Van Gogh": "",
//        "Cartoon": "",
//        "Ukiyo-e print": "",
//        "Poster": ""
//    ]
}
