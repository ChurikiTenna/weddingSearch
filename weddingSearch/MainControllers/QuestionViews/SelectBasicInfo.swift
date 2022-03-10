//
//  SelectBasicInfo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import Foundation

class SelectBasicInfo: QuestionView {
    
    init(to view: UIView, onNext: @escaping () -> Void) {
        super.init(type: .selectVenue, to: view, onNext: onNext)
    }
    
    override func setUI(y: inout CGFloat) {
        
    }
}
