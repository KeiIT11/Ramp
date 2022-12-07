//
//  CardListView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/01/21.
//

import SwiftUI

struct CardListView: View {
    
    var categoryName:String
    var articles:[Article]
    
    var body: some View {
        VStack(alignment :.leading){
            Text(self.categoryName)
                .font(.title)
            ScrollView(.horizontal, showsIndicators: false){
                HStack(alignment: .top) {
                    ForEach(self.articles) { article in
                        NavigationLink(destination: CardDetailView(article: article)){
                                CardView(article:article)
                                .frame(width:300)
                                .padding()
                                //.padding(.trailing,30)
                        }
                    }
                }
            }
            
        }
    }
}

struct CardListView_Previews: PreviewProvider {
    static var previews: some View {
        CardListView(categoryName: "効率のいい勉強法", articles: articleData)
    }
}
