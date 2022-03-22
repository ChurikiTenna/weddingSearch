//
//  SelectGrromClothing.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct GroomClothingData: Codable {
    var western_tax = ""
    var western_casual = ""
    var japanese = ""
}

class SelectGroomClothing: QuestionView {
    
    override var type: QuestionType { .groomClothing }
    
    var clothingData = GroomClothingData() {
        didSet {
            checkDone(check: {
                if clothingData.western_tax.isEmpty { return false }
                if clothingData.western_casual.isEmpty { return false }
                if clothingData.japanese.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page31")
        let options = ["はい（式場で選ぶ）","はい（持ち込む）","いいえ"]
        _=selectionField(y: &y, title: "洋装(タキシード)", options: options, onSelect: { str in
            self.clothingData.western_tax = str
        })
        _=selectionField(y: &y, title: "洋装(カジュアルスーツ)", options: options, onSelect: { str in
            self.clothingData.western_casual = str
        })
        _=selectionField(y: &y, title: "和装(紋付)", options: options, onSelect: { str in
            self.clothingData.japanese = str
        })
    }
}
