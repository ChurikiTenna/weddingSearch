//
//  EnterOtherInfo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class EnterOtherInfo: QuestionView {
    
    override var type: QuestionType { .otherInfo }
    
    var textV: UITextView!
    
    override func setUI(y: inout CGFloat) {
        
        textV = UITextView(.full_rect(y: &y, h: 200, view: self), textSize: 16, to: self)
        
        DispatchQueue.main.async {
            checkDone(check: { return true })
        }
    }
}
