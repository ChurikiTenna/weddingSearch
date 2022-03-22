//
//  EnterOtherInfo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class EnterOtherInfo: QuestionView {
    
    override var type: QuestionType { .otherInfo }
    
    var textV: TextView!
    
    override func setUI(y: inout CGFloat) {
        
        textV = TextView(.full_rect(y: &y, h: 200, view: self),
                         placeholder: "(例: 見積を知りたい式場がなかったなど、何でも大丈夫です)", text: "", to: self)
        
        DispatchQueue.main.async {
            self.checkDone(check: { return true })
        }
    }
}
