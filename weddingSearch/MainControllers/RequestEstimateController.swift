//
//  RequestEstimateController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

class RequestEstimateController: BasicViewController {
    
    var currentType = QuestionType.selectVenue
    var questionViews = [QuestionView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .superPaleBackGray
        
        header("見積もり依頼", withClose: false)
        
        let lbl = UILabel(CGRect(x: 40, y: head.maxY, w: view.w-80, h: 300), textSize: 20, lines: -1, to: view)
        let attr = NSMutableAttributedString(string: "気になる式場と希望条件を登録して\n見積もり費用を調べてみましょう\n（目安時間：",
                                             attributes: [.foregroundColor : UIColor.black])
        attr.append(NSAttributedString(string: "10分", attributes: [.foregroundColor : UIColor.themeColor]))
        attr.append(NSAttributedString(string: "、設問数：", attributes: [.foregroundColor : UIColor.black]))
        attr.append(NSAttributedString(string: "15問", attributes: [.foregroundColor : UIColor.themeColor]))
        attr.append(NSAttributedString(string: "）", attributes: [.foregroundColor : UIColor.black]))
        attr.appendParaStyle(align: .center, lineSpacing: 4)
        lbl.attributedText = attr
        
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-120), text: "登録する", to: view) {
            self.showNewQuestion(0)
        }
    }
    override func dismissSelf() {
        print("currentType", currentType.rawValue)
        if currentType == QuestionType.allCases.first {
            super.dismissSelf()
        } else {
            // back page
            showNewQuestion(currentType.rawValue-1)
        }
    }
    
    func showNewQuestion(_ idx: Int) {
        print("showNewQuestion", idx, currentType.rawValue)
        guard let type = QuestionType(rawValue: idx) else {
            return
        }
        if let questionV = questionViews.first(where: { $0.type == currentType }) {
            questionV.removeFromSuperview()
        }
        currentType = type
        if let questionV = questionViews.first(where: { $0.type == type }) {
            view.addSubview(questionV)
        }
        questionViews.append(type.view(to: view, onNextPage: onNextPage))
    }
    func onNextPage() {
        showNewQuestion(currentType.rawValue+1)
    }
}
