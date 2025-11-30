//
//  ContentView.swift
//  Food Scanner MVP
//
//  Created by khaled sawan on 23.11.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            ScanView()
                .tabItem {
                    Label("Scan", systemImage: "camera.viewfinder")
                }
//            SettingsView()
//                .tabItem {
//                    Label("Settings", systemImage: "gear")
//                }
            AboutView()
                .tabItem {
                    Label("About", systemImage: "info.circle")
                }
        }
    }
}

#Preview {
    ContentView()
}
