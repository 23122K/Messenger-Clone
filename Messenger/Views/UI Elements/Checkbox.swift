//
//  Checkbox.swift
//  Messenger
//
//  Created by Patryk Maciąg on 03/05/2023.
//

import SwiftUI

struct boxView: View {
    @Binding var isChecked: Bool
    var body: some View {
        ZStack{
            switch(isChecked) {
            case false:
                Image("Circle.empty")
                    .resizable()
                    .frame(width: 25, height: 25)
            case true:
                Image("Circle.checked")
                    .resizable()
                    .frame(width: 25, height: 25)
            }
        }
        .frame(width: 16, height: 16)
    }
}

struct Checkbox: View {
    let title: String
    @Binding var isChecked: Bool
    var body: some View {
        ZStack(alignment: .leading) {
            HStack{
                HStack(spacing: 20){
                    boxView(isChecked: $isChecked)
                    Text(title)
                        .foregroundColor(.blue.opacity(0.8))
                        .padding(.trailing, 5)
                        .bold()
                }
                .onTapGesture {
                    isChecked.toggle()
                }
                Spacer(minLength: 1)
            }
            .padding(.horizontal)
        }
    }
}

struct Checkbox_Previews: PreviewProvider {
    static var previews: some View {
        Checkbox(title: "Remember me", isChecked: .constant(true))
    }
}
