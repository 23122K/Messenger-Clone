//
//  MessengerApp.swift
//  Messenger
//
//  Created by Patryk Maciąg on 16/05/2023.
//

import SwiftUI
import Firebase
@main
struct MessengerApp: App {
    
    //Initialising firebase 
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
