//
//  TaskViewModel.swift
//  TaskManagementCoreDataSwiftUI
//
//  Created by Yunus Emre Taşdemir on 20.04.2023.
//

import SwiftUI

class TaskViewModel: ObservableObject {
    
    // Sample Task
    @Published var storedTasks: [Task] = [
        Task(taskTitle: "Meeting", taskDescription: "Discuss team task for the day", taskDate:
        .init(timeIntervalSince1970: 1682502985)),
        Task(taskTitle: "Icon set", taskDescription: "Edit icons for team task for next week", taskDate: .init(timeIntervalSince1970: 1682502985)),
        Task(taskTitle: "Prototype", taskDescription: "Make and send prototype", taskDate: .init(timeIntervalSince1970:
                                                                                                    1682502985)),
        Task(taskTitle: "Check asset", taskDescription: "Start checking the assets", taskDate: .init (timeIntervalSince1970: 1682502985)),
        Task(taskTitle: "Team party", taskDescription: "Make fun with team mates", taskDate:
        .init (timeIntervalSince1970: 1682502985)),
        Task(taskTitle: "Client Meeting", taskDescription: "Explain project to clinet", taskDate:
        .init (timeIntervalSince1970: 1682589385)),
        Task(taskTitle: "Next Project", taskDescription: "Discuss next project with team", taskDate:
        .init (timeIntervalSince1970: 1682589385)),
        Task(taskTitle: "App Proposal", taskDescription: "Meet client for next App Proposal", taskDate:
        .init (timeIntervalSince1970: 1682589385)),
    ]
    
    
    // MARK: Current Week Days
    @Published var currentWeek: [Date] = []
    
    // MARK: Current Day
    @Published var currentDay: Date = Date()
    
    // MARK: Filtering Today Task
    @Published var filteredTasks: [Task]?
    
    
    // MARK: Intializing
    init() {
        fetchCurrentWeek()
        filterTodayTasks()
    }
    
    // MARK: Filter Today Tasks
    func filterTodayTasks() {
        DispatchQueue.global(qos: .userInteractive).async {
            
            let calendar = Calendar.current
            
            let filtered = self.storedTasks.filter {
                return calendar.isDate($0.taskDate, inSameDayAs: self.currentDay)
            }
                .sorted{ task1, task2 in
                    task2.taskDate < task1.taskDate
                }
            
            DispatchQueue.main.async {
                withAnimation {
                    self.filteredTasks = filtered
                }
            }
        }
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
