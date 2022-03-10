//
//  SelectFlower.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//


import UIKit

class SelectFlower: QuestionView {
    
    init(to view: UIView, onNext: @escaping () -> Void) {
        super.init(type: .flowerPrice, to: view, onNext: onNext)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page24")
        selectionField(y: &y, title: "メインテーブル", btnTitle: .selectPrice, onTap: {
            
        })
        selectionField(y: &y, title: "ゲストテーブル", btnTitle: .selectPrice, onTap: {
            
        })
        selectionField(y: &y, title: "ケーキテーブル", btnTitle: .selectPrice, onTap: {
            
        })
        let texts = ["・高砂の他にも、ゲストテーブルやケーキテーブルをお花で飾ります",
                     "・料金を上げると、お花のランクを上げたり、ボリュームを増やすことができます"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}

