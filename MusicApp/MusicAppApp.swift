//
//  MusicAppApp.swift
//  MusicApp
//
//  Created by Erkebulan Massainov on 03.07.2024.
//

import SwiftUI

@main
struct MusicAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(expendSheet: .constant(true), animation: Namespace().wrappedValue)
        }
    }
}
