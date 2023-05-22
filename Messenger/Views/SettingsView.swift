//
//  SettingsView.swift
//  Messenger
//
//  Created by Patryk Maciąg on 19/05/2023.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var vm: ViewModel
    @State var isPresented: Bool = false
    var body: some View {
        VStack(alignment: .center){
            Circle()
                .frame(width: 100, height: 100)
                .onTapGesture {
                    isPresented.toggle()
                }
            Text("\(vm.userData.firstName) \(vm.userData.lastName)")
                .font(.system(size: 22, weight: .semibold))
                .onTapGesture {
                    vm.persistImage()
                }
            
            Spacer()
        }
        .sheet(isPresented: $isPresented, content: {
            ImagePicker(image: $vm.image)
        })
        .presentationDetents([.medium])
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(ViewModel())
    }
}
