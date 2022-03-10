//
//  SelectOtherFlower.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//


import UIKit

class SelectOtherFlower: QuestionView {
    
    init(to view: UIView, onNext: @escaping () -> Void) {
        super.init(type: .otherFlower, to: view, onNext: onNext)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page25")
        selectionField(y: &y, title: "ブーケ（挙式用）のご予算は？", btnTitle: .selectPrice, onTap: {
            
        })
        selectionField(y: &y, title: "ブーケ（お色直し用）のご予算は？", btnTitle: .selectPrice, onTap: {
            
        })
        selectionField(y: &y, title: "両親に贈呈する花束は必要ですか？", onTap: {
            
        })
        let texts = ["・お色直しとは、披露宴の途中に新郎新婦が衣装を替える演出です",
                     "・お色直しに合わせて、ブーケを替えることもできます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

