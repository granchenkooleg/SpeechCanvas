//
//  DropdownView.swift
//  VoiceDraw
//
//  Created by Oleg Granchenko on 12.07.2023.
//

import SwiftUI

struct Dropdown: View {
    var options: [DropdownOption]
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 0) {
                ForEach(self.options, id: \.self) { option in
                    DropdownRow(option: option, onOptionSelected: self.onOptionSelected)
                    Divider()
                }
            }
        }
        .frame(width: 135)
        .frame(minHeight: min(CGFloat(options.count) * 52, UIScreen.main.bounds.height / 3))
        .padding(.vertical, 5)
        .background(CustomColor.lightGray)
        .cornerRadius(5)
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(Color.gray, lineWidth: 1)
        )
    }
}
