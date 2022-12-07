//
//  TipsView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2021/05/26.
//

import SwiftUI

struct CardView: View {
    
    var article:Article
    
    var body: some View {
        VStack{
            Image(article.name)
                .resizable() //画面に収まるように調整
                .aspectRatio(contentMode: .fit) //比率をそのままにする
            .padding()
            //Divider()
            HStack{
                VStack(alignment: .leading){
                    /*Text("SwiftUI")
                        .font(.headline)
                        .foregroundColor(.secondary)*/
                    Text(article.Title)
                        .font(.title3)
                        .fontWeight(.light)
                        .foregroundColor(.primary)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                    /*Text("Written by ".uppercased())
                        .font(.caption)
                        .foregroundColor(.secondary)*/
                
                }
                .layoutPriority(100) //spacerが大きくなりすぎないようにレイアウト優先
                Spacer()
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .background(Color.white)
        .cornerRadius(10)
        .clipped() //
        .shadow(color: .black.opacity(0.5), radius: 3, x: 1.0, y: 1.0)
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(article: articleData[0])
    }
}
