//
//  QuestionView.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/15.
//

import UIKit

enum QuestionType: Int {
    case selectVenue
    case basicInfo
    case foodPrice
    
    var question: String {
        switch self {
        case .selectVenue: return "Q1. 金額を見積もりたい式場を\nお選びください(最大3式場まで)"
        case .basicInfo: return "Q2. 以下の基本情報について\n教えてください"
        case .foodPrice: return "Q3. 披露宴で出す\nコース料理の料金は?"
        }
    }
    func view(to v: UIView, onNextPage: @escaping () -> Void) -> QuestionView {
        switch self {
        case .selectVenue: return SelectVenueView(to: v, onNext: onNextPage)
        case .basicInfo: return SelectBasicInfo(to: v, onNext: onNextPage)
        case .foodPrice: return SelectFoodPriceView(to: v, onNext: onNextPage)
        }
    }
}

class QuestionView: UIScrollView {
    
    var type: QuestionType
    
    var questionLbl: UILabel!
    var answerBtn: UIButton!
    
    let onNext: () -> Void
    
    init(type: QuestionType, to view: UIView, onNext: @escaping () -> Void) {
        self.onNext = onNext
        self.type = type
        super.init(frame: view.fitRect)
        slideIn(to: view)
        backgroundColor = .superPaleBackGray
        alwaysBounceVertical = true
        
        _=UIButton.closeBtn(to: self, x: 10, y: 10, theme: .clearBlack, type: .chevronL, action: slideRemove)
        
        questionLbl = UILabel(CGRect(x: 50, y: 30, w: w-100, h: 0),
                              text: type.question, font: .bold, textSize: 20, lines: -1, align: .center, to: self)
        questionLbl.fitHeight()
        
        var y = questionLbl.maxY+20
        setUI(y: &y)
        
        answerBtn = UIButton.coloredBtn(.colorBtn(centerX: w/2, y: y+20), text: "回答する", to: self, action: {
            self.onNext()
        })
        contentSize.height = answerBtn.maxY+40
    }
    func setUI(y: inout CGFloat) {
        
    }
    func slideIn(to view: UIView) {
        view.addSubview(self)
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = 0
        }
    }
    func slideRemove() {
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = self.w
        } completion: { Bool in
            self.removeFromSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
