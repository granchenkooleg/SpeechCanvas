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
        DropdownOption(key: "1", value: "1"),
        DropdownOption(key: "2", value: "2"),
        DropdownOption(key: "3", value: "3"),
        DropdownOption(key: "4", value: "4"),
        DropdownOption(key: "5", value: "5"),
        DropdownOption(key: "6", value: "6"),
        DropdownOption(key: "7", value: "7"),
        DropdownOption(key: "8", value: "8"),
        DropdownOption(key: "9", value: "9"),
        DropdownOption(key: "10", value: "10")
    ]
    static let sizes: [DropdownOption] = [
        DropdownOption(key: "256x256", value: "256x256"),
        DropdownOption(key: "512x512", value: "512x512"),
        DropdownOption(key: "1024x1024", value: "1024x1024"),
    ]
    static let styles: [DropdownOption] = [
        DropdownOption(key: "", value: ""),
        DropdownOption(key: "🟠", value: "Pixar"),
        DropdownOption(key: "🟡", value: "Ukiyo-e print"),
        DropdownOption(key: "🟢", value: "Minimalism"),
        DropdownOption(key: "🔵", value: "Poster"),
        DropdownOption(key: "🟣", value: "Pointillism"),
        DropdownOption(key: "⚫️", value: "Street Art"),
        DropdownOption(key: "⚪️", value: "Pop Art"),
        DropdownOption(key: "🟤", value: "Baroque"),
        DropdownOption(key: "🟥", value: "Abstract"),
        DropdownOption(key: "🟧", value: "Surrealism"),
        DropdownOption(key: "🟨", value: "Sci-Fi"),
        DropdownOption(key: "🟩", value: "Expressionism"),
        DropdownOption(key: "🟦", value: "Photorealism"),
        DropdownOption(key: "🟪", value: "Retro/Vintage"),
        DropdownOption(key: "⬛️", value: "Van Gogh"),
        DropdownOption(key: "🟫", value: "Art Deco")
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
