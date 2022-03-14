//
//  SelectHikidemono.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct HikidemonoData: Codable {
    var hikidemono = ""
    var hikigashi = ""
}

class SelectHikidemono: QuestionView {
    
    override var type: QuestionType { .hikidemono }
    
    var hikidemonoData = HikidemonoData() {
        didSet {
            checkDone(check: {
                if hikidemonoData.hikidemono.isEmpty { return false }
                if hikidemonoData.hikigashi.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page27")
        let budgetRange = RangeHelper.shared.rangeFrom([1,2,2.5,3,3.5,4,5,8,10], min: 0.5)
        let budgets = RangeHelper.shared.toText(from: budgetRange, unit: "万円")
        
        _=selectionField(y: &y, title: "引出物", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.hikidemonoData.hikidemono = str
        })
        _=selectionField(y: &y, title: "引菓子", btnTitle: .selectPrice, options: budgets, onSelect: { str in
            self.hikidemonoData.hikigashi = str
        })
        let texts = ["・引出物はゲストに配られる贈呈品のことで、カタログギフトや食器等が一般的です",
                     "・引菓子は、引出物と一緒に贈られるお菓子のことです"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
