//
//  SelectFlower.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct FlowerData: Codable {
    var mainTable = ""
    var guestTable = ""
    var cakeTable = ""
}
class SelectFlower: QuestionView {
    
    override var type: QuestionType { .flowerPrice }
    
    var flowerData = FlowerData()
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page24")
        let budgetRange = RangeHelper.shared.rangeFrom([2,2.5,3,3.5,4,4.5,5,8,10], min: 1)
        let budgets = RangeHelper.shared.toText(from: budgetRange, unit: "万円")
        
        _ = selectionField(y: &y, title: "メインテーブル", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.flowerData.mainTable = str
        })
        _ = selectionField(y: &y, title: "ゲストテーブル", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.flowerData.guestTable = str
        })
        _ = selectionField(y: &y, title: "ケーキテーブル", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.flowerData.cakeTable = str
        })
        let texts = ["・高砂の他にも、ゲストテーブルやケーキテーブルをお花で飾ります",
                     "・料金を上げると、お花のランクを上げたり、ボリュームを増やすことができます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

