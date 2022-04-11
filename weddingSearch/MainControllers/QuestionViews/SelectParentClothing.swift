//
//  SelectParentClothing.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct ParentClothingData: Codable {
    var dad_bride = ""
    var mom_bride = ""
    var dad_groom = ""
    var mom_groom = ""
}

class SelectParentClothing: QuestionView {
    
    override var type: QuestionType { .parentClothing }
    
    var clothingData = ParentClothingData() {
        didSet {
            checkDone(check: {
                if clothingData.dad_bride.isEmpty { return false }
                if clothingData.mom_bride.isEmpty { return false }
                if clothingData.dad_groom.isEmpty { return false }
                if clothingData.mom_groom.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page32")
        let options = ["必要","不要"]
        _=selectionField(y: &y, title: "新婦お父様用", options: options, onSelect: { str in
            self.clothingData.dad_bride = str
        })
        _=selectionField(y: &y, title: "新婦お母様用", options: options, onSelect: { str in
            self.clothingData.mom_bride = str
        })
        _=selectionField(y: &y, title: "新郎お父様用", options: options, onSelect: { str in
            self.clothingData.dad_groom = str
        })
        _=selectionField(y: &y, title: "新郎お母様用", options: options, onSelect: { str in
            self.clothingData.mom_groom = str
        })
        let texts = ["・モーニングコートや留袖は、結婚式などの格式高い行事で、親御様が着用される衣装です"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
