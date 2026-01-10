//
//  GununKelimesiApp.swift
//  GununKelimesi
//
//  Created by ekrem emre büyükcoşkun on 10.01.2026.
//

import SwiftUI

@main
struct GununKelimesiApp: App {
    
    
    
    // Uygulama başladığında çalışacak kod
        init() {
            // İzin iste ve bildirimi kur
            NotificationManager.shared.requestPermission()
        }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
