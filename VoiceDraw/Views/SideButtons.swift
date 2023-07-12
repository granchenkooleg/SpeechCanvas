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

struct DropdownRow: View {
    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    var body: some View {
        Button(action: {
            if let onOptionSelected = onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
                HStack {
                    Text(self.option.value)
                        .font(.system(size: 14))
                        .foregroundColor(Color.black)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 5)
    }
}
struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    var body: some View {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(self.options, id: \.self) { option in
                        DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                        Divider()
                    }
                }
            }
            .frame(width: 130)
            .frame(minHeight: CGFloat(options.count) * 30, maxHeight: .infinity)
            .padding(.vertical, 5)
            .background(CustomColor.lightGray)
            .cornerRadius(5)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(Color.gray, lineWidth: 1)
            )
    }
}
struct DropdownSelector: View {
    @State private var shouldShowDropdown = false
    @State private var selectedOption: DropdownOption? = nil
    var placeholder: String
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    private let buttonHeight: CGFloat = 44
    var body: some View {
        Button(action: {
             shouldShowDropdown.toggle()
        }) {
            HStack {
                Text(selectedOption == nil ? placeholder : selectedOption!.value)
                    .font(.callout)
                    .scaledToFit()
                    .minimumScaleFactor(0.01)
                    .lineLimit(1)
                    .foregroundColor(selectedOption == nil ? Color.gray: Color.black)
                    .padding(.horizontal, 3)
            }
            .frame(width: 44)
        }
        .padding(.horizontal)
        .cornerRadius(5)
        .frame(width: 44, height: self.buttonHeight)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
        .overlay(
                VStack(alignment: .leading) {
                    if self.shouldShowDropdown {
                        Spacer(minLength: buttonHeight / 2)
                        Dropdown(options: self.options, onOptionSelected: { option in
                            shouldShowDropdown = false
                            selectedOption = option
                            onOptionSelected?(option)
                        })
                        .offset(x: -65) //
                    }
                }, alignment: .top
        )
        .background(
            RoundedRectangle(cornerRadius: 5).fill(CustomColor.lightGray)
        )
    }
}







struct DropdownSelector_Previews: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack {
                DropdownSelector(
                    placeholder: "n",
                    options: SideButtonsModel.quantity,
                    onOptionSelected: { quantity in
                        print(quantity)
                    })
                .zIndex(2)

                DropdownSelector(
                    placeholder: "🟠",
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
        }
    }
}
