//
//  TimerViewModel.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/03/01.
//

import SwiftUI
import UserNotifications

class TimerData: NSObject,UNUserNotificationCenterDelegate,ObservableObject{
    @Published var timerValue :Double = 1500 //1500
    @Published var count :Double = 0
    @Published var isTimerView_Shown :Bool = false
    
    @Published var taskName :String = ""
    @Published var elapsedTime :Double = 0
    @Published var taskuuid :UUID = UUID()
    
    //@Published var time: Int = 0
    //@Published var selectedTime: Int = 0
    
    //getting time when it leaves the app
    @Published var leftTime: Date = Date()
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //telling what todo when receives inf foreground
        completionHandler([.badge,.sound,.banner])
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //when tap resetting view
        completionHandler()
    }
    
    
    /*
    func resetView(){
        time = 0
        selectedTime = 0
    }
    */
    
}
