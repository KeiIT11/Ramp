//
//  TaskselectView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/02/13.
//

import SwiftUI
import CoreData

struct TaskselectView: View {
    
    //prepare to use coredate
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        predicate: nil
    ) private var tasks: FetchedResults<Task>
    
    @Binding var showingDetail :Bool
    @Binding var taskName :String //タスクの名前を選択してtimerviewに返す
    @Binding var taskuuid :UUID
    @State var date = Date()
    @State var name = ""
    
    var body: some View {
        
        let metaDate = date.metadate()
        
        NavigationView{
            if tasks.last(where: {task in
                metaDate == task.timestamp}) != nil {
                List {
                    ForEach(tasks) { task in
                        if task.timestamp == metaDate{
                            if task.checked == false{
                                // タスクの表示
                                HStack {
                                    Text("\(task.name!)")
                                    Spacer()
                                }
                                
                                /// タスクをタップでcheckedフラグを変更する
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    taskName = task.name!
                                    taskuuid = task.uuid!
                                    self.showingDetail.toggle()
                                }
                            }
                        }
                    }
                }
                .navigationBarTitle("実行するタスク")
                .padding()
                .listStyle(PlainListStyle()) //リストスタイル変更
            } else {
                VStack{
                    Spacer()
                    Text("今日のタスクがありません")
                    Spacer()
                }
                .navigationBarTitle("実行するタスク")
            }
        }
        
    }
}

struct TaskselectView_Previews: PreviewProvider {
    @State static var showingDetail = true
    @State static var taskName :String = ""
    @State static var elapsedTime :Double = 0
    @State static var taskuuid :UUID = UUID()
    static var previews: some View {
        TaskselectView(showingDetail: $showingDetail, taskName: $taskName, taskuuid: $taskuuid).environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
