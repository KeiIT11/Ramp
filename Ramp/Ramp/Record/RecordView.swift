//
//  RecordView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/02/19.
//

import SwiftUI
import CoreData

struct RecordView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        predicate: nil
    ) private var tasks: FetchedResults<Task>
    
    @State var date = Date()
    @State var totalTime :Double = 0
    
    var body: some View {
        let year = date.year()
        let month = date.month()
        let day = date.day()
        let dow = date.dow()
        let calendar = Calendar.current
        let metaDate = date.metadate()
        
        let total :Double = calc_totalTime(metaDate: metaDate)
        let totalHour :String = total.hour()
        let totalMin :String = total.min()
        let totalSec :String = total.sec()
        
        VStack{
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

            if tasks.last(where: {task in
                metaDate == task.timestamp}) != nil { //今日の日付とtaskの日付を比較してnilでなければ、タスク一覧を表示する（今日の日付のタスクがあれば表示する）
                //配列にタスクの名前を格納する
    
                ForEach(Array(tasks.enumerated()), id: \.offset) { offset, task in
                    
                    if task.timestamp == metaDate{
                        HStack{
                            Text("\(task.name!)")
                                .font(.title3)
                            //Spacer()
                            //Text("\(task.execution_time)")
                            Spacer()
                            Text(task.execution_time.hour())
                            Text(task.execution_time.min())
                            Text(task.execution_time.sec())
                        }
                    }
                }
                .padding()
                
                Divider()
                HStack{
                    Text("合計時間")
                        .font(.title2)
                    Spacer()
                    Text(totalHour)
                    Text(totalMin)
                    Text(totalSec)
                }
                .padding()
                
            } else {
                Spacer()
                HStack(){
                    Spacer()
                    Text("記録がありません")
                        .opacity(0.7)
                    
                    Spacer()
                }
            }
            
            Spacer()
        }
    }
    
    func calc_totalTime(metaDate :String) -> Double{
        var totaltime :Double = 0
        if tasks.last(where: {task in
            metaDate == task.timestamp}) != nil {
            for task in tasks{
                if task.timestamp == metaDate{
                    totaltime += task.execution_time
                }
            }
        }
        return totaltime
    }
}

extension Double{
    
    func hour() -> String{
        let hour = Int(self/3600)
        if hour != 0 {
            return "\(String(hour))時間"
        } else {
            return ""
        }
    }
    
    func min() -> String{
        let min = Int(self.truncatingRemainder(dividingBy: 3600)/60)
        if min != 0 {
            return "\(String(min))分"
        } else {
            return ""
        }
    }
    
    func sec() -> String{
        let sec = Int(self.truncatingRemainder(dividingBy: 3600).truncatingRemainder(dividingBy: 60))
        if sec != 0 {
            return "\(String(sec))秒"
        } else {
            return ""
        }
    }
}
        
struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
