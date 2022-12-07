//
//  CardDetailView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/01/21.
//

import SwiftUI
import MarkdownUI

struct CardDetailView: View {
    
    var article:Article
    
    var body: some View {
        ScrollView{
            VStack{
                Image(article.name)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                Markdown((readfile(articleName: article.name)))
                /*
                Text("aaa") //内容、mdファイルで記述
                    .foregroundColor(.primary)
                    .font(.body)
                    .lineLimit(nil)
                    .lineSpacing(12)
                */
                .padding()
                Spacer()
                
            }
        }
        
        .padding(.top)
        .padding(.bottom)
        //.edgesIgnoringSafeArea(.top)
    }
    
    func readfile(articleName: String) -> String {
        guard let fileURL = Bundle.main.url(forResource: articleName, withExtension: "md")  else {
            fatalError("ファイルが見つからない")
        }

        guard let fileContents = try? String(contentsOf: fileURL) else {
            fatalError("ファイル読み込みエラー")
        }
        
        return fileContents
    }
}

struct CardDetailView_Previews: PreviewProvider {
    static var previews: some View {
        CardDetailView(article: articleData[1])
    }
}
