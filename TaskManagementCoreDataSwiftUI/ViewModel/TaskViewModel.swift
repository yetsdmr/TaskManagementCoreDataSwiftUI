//
//  TaskViewModel.swift
//  TaskManagementCoreDataSwiftUI
//
//  Created by Yunus Emre Taşdemir on 20.04.2023.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Task
    @Published var filteredTasks: [Task]?
    
    
    // MARK: Intializing
    init() {
        fetchCurrentWeek()
    }
    
    func fetchCurrentWeek() {
        let today = Date()
        let calendar = Calendar.current
        let week = calendar.dateInterval (of: .weekOfMonth, for: today)
        
        guard let firstWeekDay = week?.start else{
            return
        }
        
        (1...7).forEach { day in
            if let weekday = calendar.date(byAdding: .day, value: day, to: firstWeekDay){
                currentWeek.append (weekday)
                
            }
            
        }
        
    }
    
    // MARK: Extracting Date
    func extractDate(date : Date, format: String) -> String {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        
        return formatter.string(from: date)
    }
    
    // MARK: Checking if current Date is Today
    func isToday(date: Date) -> Bool {
        let calender = Calendar.current
        
        return calender.isDate(currentDay, inSameDayAs: date)
    }
    
    // MARK: Checking if current Hour is Task Hour
    func isCurrentHour(date: Date) -> Bool {
        let calender = Calendar.current
        
        let hour = calender.component(.hour, from: date)
        let currentHour = calender.component(.hour, from: Date())
        
        return hour == currentHour
    }
}
