//
//  ContentView.swift
//  ToDo_MasteringSUI
//
//  Created by Grant Rudow on 2/6/20.
//  Copyright © 2020 Grant Rudow. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    var rowHeight: CGFloat = 50
    
    @Environment(\.managedObjectContext) var managedObjectContext
    
    @FetchRequest(entity: ToDoItems.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \ToDoItems.createdAt, ascending: false)], predicate: NSPredicate(format: "taskDone = %d", false))
    
    var fetchedItems: FetchedResults<ToDoItems>
    
    @State var newTaskTitle = ""
    
    var body: some View {
        
        NavigationView {
            
            List {
                
                ForEach(fetchedItems, id: \.self) { item in
                    //To-Do's (Dynamic)
                    HStack {
                        Text(item.taskTitle ?? "Empty")
                        Spacer()
                        Button(action: {self.markTaskAsDone(at: self.fetchedItems.firstIndex(of: item)!)}) {
                            Image(systemName: "circle")
                                .imageScale(.large)
                                .foregroundColor(.gray)
                        }
                    }
                }
                .frame(height: rowHeight)
                
                //Rows for adding new task (Static)
                
                HStack {
                    TextField("Add task...", text: $newTaskTitle,
                              onCommit: {self.saveTask()})
                    Button(action: {self.saveTask()}) {
                        Image(systemName: "plus")
                            .imageScale(.large)
                        
                    }
                }
                .frame(height: rowHeight)
                
                //Row for going to accomplished tasks (Static)
                
                NavigationLink(destination: TasksDone()) {
                    Text("Tasks Done")
                        .frame(height: rowHeight)
                }
            }
            .navigationBarTitle(Text("To-Do"))
            .listStyle(GroupedListStyle())
        }
    }
    
    func saveTask() {
        guard self.newTaskTitle != "" else {
            return
        }
        
        let newToDoItem = ToDoItems(context:
            self.managedObjectContext)
        newToDoItem.taskTitle = self.newTaskTitle
        newToDoItem.createdAt = Date()
        newToDoItem.taskDone = false
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
        
        self.newTaskTitle = ""
    }
    
    func markTaskAsDone(at index: Int) {
        let item = fetchedItems[index]
        
        item.taskDone = true
        
        do {
            try self.managedObjectContext.save()
        } catch {
            print(error.localizedDescription)
        }
    }
    
    
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
