//
//  ArticleDataView.swift
//  ScheduleTimer
//
//  Created by 伊藤嵐丸 on 2022/01/21.
//

import SwiftUI

struct Article:Hashable, Codable, Identifiable{
    var id: Int
    var Title: String
    var name: String
    var category: String
}
