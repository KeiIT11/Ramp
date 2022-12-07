//
//  RampApp.swift
//  Ramp
//
//  Created by 伊藤嵐丸 on 2022/02/15.
//

import SwiftUI

@main
struct RampApp: App {
    
    let persistenceController = PersistenceController.shared
    
    @Environment(\.scenePhase) var scene
    @StateObject var timerData = TimerData()
    @State var pastScene :String = "" //前のアプリの状態（これがないとactiveのときの処理が暴発する）
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .environmentObject(timerData)
        }
        
        //バックグラウンドに移ったときの処理
        .onChange(of: scene) { (newScene) in
            //storiing time
            if newScene == .background{
                if timerData.count != 0 {
                    timerData.leftTime = Date()
                }
                print("back")
                pastScene = "background"
                //timerData.leftTime = Date()
            }
            
            
            if newScene == .active { //アプリに戻ったとき
                print("fore")
                pastScene = "foreground"
            }
            
            if newScene == .inactive{
                print("in")
                if pastScene == "background" && timerData.count != 0 { //タイマーが起動中にバックから戻ったとき
                    //when it enter again checking the diddeerncee
                    let diff = Date().timeIntervalSince(timerData.leftTime)
                    let currentTime = timerData.timerValue - timerData.count - Double(diff)
                
                    if currentTime >= 0{
                        if timerData.taskName.isEmpty == false{
                            timerData.elapsedTime += Double(diff)
                        }
                        timerData.count += Double(diff)
                    }
                    //バックグラウンドでタイマーが終了した場合
                    else{
                        if timerData.taskName.isEmpty == false{
                            timerData.elapsedTime += (timerData.timerValue - timerData.count)
                        }
                        timerData.count = timerData.timerValue
                    }
                }
                
            }
        }
    }
}
