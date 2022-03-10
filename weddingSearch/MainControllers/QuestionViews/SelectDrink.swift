//
//  SelectDrink.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectDrink: QuestionView {
    
    init(to view: UIView, onNext: @escaping () -> Void) {
        super.init(type: .needDrinkQ, to: view, onNext: onNext)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page22")
        selectionField(y: &y, title: "ウェルカムドリンク", onTap: {
            
        })
        selectionField(y: &y, title: "乾杯用シャンパン", onTap: {
            
        })
        let texts = ["・ウェルカムドリンクは、披露宴の前の待ち時間にゲストに提供されるドリンクです"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
