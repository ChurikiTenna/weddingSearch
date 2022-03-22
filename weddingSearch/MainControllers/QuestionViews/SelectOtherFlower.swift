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
        let budgets = [30,45,60]
        let budgetTs = budgets.map({ "\(($0*1000).comma())円" }) + ["自分で持ち込む","不要"]
        
        _=selectionField(y: &y, title: "ブーケ（挙式用）のご予算は？", btnTitle: .selectPrice, options: budgetTs, onSelect: { str in
            self.otherFlowerData.bouket = str
        })
        _=selectionField(y: &y, title: "ブーケ（お色直し用）のご予算は？", btnTitle: .selectPrice, options: budgetTs, onSelect: { str in
            self.otherFlowerData.onaoshi = str
        })
        _=selectionField(y: &y, title: "両親に贈呈する花束は必要ですか？", options: yes_no_j, onSelect: { str in
            self.otherFlowerData.forParent = str
        })
        let texts = ["・お色直しとは、披露宴の途中に新郎新婦が衣装を替える演出です",
                     "・お色直しに合わせて、ブーケを替えることもできます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

