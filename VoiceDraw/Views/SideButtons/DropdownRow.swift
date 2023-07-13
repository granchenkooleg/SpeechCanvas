//
//  DropdownRow.swift
//  VoiceDraw
//
//  Created by Oleg Granchenko on 12.07.2023.
//

import SwiftUI

struct DropdownRow: View {
    let tempKeys = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "256x256", "512x512", "1024x1024"]
    var option: DropdownOption
    var onOptionSelected: ((_ option: DropdownOption) -> Void)?
    var body: some View {
        Button(action: {
            if let onOptionSelected = onOptionSelected {
                onOptionSelected(self.option)
            }
        }) {
            HStack {
                // FIXME:
                if tempKeys.contains(option.key) {
                    Text(option.value)
                } else {
                    Text(option.value)
                    Spacer()
                    Text(option.key)
                }
            }
            .font(.system(size: 14))
            .foregroundColor(Color.black)
            .frame(maxWidth: .infinity)
            .frame(height: 44)
        }
        .padding(5)
    }
}
