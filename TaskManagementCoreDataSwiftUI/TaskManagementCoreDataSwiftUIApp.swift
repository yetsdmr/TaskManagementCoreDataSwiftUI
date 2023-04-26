//
//  TaskManagementCoreDataSwiftUIApp.swift
//  TaskManagementCoreDataSwiftUI
//
//  Created by Yunus Emre Taşdemir on 18.04.2023.
//

import SwiftUI

@main
struct TaskManagementCoreDataSwiftUIApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                //.environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
