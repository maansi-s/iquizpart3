//
//  iQuizPart3App.swift
//  iQuizPart3
//
//  Created by Maansi Surve on 5/8/25.
//

import SwiftUI

@main
struct iQuizPart3App: App {
    @StateObject private var networkManager = NetworkManager.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(networkManager)
        }
    }
}
