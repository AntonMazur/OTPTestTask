//
//  OTPTestTaskApp.swift
//  OTPTestTask
//
//  Created by Anton Mazur on 17.07.2024.
//

import SwiftUI

@main
struct OTPTestTaskApp: App {
    @StateObject private var coordinator = Coordinator()
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                coordinator.getPage(.otp)
                    .navigationDestination(for: Pages.self) { page in
                        coordinator.getPage(page)
                    }
            }
            .environmentObject(coordinator)
        }
    }
}
