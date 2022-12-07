//
//  CalendarView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2021/05/26.
//

import SwiftUI
import CoreData

struct ScheduleView: View {
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        predicate: nil
    ) private var tasks: FetchedResults<Task>
    
    //今日の日付を取得
    @State var date = Date()
    @State var taskname = ""
    
    var body: some View {
        let year = date.year()
        let month = date.month()
        let day = date.day()
        let dow = date.dow()
        let calendar = Calendar.current
        let metaDate = date.metadate() //今日の日付（String）
        
        VStack{
            VStack(alignment: .leading){
                //日付表示
                HStack(spacing:20) {
                    VStack(alignment:.leading) {
                        Text(year)
                            .font(.caption)
                        Text("\(month)\(day)\(dow)")
                            .font(.title.bold())
                    }
                    
                    Spacer()
                    
                    //日付を変更
                    Button {
                        date = calendar.date(byAdding: .day, value: -1, to: date)!
                    } label:{
                        Image(systemName: "chevron.left")
                    }
                    
                    Button {
                        date = calendar.date(byAdding: .day, value: 1, to: date)!
                    } label:{
                        Image(systemName: "chevron.right")
                    }
                }
                
                .padding()
                
                TextField("タスクを追加",text: $taskname)
                    .onSubmit{
                        if taskname != ""{
                            let newTask = Task(context: context)
                            newTask.timestamp = metaDate
                            newTask.checked = false
                            newTask.name = taskname
                            //newTask.starttime = "2020-04-10 12:00:00 +0000"
                            newTask.uuid = UUID()
                            try? context.save()
                            taskname = ""
                        }
                    }
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .shadow(color: .black.opacity(1), radius: 0.7)
                    .padding()
                
                if tasks.last(where: {task in
                    metaDate == task.timestamp}) != nil { //今日の日付とtaskの日付を比較してnilでなければ、タスク一覧を表示する（今日の日付のタスクがあれば表示する）
                    //配列にタスクの名前を格納する
                    
                    List {
                        ForEach(Array(tasks.enumerated()), id: \.offset) { offset, task in
                
                            if task.timestamp == metaDate{
                                
                                HStack{
                                    Image(systemName: task.checked ? "checkmark.circle.fill" : "circle")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                        .foregroundColor(task.checked ? .blue : .black.opacity(0.3))
                                        //.font(.weight .thin)
                                    
                                    .onTapGesture{
                                        task.checked.toggle()
                                        try? context.save()
                                    }
                                    
                                    //テキストを表示、タップされたら同じ文章のtextfieldを表示
                                    Button {
                                        
                                    } label:{
                                        Text(task.name!)
                                    }
                                    .contentShape(Rectangle())
                                }
                            }
                        }
                    .onDelete(perform: deleteTasks)
                    }
                    .listStyle(PlainListStyle()) //リストのスタイルを変更する（グレーからホワイト）
                
                    
                    
                } else {
                    Spacer()
                    HStack(){
                        Spacer()
                        Text("タスクがありません")
                            .opacity(0.7)
                        
                        Spacer()
                    }
                }
                
                Spacer()
                
            }
        }
    }
    
    /// タスクの削除
    /// - Parameter offsets: 要素番号のコレクション
    func deleteTasks(offsets: IndexSet) {
        for index in offsets {
            context.delete(tasks[index])
        }
        try? context.save()
    }
}

extension Date{
    func metadate()-> String{ //日付管理のために使う
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: self)
    }
    func year()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "y", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: self)
    }
    func month()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "M", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: self)
    }
    func day()-> String{
        let formatter = DateFormatter()
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "d", options: 0, locale: Locale(identifier: "ja_JP"))
        return formatter.string(from: self)
    }
    func dow()-> String{
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier:"ja_JP")
        formatter.dateFormat = "(E)"
        return formatter.string(from: self)
    }
}

struct ScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        ScheduleView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
