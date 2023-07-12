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
        VStack {
            DropdownSelector(
                placeholder: "n",
                options: SideButtonsModel.quantity,
                onOptionSelected: { quantity in
                    print(quantity)
                })
            .zIndex(2)

            DropdownSelector(
                placeholder: "Style",
                options: SideButtonsModel.styles,
                onOptionSelected: { style in
                    print(style)
                })
            .zIndex(1)

            DropdownSelector(
                placeholder: "Size",
                options: SideButtonsModel.sizes,
                onOptionSelected: { size in
                    print(size)
                })
        }
        .padding(.horizontal)
        .accentColor(colorScheme == .dark ? .white : .black)
        .padding(.horizontal, 8)
    }
}
