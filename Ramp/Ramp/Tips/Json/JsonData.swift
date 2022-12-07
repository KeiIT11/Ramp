//
//  JsonData.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/01/21.
//

import Foundation

let articleData:[Article] = load("articles.json")

func load<T:Decodable>(_ filename:String, as type:T.Type = T.self) -> T { //_は呼び出すとき引数にvalueいらない
    let data:Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else{
            //fatalErrorは通ればプログラムが停止する
            fatalError("Couldn't find \(filename) in main bundle.")
    }
    
    do {
        data = try Data(contentsOf: file)
    }catch{
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    
    do{
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Coudn't parse \(filename) as \(T.self):\n\(error)")
    }
}
