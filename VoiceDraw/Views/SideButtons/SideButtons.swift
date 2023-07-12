//
//  SideBarButtons.swift
//
//  Created by Oleg Granchenko on 05.07.2023.
//

import SwiftUI

struct SideButtons: View {
    @State private var shouldShowDropdownQuantity = false
    @State private var shouldShowDropdownStyle = false
    @State private var shouldShowDropdownSize = false
    @Binding var quantitySelection: String
    @Binding var styleSelection: String
    @Binding var sizeSelection: String
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        VStack {
            DropdownSelector(
                shouldShowDropdown: $shouldShowDropdownQuantity.onChange(stateChanged1),
                placeholder: "1",
                options: SideButtonsModel.quantity,
                onOptionSelected: { quantity in
                    quantitySelection = quantity.value
                })
            .zIndex(2)

            DropdownSelector(
                shouldShowDropdown: $shouldShowDropdownStyle.onChange(stateChanged2),
                placeholder: "Pixar",
                options: SideButtonsModel.styles,
                onOptionSelected: { style in
                    styleSelection = style.value
                })
            .zIndex(1)

            DropdownSelector(
                shouldShowDropdown:  $shouldShowDropdownSize.onChange(stateChanged3),
                placeholder: "256x256",
                options: SideButtonsModel.sizes,
                onOptionSelected: { size in
                    sizeSelection = size.value
                })
        }
        .padding(.horizontal)
        .accentColor(colorScheme == .dark ? .white : .black)
        .padding(.horizontal, 8)
    }

    func stateChanged1(to value: Bool) {
        if shouldShowDropdownStyle || shouldShowDropdownSize {
            shouldShowDropdownStyle = false
            shouldShowDropdownSize = false
        }

    }

    func stateChanged2(to value: Bool) {
        if shouldShowDropdownQuantity || shouldShowDropdownSize {
            shouldShowDropdownQuantity = false
            shouldShowDropdownSize = false
        }
    }

    func stateChanged3(to value: Bool) {
        if shouldShowDropdownQuantity || shouldShowDropdownStyle {
            shouldShowDropdownQuantity = false
            shouldShowDropdownStyle = false
        }
    }
}
