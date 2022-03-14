//
//  SelectItems.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct ItemsData: Codable {
    var invitation = ""
    var seatList = ""
    var seatName = ""
    var menuList = ""
}

class SelectItems: QuestionView {
    
    override var type: QuestionType { .otherItems }
    
    var itemData = ItemsData() {
        didSet {
            checkDone(check: {
                if itemData.invitation.isEmpty { return false }
                if itemData.seatList.isEmpty { return false }
                if itemData.seatName.isEmpty { return false }
                if itemData.menuList.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page26")
        let options = ["式場にお願いする", "自分で準備する"]
        _=selectionField(y: &y, title: "招待状", options: options, onSelect: { str in
            self.itemData.invitation = str
        })
        _=selectionField(y: &y, title: "席次表", options: options, onSelect: { str in
            self.itemData.seatList = str
        })
        _=selectionField(y: &y, title: "席札", options: options, onSelect: { str in
            self.itemData.seatName = str
        })
        _=selectionField(y: &y, title: "メニュー表", options: options, onSelect: { str in
            self.itemData.menuList = str
        })
        let texts = ["・ペーパーアイテムを準備する際は、式場にお願いするか、自分で準備する(持ち込む)必要があります",
                     "・持ち込みの場合、費用を安く済ませます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

