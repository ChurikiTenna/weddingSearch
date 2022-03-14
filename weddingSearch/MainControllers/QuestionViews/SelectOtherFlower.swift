//
//  SelectOtherFlower.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct OtherFlowerData: Codable {
    var bouket = ""
    var onaoshi = ""
    var forParent = ""
}
class SelectOtherFlower: QuestionView {
    
    override var type: QuestionType { .otherFlower }
    
    var otherFlowerData = OtherFlowerData() {
        didSet {
            checkDone(check: {
                if otherFlowerData.bouket.isEmpty { return false }
                if otherFlowerData.onaoshi.isEmpty { return false }
                if otherFlowerData.forParent.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page25")
        let budgetRange = RangeHelper.shared.rangeFrom([1,2,2.5,3,3.5,4,5,8,10], min: 0.5)
        let budgets = RangeHelper.shared.toText(from: budgetRange, unit: "万円")
        
        _=selectionField(y: &y, title: "ブーケ（挙式用）のご予算は？", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.otherFlowerData.bouket = str
        })
        _=selectionField(y: &y, title: "ブーケ（お色直し用）のご予算は？", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.otherFlowerData.onaoshi = str
        })
        _=selectionField(y: &y, title: "両親に贈呈する花束は必要ですか？", options: ["必要","不要"], onSelect: { str in
            self.otherFlowerData.forParent = str
        })
        let texts = ["・お色直しとは、披露宴の途中に新郎新婦が衣装を替える演出です",
                     "・お色直しに合わせて、ブーケを替えることもできます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

