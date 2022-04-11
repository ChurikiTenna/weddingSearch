//
//  SelectFoodPriceView.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit
extension Int {
    func comma() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if let formattedTipAmount = formatter.string(from: self as NSNumber) {
            return formattedTipAmount
        }
        return "0"
    }
}

class SelectFoodPriceView: QuestionView {
    
    override var type: QuestionType { .foodPrice }
    
    var foodPrice = "" {
        didSet {
            checkDone(check: {
                if foodPrice.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page21")
        
        let budgets = [15000,17500,20000,22500,25000,27500,30000]
        _ = selectionField(y: &y, btnTitle: .selectPrice, options: budgets.map({ "\($0.comma())円/人"}), onSelect: { str in
            self.foodPrice = str
        })
        let texts = ["・コース料理の品数は7~9品が目安で、前菜、スープ・パン、肉魚、デザート等で構成されます",
                     "・フレンチや折衷料理が主流です",
                     "・料理の金額を上げると品数が増えたり、料理のランクを上げることができます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
