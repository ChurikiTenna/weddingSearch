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
    
    var flowerData = FlowerData() {
        didSet {
            checkDone(check: {
                if flowerData.mainTable.isEmpty { return false }
                if flowerData.guestTable.isEmpty { return false }
                if flowerData.cakeTable.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page24")
        let budgets = [100,125,150,175,200]
        _ = selectionField(y: &y, title: "メインテーブル（高砂席）", btnTitle: .selectPrice,
                           options: budgets.map({ "\(($0*1000).comma())円" }) + ["不要"], onSelect: { str in
            self.flowerData.mainTable = str
        })
        
        _ = selectionField(y: &y, title: "ゲストテーブル", btnTitle: .selectPrice,
                           options: budgets.map({ "\(($0*100).comma())円/テーブル" }) + ["不要"], onSelect: { str in
            self.flowerData.guestTable = str
        })
        let budgets2 = [10000,12500,15000]
        _ = selectionField(y: &y, title: "ケーキテーブル", btnTitle: .selectPrice,
                           options: budgets2.map({ "\($0.comma())円" }) + ["不要"], onSelect: { str in
            self.flowerData.cakeTable = str
        })
        let texts = ["・高砂の他にも、ゲストテーブルやケーキテーブルをお花で飾ります",
                     "・料金を上げると、お花のランクを上げたり、ボリュームを増やすことができます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

