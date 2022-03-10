//
//  SelectFoodPriceView.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectFoodPriceView: QuestionView {
    
    override var type: QuestionType { .foodPrice }
    
    var foodPrice = ""
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page21")
        
        let budgetRange = RangeHelper.shared.rangeFrom([1,1.5,2,2.5,3,4,5,8], min: 0.5)
        let budgets = RangeHelper.shared.toText(from: budgetRange, unit: "万円")
        _ = selectionField(y: &y, btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.foodPrice = str
        })
        let texts = ["・コース料理の品数は7~9品が目安で、前菜、スープ・パン、肉魚、デザート等で構成されます",
                     "・フレンチや折衷料理が主流です",
                     "・料理の金額を上げると品数が増えたり、料理のランクを上げることができます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
