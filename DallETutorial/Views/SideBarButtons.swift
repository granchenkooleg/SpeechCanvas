//
//  SideBarButtons.swift
//  DallETutorial
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct SideBarButtons: View {
    @State private var quantitySelection = "2"
    let quantity = [
        "1","2","3","4","5","6","7","8","9","10"
    ]

    @State private var selection = "Pixar"
    @State private var styles = [
        "Pixar": "figure.american.football",
        "Surrealism": "figure.archery",
        "Pointillism": "figure.australian.football",
        "Pop Art": "figure.badminton",
        "Abstract Expressionism": "figure.barre",
        "Fauvism": "figure.baseball",
        "Realism": "figure.basketball",
        "Romanticism": "figure.bowling",
        "Symbolism": "figure.boxing"]
    //        "Minimalism",
    //        "Post-Impressionism",
    //        "Art Nouveau",
    //        "Expressionism",
    //        "Constructivism",
    //        "Dadaism",
    //        "Renaissance",
    //        "Baroque",
    //        "Rococo",
    //        "Neoclassicism",
    //        "Abstract Art",
    //        "Op Art",
    //        "Photorealism",
    //        "Street Art",
    //        "Conceptual Art"]

    @State private var sizeSelection = "2"
    let sizes = [
        "256x256","512x512","1024x1024"
    ]
    //    @State private var selection1: String = "4"
    //    @State private var selection: String = "Pixar"
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .trailing) {

            Picker("", selection: $quantitySelection) {
                ForEach(quantity, id: \.self) {
                    Text($0)
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))

            Picker("", selection: $selection) {
                ForEach(styles.sorted(by: >), id: \.key) { style in
                    HStack {
                        Image(systemName: style.value)
                        Text(style.key)


                    }
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))

            Picker("", selection: $sizeSelection) {
                ForEach(sizes, id: \.self) {
                    Text($0)
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))
        }
        .accentColor(colorScheme == .dark ? .white : .black)
        .pickerStyle(.menu)
        .padding(.horizontal, 8)
    }
}
