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
        let budgets1 = [3,5,7,10].map({ "\($0.comma())円/人" }) + ["不要"]
        _=selectionField(y: &y, title: "引出物", btnTitle: .selectPrice, options: budgets1, onSelect: { str in
            self.hikidemonoData.hikidemono = str
        })
        let budgets2 = [1,2,3].map({ "\($0.comma())円/人" }) + ["不要"]
        _=selectionField(y: &y, title: "引菓子", btnTitle: .selectPrice, options: budgets2, onSelect: { str in
            self.hikidemonoData.hikigashi = str
        })
        let texts = ["・引出物はゲストに配られる贈呈品のことで、カタログギフトや食器等が一般的です",
                     "・引菓子は、引出物と一緒に贈られるお菓子のことです"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
