//
//  HomeView.swift
//  TaskManagementCoreDataSwiftUI
//
//  Created by Yunus Emre Taşdemir on 20.04.2023.
//

import SwiftUI

struct HomeView: View {
    @StateObject var taskViewModel: TaskViewModel = TaskViewModel()
    @Namespace var animation
    
    // MARK: Core Data Context
    @Environment(\.managedObjectContext) var context
    // MARK: Edit Button Context
    @Environment(\.editMode) var editButton
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: false) {
            
            // MARK: Lazy Stack With Pinned Header
            LazyVStack(spacing: 15, pinnedViews: [.sectionHeaders]) {
                Section {
                    // MARK: Current Week View
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 10) {
                            ForEach(taskViewModel.currentWeek, id: \.self) { day in
                                
                                
                                VStack(spacing: 10) {
                                    
                                    Text(taskViewModel.extractDate(date: day, format: "dd"))
                                        .font(.system(size: 15))
                                        .fontWeight(.semibold)
                                    
                                    // EEE wil return Day as MON, TUE, ...etc
                                    Text(taskViewModel.extractDate(date: day, format: "EEE"))
                                        .font(.system(size: 14))
                                    
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 8, height: 8)
                                        .opacity(taskViewModel.isToday(date: day) ? 1 : 0)
                                    
                                }
                                // MARK: Foreground Style
                                .foregroundStyle(taskViewModel.isToday(date: day) ? .primary : .tertiary)
                                .foregroundColor(taskViewModel.isToday(date: day) ? .white : .black)
                                // MARK: Capsule Shape
                                .frame(width: 45, height: 90)
                                .background(
                                    ZStack {
                                        // MARK: Matched Geometry Effect
                                        if taskViewModel.isToday(date: day) {
                                            Capsule()
                                                .fill(.black)
                                                .matchedGeometryEffect(id: "CURRENTDAY", in: animation)
                                        }
                                    }
                                )
                                .contentShape(Capsule())
                                .onTapGesture {
                                    // Updating Current Day
                                    withAnimation {
                                        taskViewModel.currentDay = day
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    TasksView()
                    
                } header: {
                    HeaderView()
                }
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        // MARK: Add Button
        .overlay(
            Button {
                taskViewModel.addNewTask.toggle()
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .padding()
                    .background(Color.black, in: Circle())
            }
                .padding()
            ,alignment: .bottomTrailing
        )
        .sheet(isPresented: $taskViewModel.addNewTask) {
            // Clearing Edit Data
            taskViewModel.editTask = nil
        } content: {
            NewTaskView()
                .environmentObject(taskViewModel)
        }
    }
    
    // MARK: Tasks View
    func TasksView() -> some View {
        LazyVStack(spacing: 20) {
            // Converting object as Our Task Model
            DynamicFilteredView(dataToFilter: taskViewModel.currentDay) { (object: Task) in
                TaskCardView(task: object)
            }
        }
        .padding()
        .padding(.top)
    }
    
    // MARK: Task Card View
    func TaskCardView(task: Task) -> some View {
        HStack(alignment: editButton?.wrappedValue == .active ? .center : .top, spacing: 30) {
            
            // If Edit mode enabled then showing Delete Button
            if editButton?.wrappedValue == .active {
                // Edit Button for Current and Future Tasks
                VStack(spacing: 10) {
                    if task.taskDate?.compare(Date()) == .orderedDescending || Calendar.current.isDateInToday(task.taskDate ?? Date()) {
                        
                        Button {
                            taskViewModel.editTask = task
                            taskViewModel.addNewTask.toggle()
                        } label: {
                            Image(systemName: "pencil.circle.fill")
                                .font(.title2)
                                .foregroundColor(.primary)
                        }
                    }
                    
                    Button {
                        // MARK: Deleting Task
                        context.delete(task)
                        
                        //Saving
                        try? context.save()
                    } label: {
                        Image(systemName: "minus.circle.fill")
                            .font(.title2)
                            .foregroundColor(.red)
                    }
                    
                }

            } else {
                VStack(spacing: 10) {
                    Circle()
                        .fill(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? (task.isCompleted ? .green : .black) : .clear)
                        .frame(width: 15, height: 15)
                        .background(
                            Circle()
                                .stroke(.black, lineWidth: 1)
                                .padding(-3)
                        )
                        .scaleEffect(!taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0.8 : 1)
                    
                    Rectangle()
                        .fill(.black)
                        .frame(width: 3)
                }
            }
            
            VStack {
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading, spacing: 12) {
                        Text(task.taskTitle ?? "")
                            .font(.title2.bold())
                        
                        Text(task.taskDescription ?? "")
                            .font(.callout)
                    }
                    .hLeading()
                    
                    Text(task.taskDate?.formatted(date: .omitted, time: .shortened) ?? "")
                }
                
                if taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) {
                    // MARK: Team Members
                    HStack(spacing: 12) {
                        
                        
                        if !task.isCompleted {
                            // MARK: Check Button
                            Button {
                                // MARK: Updating Task
                                task.isCompleted = true
                                
                                // Saving
                                try? context.save()
                            } label: {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.black)
                                    .padding(10)
                                    .background(Color.white, in: RoundedRectangle(cornerRadius: 10))
                            }
                        }
                    
                        Text(task.isCompleted ? "Marked as Completed" : "Mark Task as Completed")
                            .font(.system(size: task.isCompleted ? 14 : 16, weight: .light))
                            .foregroundColor(task.isCompleted ? .gray : .white)
                            .hLeading()

                    }
                    .padding(.top)
                }
                
            }
            .foregroundColor(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? .white : .black)
            .padding(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 15 : 0)
            .padding(.bottom, taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 0 : 10)
            .hLeading()
            .background(
                Color("Black")
                .cornerRadius(25)
                .opacity(taskViewModel.isCurrentHour(date: task.taskDate ?? Date()) ? 1 : 0)
            )
            
            
        }
        .hLeading()
    }
    
    // MARK: Header
    func HeaderView() -> some View {
        HStack(spacing: 10) {
            VStack(alignment: .leading, spacing: 10) {
                Text(Date().formatted(date: .abbreviated, time: .omitted))
                    .foregroundColor(.gray)
                Text("Today")
                    .font(.largeTitle.bold())
            }
            .hLeading()
            
           // MARK: Edit Button
            EditButton()

        }
        .padding()
        .padding(.top, getSafeArea().top)
        .background(Color.white)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}

// MARK: UI Design Helper
extension View {
    func hLeading() -> some View{
        self.frame(maxWidth: .infinity, alignment: .leading)
    }
    func hTrailing() -> some View{
        self.frame(maxWidth: .infinity, alignment: .trailing)
    }
    func hCenter() -> some View{
        self.frame(maxWidth:.infinity, alignment: .center)
    }
    
    // MARK: Safe Area
    func getSafeArea()-> UIEdgeInsets {
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else {
            return .zero
        }
        
        guard let safeArea = screen.windows.first?.safeAreaInsets else {
            return .zero
        }
        
        return safeArea
    }
}
