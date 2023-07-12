//
//  DropDownSelector.swift
//  VoiceDraw
//
//  Created by Oleg Granchenko on 12.07.2023.
//

import SwiftUI

struct DropdownSelector: View {
    @Binding var shouldShowDropdown: Bool
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
                    .foregroundColor(.black)
//                    .foregroundColor(selectedOption == nil ? Color.gray: Color.black)
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
                if shouldShowDropdown {
                    //                        Spacer(minLength: buttonHeight / 2)
                    Dropdown(options: self.options, onOptionSelected: { option in
                        shouldShowDropdown = false
                        selectedOption = option
                        onOptionSelected?(option)
                    })
                    .offset(x: -90)
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
                    shouldShowDropdown: .constant(false),
                    placeholder: "n",
                    options: SideButtonsModel.quantity,
                    onOptionSelected: { quantity in
                        print(quantity)
                    })
                .zIndex(2)

                DropdownSelector(
                    shouldShowDropdown: .constant(false),
                    placeholder: "🟠",
                    options: SideButtonsModel.styles,
                    onOptionSelected: { style in
                        print(style)
                    })
                .zIndex(1)

                DropdownSelector(
                    shouldShowDropdown: .constant(true),
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
