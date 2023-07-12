//
//  DropdownRow.swift
//  VoiceDraw
//
//  Created by Oleg Granchenko on 12.07.2023.
//

import SwiftUI

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
