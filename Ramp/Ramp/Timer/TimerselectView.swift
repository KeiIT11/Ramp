//
//  TimerselectView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2021/12/10.
//

import SwiftUI

struct TimerselectView: View {
    
    @EnvironmentObject var timerData: TimerData
    
    //@State var timerData.isShown: Bool = false
    
    var body: some View {
        NavigationView{
            
            VStack(alignment: .leading){
                List{
                    Button(action:{
                        self.timerData.isTimerView_Shown.toggle()
                    }){
                        VStack(alignment: .leading){
                            Text("ポモドーロ")
                            .font(.title)
                            .padding(.top)
                            
                            Text("25分勉強 & 5分休憩")
                                .padding(.bottom)
                        }
                    
                    }
                    .fullScreenCover(isPresented: self.$timerData.isTimerView_Shown){
                        TimerView()
                    }
                }
                
            }
            .listStyle(PlainListStyle()) //リストスタイル変更
            .navigationBarTitle("タイマー")
            
            
            
            
        }
    }
}

struct TimerselectView_Previews: PreviewProvider {
    static var previews: some View {
        TimerselectView()
    }
}
