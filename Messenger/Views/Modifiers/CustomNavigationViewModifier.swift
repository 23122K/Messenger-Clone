//
//  CustomNavigationViewModifier.swift
//  Wikipedia
//
//  Created by Patryk Maciąg on 13/05/2023.
//

import SwiftUI

struct CustomNavigationViewModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    let title: String
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(leading: button)
    }
    
    var button: some View {
        Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }, label: {
            HStack{
                Image(systemName: "chevron.left")
                Text(title)
            }
            .foregroundColor(.black.opacity(0.7))
        })
    }
}

extension View {
    func withDismissName(title: String) -> some View {
        self.modifier(CustomNavigationViewModifier(title: title))
    }
}
