//
//  TimerView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2021/05/26.


import SwiftUI
import CoreData
import UserNotifications

struct TimerView: View {
    
    @EnvironmentObject var timerData: TimerData
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(
        entity: Task.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Task.timestamp, ascending: true)],
        predicate: nil
    ) private var tasks: FetchedResults<Task>
    
    //@Binding var isShown: Bool //Timerviewの状態を確認する
    @State var showingDetail = false //TaskselectViewが表示されているか確認する
    @State private var isActive = false //タイマーが起動しているかを確認
    @State var timerHandler : Timer?
    //@State var timerData.count :Double = 0
    //@State var timerData.timerValue :Double = 5
    @State var judge = true //ポモドーロ(true)か休憩中(false)か判定
    //@State var timerData.taskName :String = ""
    //@State var timerData.elapsedTime :Double = 0 //タスク変更して過ぎた時間をカウント
    //@State var timerData.taskuuid :UUID = UUID()
    
    var body: some View {
        
        let min = Int((timerData.timerValue - timerData.count)/60)
        let sec = Int((ceil(timerData.timerValue-timerData.count)).truncatingRemainder(dividingBy: 60))
        //ceil(小数点切り上げ),truncatiingReminder(余り)
        let smin = String(format:"%02d", min)
        let ssec = String(format:"%02d", sec)
        
        VStack(spacing: 30.0){
            HStack(){
                Spacer()
                //戻るボタン
                Image(systemName: "xmark.circle.fill")
                    .resizable()
                    .frame(width: 30, height: 30)
                    //.foregroundColor(.black.opacity(0.5))
                    .padding()
                    .onTapGesture {
                        //実行中のタスクの経過時間を保存
                        if timerData.taskName.isEmpty == false{
                            save_elapsedTime()
                        }
                        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notification001"])
                        self.timerData.isTimerView_Shown.toggle()
                    }
            }
            
            Spacer()
            
            //タスク選択ボタン
            if judge == true {
                Button {
                    if timerData.taskName.isEmpty{ //初めてのタスク選択時
                        timerData.elapsedTime = 0
                    } else { //タスク変更時
                        save_elapsedTime()
                        timerData.elapsedTime = 0
                    }
                    self.showingDetail.toggle()
                } label:{
                    if timerData.taskName.isEmpty{
                        Text("タスクを選択")
                    } else {
                        Text(timerData.taskName)
                    }
                    Image(systemName: "chevron.right")
                }.sheet(isPresented: self.$showingDetail){
                        TaskselectView(showingDetail: $showingDetail, taskName: $timerData.taskName, taskuuid: $timerData.taskuuid)
                }
            } else {
                Text("休憩中")
            }

            ZStack{ //サークルと文字
                Circle()
                    .stroke(Color.gray.opacity(0.2),style: StrokeStyle(lineWidth: 4))
                if judge == true{
                    Circle() //描画に使う変数はCGFloatじゃないとダメ
                        .trim(from: 0, to: CGFloat((timerData.timerValue-timerData.count)/timerData.timerValue))
                    
                        .stroke(
                            Color("pomo"),style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        //.animation(.linear)
                }else {
                    Circle() //描画に使う変数はCGFloatじゃないとダメ
                        .trim(from: 0, to: CGFloat((timerData.timerValue-timerData.count)/timerData.timerValue))
                    
                        .stroke(
                            Color("rest"),style: StrokeStyle(lineWidth: 5, lineCap: .round))
                        .rotationEffect(.degrees(-90))
                        //.animation(.linear)
                }
                
                
                
                Text("\(smin):\(ssec)")
                    .font(.custom("AvenirNext-Regular", size: 50))
                    .fontWeight(.ultraLight)
                    .kerning(0.4)
            }
            .frame(width: 270, height: 270, alignment: .center)
            
            Spacer()
            
            HStack{
                if judge == true{ //while pomodoro
                    if timerHandler == nil{ //timerHandlerが初期化されていたら
                        Button(action: {
                            startTimer()
                            makeNotification() //通知をtimerValue秒後に出す
                        }) {
                            Text("スタート")
                                .fontWeight(.light)
                                .font(.title2)
                                .padding()
                        }
                        .foregroundColor(.white)
                        .background(Color("Accent2"))
                        .clipShape(Capsule())
                    } else { //timerHandlerが初期化されていないなら
                        if isActive == false { //timerHandlerが起動していたら
                            /*
                            Button(action:{
                            }) {
                                Text("")
                            }
                            .foregroundColor(.white)
                            .background(Color("pomo"))
                            .clipShape(Capsule())
                            //一時停止ボタンはいらないかもなので一時的に消去
                            
                            Button(action:{
                                if let unwrapedTimerHandler = timerHandler {
                                    if unwrapedTimerHandler.isValid == true {
                                        unwrapedTimerHandler.invalidate()
                                        isActive = true
                                    }
                                }
                            }) {
                                Text("一時停止")
                                    .fontWeight(.light)
                                    .font(.title2)
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .background(Color("pomo"))
                            .clipShape(Capsule())
                            */
                            Text("ちーかま")
                                .fontWeight(.light)
                                .font(.title2)
                                .clipShape(Capsule())
                                .padding()
                                .foregroundColor(.white)
                            
                        } else {
                            Button(action: {
                                startTimer()
                                isActive = false
                            }) {
                                Text("再開　　")
                                    .fontWeight(.light)
                                    .font(.title2)
                                    .padding()
                            }
                            .foregroundColor(.white)
                            .background(Color("Accent2"))
                            .clipShape(Capsule())
                        }
                    }
                } else { // while resting
                    if timerHandler?.isValid == true {
                        Button(action: {
                            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["notification001"])
                            timerHandler?.invalidate()
                            timerHandler = nil
                            judge = true
                            timerData.count = 0
                            timerData.timerValue = 1500
                        }) {
                            Text("スキップ")
                                .fontWeight(.light)
                                .font(.title2)
                                .padding()
                        }
                        .foregroundColor(.white)
                        .background(Color("rest"))
                        .clipShape(Capsule())
                    } else {
                        Button(action: {
                            timerHandler?.invalidate()
                            timerHandler = nil
                            judge = true
                            timerData.count = 0
                            timerData.timerValue = 1500
                        }) {
                            Text("スキップ")
                                .fontWeight(.light)
                                .font(.title2)
                                .padding()
                        }
                        .foregroundColor(.white)
                        .background(Color("rest"))
                        .clipShape(Capsule())
                        
                        Button(action: {
                            startTimer()
                            makeNotification() //通知を出す
                        }) {
                            Text("スタート")
                                .fontWeight(.light)
                                .font(.title2)
                                .padding()
                        }
                        .foregroundColor(.white)
                        .background(Color("Accent2"))
                        .clipShape(Capsule())
                    }
                }
            }
            Spacer()
        }
        //通知の認証設定
        .onAppear(perform: {
            //permissions
            UNUserNotificationCenter.current().requestAuthorization(options: [.badge,.sound,.alert]) {(_, _) in
                
            }
            
            //setting delagere for in -app notifications...
            UNUserNotificationCenter.current().delegate = timerData
        })
        
        .onDisappear(perform: {
            //resetview
            timerHandler?.invalidate()
            timerHandler = nil
            timerData.count = 0
            timerData.timerValue = 1500 //1500
            timerData.taskName = ""
            timerData.elapsedTime = 0
            timerData.taskuuid = UUID()
        })
        
    }
    
    func countDownTimer() {

        timerData.count += 1
        timerData.elapsedTime += 1
        
        if timerData.timerValue - timerData.count < 0 {
            timerData.count = 0
            timerHandler?.invalidate() //timerHanderをストップする
            
            //makeNotification()
            
            if judge==true{ //ポモドーロおわり
                if timerData.taskName.isEmpty == false{ //※もしtaskが選択されていたら（taskNameがあれば）保存する。
                    tasks.first{$0.uuid == timerData.taskuuid}!.execution_time += timerData.elapsedTime
                    try? context.save()
                }
                timerData.elapsedTime = 0
                judge = false
                timerData.timerValue = 300 //5min(300sec)
            }else{ //休憩おわり
                timerHandler = nil //timerHandlerの中身をnilにする。つまり初期化
                judge = true
                timerData.timerValue = 1500 //25min(1500sec)
            }
        }
    }
    
    func startTimer() {
        if let unwrapedTimerHandler = timerHandler{
            if unwrapedTimerHandler.isValid == true {
                return
            }
        }
        
        timerHandler = Timer.scheduledTimer(withTimeInterval:1, repeats: true) { _ in
            
            countDownTimer()
            
        }
    }
    
    //タスクごとの経過時間を記録する
    func save_elapsedTime(){
        //タスクを変更した時、経過時間をリセットして経過時間を保存
        tasks.first{$0.uuid == timerData.taskuuid}!.execution_time += timerData.elapsedTime
        try? context.save()
    }
    
     
    //通知を出す
    func makeNotification(){
        
        //②通知タイミングを指定
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(timerData.timerValue), repeats: false)
        
        //③通知コンテンツの作成
        let content = UNMutableNotificationContent()
        if judge == true {
            content.title = "ポモドーロ終了！"
            content.body = "お疲れさまです。休憩を取って集中力を回復しましょう。"
        } else {
            content.title = "休憩終わり！"
            content.body = "リフレッシュはできましたか？ 引き続き勉強に取り組みましょう。"
        }
        content.sound = UNNotificationSound.default
        
        //④通知タイミングと通知内容をまとめてリクエストを作成。
        let request = UNNotificationRequest(identifier: "notification001", content: content, trigger: trigger)
        
        //⑤④のリクエストの通りに通知を実行させる
        UNUserNotificationCenter.current().add(request) { (err) in
            if err != nil{
                print(err!.localizedDescription)
            }
        }
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
