//
//  Task.swift
//  TaskManagementCoreDataSwiftUI
//
//  Created by Yunus Emre Taşdemir on 20.04.2023.
//

import SwiftUI

// Task Model
struct Task: Identifiable {
    var id = UUID().uuidString
    var taskTitle: String
    var taskDescription: String
    var taskDate: Date
}
