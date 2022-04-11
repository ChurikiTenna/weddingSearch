//
//  SelectKyoshiki.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectKyoshiki: QuestionView {
    
    override var type: QuestionType { .knoshiki }
    
    var kyoshiki = "" {
        didSet {
            checkDone(check: {
                if kyoshiki.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page23")
        _ = selectionField(y: &y, options: ["教会式（キリスト式）","人前式","神前式","その他","行わない"], onSelect: { str in
            self.kyoshiki = str
        })
        let texts = ["・教会式は、チャペルで神に愛を誓う挙式形式です",
                     "・人前式は、宗教や格式を気にせず、ゲストの前で愛を誓う挙式形式です",
                     "・神前式は、新郎新婦が和装を着用する、日本の伝統的な挙式スタイルです"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
