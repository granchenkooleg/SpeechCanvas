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
                placeholder: "n",
                options: SideButtonsModel.quantity,
                onOptionSelected: { quantity in
                    print(quantity)
                })
            .zIndex(2)

            DropdownSelector(
                shouldShowDropdown: $shouldShowDropdownStyle.onChange(stateChanged2),
                placeholder: "Style",
                options: SideButtonsModel.styles,
                onOptionSelected: { style in
                    print(style)
                })
            .zIndex(1)

            DropdownSelector(
                shouldShowDropdown:  $shouldShowDropdownSize.onChange(stateChanged3),
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
