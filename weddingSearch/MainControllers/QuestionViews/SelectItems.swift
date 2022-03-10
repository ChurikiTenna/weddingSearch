//
//  SelectItems.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectItems: QuestionView {
    
    var type: QuestionType { .otherItems }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page26")
        selectionField(y: &y, title: "招待状", onTap: {
            
        })
        selectionField(y: &y, title: "席次表", onTap: {
            
        })
        selectionField(y: &y, title: "席札", onTap: {
            
        })
        selectionField(y: &y, title: "メニュー表", onTap: {
            
        })
        let texts = ["・ペーパーアイテムを準備する際は、式場にお願いするか、自分で準備する(持ち込む)必要があります",
                     "・持ち込みの場合、費用を安く済ませます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

