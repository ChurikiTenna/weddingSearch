//
//  SelectDrink.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct DrinkData: Codable {
    var welcome = ""
    var champain = ""
}

class SelectDrink: QuestionView {
    
    override var type: QuestionType { .needDrinkQ }
    
    var drinkData = DrinkData()
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page22")
        _ = selectionField(y: &y, title: "ウェルカムドリンク", options: ["必要","不要"], onSelect: { str in
            self.drinkData.welcome = str
        })
        _ = selectionField(y: &y, title: "乾杯用シャンパン", options: ["必要","不要"], onSelect: { str in
            self.drinkData.champain = str
        })
        let texts = ["・ウェルカムドリンクは、披露宴の前の待ち時間にゲストに提供されるドリンクです"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
