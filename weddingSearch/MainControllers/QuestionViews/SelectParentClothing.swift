//
//  SelectParentClothing.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct ParentClothingData: Codable {
    var dad = ""
    var mom = ""
}

class SelectParentClothing: QuestionView {
    
    override var type: QuestionType { .parentClothing }
    
    var clothingData = ParentClothingData()
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page32")
        let options = ["自分で手配する","レンタルする","購入する"]
        _=selectionField(y: &y, title: "モーニングコート(お父様用)", options: options, onSelect: { str in
            self.clothingData.dad = str
        })
        _=selectionField(y: &y, title: "留袖(お母様用)", options: options, onSelect: { str in
            self.clothingData.mom = str
        })
        let texts = ["・モーニングコートや留袖は、結婚式などの格式高い行事で、親御様が着用される衣装です"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}