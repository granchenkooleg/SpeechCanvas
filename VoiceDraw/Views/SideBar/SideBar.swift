//
//  SideBar.swift
//
//  Created by Oleg Granchenko on 29.06.2023.
//

import SwiftUI

struct SideBar: View {
    @State private var showLeft = false
    @State private var showRight = false

    var body: some View {
        HStack {
//            //Left
//            VStack {
//                Text("Left")
//            }
//            .frame(maxHeight: .infinity)
//            .frame(width: showLeft ? 150: 0)
//            .background(.red)

            //Main
            VStack {
                HStack {
//                    Button {
//                        withAnimation {
//                            showLeft.toggle()
//                        }
//                    } label: {
//                        Image(systemName: "rectangle.split.3x1")
//                    }
//                    .padding()

                    Spacer()

                    Button {
                        withAnimation {
                            showRight.toggle()
                        }
                    } label: {
                        Image(systemName: "rectangle.split.3x1")
                    }
                    .padding()
                }

                Spacer()
            }
//            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(.green)

            //Right
            VStack {
                Text("Right")
            }
            .frame(maxHeight: .infinity)
            .frame(width: showRight ? 150: 0)
//            .background(.purple)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
