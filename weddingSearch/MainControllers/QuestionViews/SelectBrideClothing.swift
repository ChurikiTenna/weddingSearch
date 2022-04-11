//
//  SelectBrideClothing.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct BrideClothingData: Codable {
    var western_wd_1 = ""
    var western_wd_2 = ""
    var western_cd_1 = ""
    var western_cd_2 = ""
    var japanese = ""
}

class SelectBrideClothing: QuestionView {
    
    override var type: QuestionType { .brideClothing }
    
    var clothingData = BrideClothingData() {
        didSet {
            checkDone(check: {
                if clothingData.western_wd_1.isEmpty { return false }
                if clothingData.western_wd_2.isEmpty { return false }
                if clothingData.western_cd_1.isEmpty { return false }
                if clothingData.western_cd_2.isEmpty { return false }
                if clothingData.japanese.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page30")
        let options = ["はい（式場で選ぶ）","はい（持ち込む）","いいえ"]
        _=selectionField(y: &y, title: "洋装(ウェディングドレス)※1着目", options: options, onSelect: { str in
            self.clothingData.western_wd_1 = str
        })
        _=selectionField(y: &y, title: "洋装(ウェディングドレス)※2着目", options: options, onSelect: { str in
            self.clothingData.western_wd_2 = str
        })
        _=selectionField(y: &y, title: "洋装(カラードレス)※2着目", options: options, onSelect: { str in
            self.clothingData.western_cd_1 = str
        })
        _=selectionField(y: &y, title: "洋装(カラードレス)※2着目", options: options, onSelect: { str in
            self.clothingData.western_cd_2 = str
        })
        _=selectionField(y: &y, title: "和装(打掛、白無垢)", options: options, onSelect: { str in
            self.clothingData.japanese = str
        })
    }
}
