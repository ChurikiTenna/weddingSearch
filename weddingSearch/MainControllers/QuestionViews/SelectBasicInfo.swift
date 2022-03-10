//
//  SelectBasicInfo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectBasicInfo: QuestionView {
    
    var type: QuestionType { .basicInfo }
    
    override func setUI(y: inout CGFloat) {
        selectionField(y: &y, title: "パーティーの招待人数は？", btnTitle: .selectPpl) {
            
        }
        selectionField(y: &y, title: "うち、子供の数は？", btnTitle: .selectPpl) {
            
        }
        selectionField(y: &y, title: "結婚式の時期は？", btnTitle: .selectSeason) {
            
        }
        selectionField(y: &y, title: "結婚式のご予算は？（式場に支払う総額）", btnTitle: .selectPpl) {
            
        }
    }
}
