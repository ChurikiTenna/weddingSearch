//
//  SelectFoodPriceView.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectFoodPriceView: QuestionView {
    
    init(to view: UIView, onNext: @escaping () -> Void) {
        super.init(type: .foodPrice, to: view, onNext: onNext)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page21")
        selectionField(y: &y, btnTitle: .selectPrice, onTap: {
            
        })
        let texts = ["・コース料理の品数は7~9品が目安で、前菜、スープ・パン、肉魚、デザート等で構成されます",
                     "・フレンチや折衷料理が主流です",
                     "・料理の金額を上げると品数が増えたり、料理のランクを上げることができます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
