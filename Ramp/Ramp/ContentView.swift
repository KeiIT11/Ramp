//
//  ContentView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2021/05/23.
//

import SwiftUI
import CoreData
import UserNotifications

struct ContentView: View {
    
    @State var selectedTab: Int = 0
    
    var body: some View {
        TabView(selection: $selectedTab){
            TimerselectView()
                .tabItem{
                    VStack{
                        Image(systemName: "timer")
                        Text("Timer")
                    }
                }.tag(0)

            ScheduleView()
                .tabItem {
                    VStack{
                        Image(systemName:"calendar.badge.clock")
                        Text("Schedule")
                    }
                }.tag(1)
            
            RecordView()
                .tabItem {
                    VStack{
                        Image(systemName: "chart.bar")
                        Text("Record")
                    }
                }.tag(2)
            
            TipsView()
                .tabItem {
                    VStack{
                        Image(systemName: "lightbulb")
                        Text("Tips")
                    }
                }.tag(3)
            
            /*
            MenuView()
                .tabItem {
                    VStack{
                        Image(systemName: "ellipsis.circle")
                        Text("Menu")
                    }
                }.tag(4)
            */
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
