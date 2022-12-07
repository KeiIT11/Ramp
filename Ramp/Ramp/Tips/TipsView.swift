//
//  TipsView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2021/12/10.
//

import SwiftUI

struct TipsView: View {
    
    var categories:[String:[Article]]{
        .init(grouping: articleData,
              by: {$0.category}
        )
    }
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                ForEach(categories.keys.sorted(), id: \String.self){ key in
                    CardListView(categoryName: "\(key)".uppercased(),articles:self.categories[key]!)
                            .frame(height:320)
                        .padding(.top)
                        .padding(.bottom)
                }
                .padding()
                
                Spacer()
                
            }
            .navigationBarTitle(Text("記事一覧"))
            /*
            List(categories.keys.sorted(), id: \String.self){ key in CardListView(categoryName: "\(key)".uppercased(),articles:self.categories[key]!)
                    .frame(height:320)
                .padding(.top)
                .padding(.bottom)
            }
            */
            //.listStyle(PlainListStyle())
        }
    }
}

struct TipsView_Previews: PreviewProvider {
    static var previews: some View {
        TipsView()
    }
}
