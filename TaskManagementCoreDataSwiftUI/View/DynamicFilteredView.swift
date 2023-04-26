//
//  DynamicFilteredView.swift
//  TaskManagementCoreDataSwiftUI
//
//  Created by Yunus Emre Taşdemir on 26.04.2023.
//

import SwiftUI
import CoreData

struct DynamicFilteredView<Content: View, T>: View where T: NSManagedObject {
    // MARK: Core Data Request
    @FetchRequest var request: FetchedResults<T>
    let content: (T) -> Content
    
    // MARK: Building Custom ForEach wich will give Coredata object to build View
    init(dataToFilter: Date, @ViewBuilder content: @escaping (T)-> Content) {
        // Initializing Request With NSPredicate
        _request = FetchRequest(entity: T.entity(), sortDescriptors: [], predicate: nil)
        self.content = content
    }
    
    var body: some View {
        Group {
            if request.isEmpty {
                Text("No tasks found!")
                    .font(.system(size: 16))
                    .fontWeight(.light)
                    .offset(y: 100)
            } else {
                ForEach(request, id: \.objectID) { object in
                    self.content(object)
                }
            }
        }
    }
}

