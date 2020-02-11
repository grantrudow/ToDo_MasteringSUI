//
//  TasksDone.swift
//  ToDo_MasteringSUI
//
//  Created by Grant Rudow on 2/10/20.
//  Copyright © 2020 Grant Rudow. All rights reserved.
//

import SwiftUI

struct TasksDone: View {
    
    var rowHeight: CGFloat = 50
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: ToDoItems.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItems.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", true))
    
    var fetchedItems: FetchedResults<ToDoItems>
    
    var body: some View {
        
        List {
            ForEach(fetchedItems, id: \.self) { item in
                HStack {
                    Text(item.taskTitle ?? "Empty")
                    Spacer()
                    Image(systemName: "checkmark.circle.fill")
                        .imageScale(.large)
                        .foregroundColor(.blue)
                }
                .frame(height: self.rowHeight)
            }
            .onDelete(perform: removeItems)
        }
    .navigationBarTitle(Text("Tasks done"))
    .listStyle(GroupedListStyle())
    }
    
    func removeItems(at offsets: IndexSet) {
        for index in offsets {
            let item = fetchedItems[index]
            managedObjectContext.delete(item)
        }
        do {
            try managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
}

struct TasksDone_Previews: PreviewProvider {
    static var previews: some View {
        TasksDone()
    }
}
