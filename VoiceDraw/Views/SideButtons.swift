//
//  SideBarButtons.swift
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct SideButtons: View {
    @Binding var quantitySelection: String
    @Binding var styleSelection: String
    @Binding var sizeSelection: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack(alignment: .trailing) {

            Picker("", selection: $quantitySelection) {
                ForEach(SideButtonsModel.quantity, id: \.self) {
                    Text($0)
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))

            Picker("", selection: $styleSelection) {
                ForEach(SideButtonsModel.styles.sorted(by: >), id: \.key) { style in
                    HStack {
                        Image(systemName: style.value)
                        Text(style.key)
                    }
                }
            }
            .background (.ultraThinMaterial, in: RoundedRectangle (cornerRadius: 16.0))

            Picker("", selection: $sizeSelection) {
                ForEach(SideButtonsModel.sizes, id: \.self) {
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
