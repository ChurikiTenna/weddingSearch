//
//  RequestEstimateController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

class RequestEstimateController: BasicViewController {
    
    var questionViews = [QuestionView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .superPaleBackGray
        
        header("見積もり依頼", withClose: false)
        
        let lbl = UILabel(CGRect(x: 40, y: head.maxY, w: view.w-80, h: 300), textSize: 18, lines: -1, align: .center, to: view)
        let attr = NSMutableAttributedString(string: "気になる式場と希望条件を登録して\n見積もり費用を調べてみましょう\n（目安時間：",
                                             attributes: [.foregroundColor : UIColor.black])
        attr.append(NSAttributedString(string: "10分", attributes: [.foregroundColor : UIColor.themeColor]))
        attr.append(NSAttributedString(string: "、設問数：", attributes: [.foregroundColor : UIColor.black]))
        attr.append(NSAttributedString(string: "15問", attributes: [.foregroundColor : UIColor.themeColor]))
        attr.append(NSAttributedString(string: "）", attributes: [.foregroundColor : UIColor.black]))
        lbl.attributedText = attr
        
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-120), text: "登録する", to: view) {
            self.showNewQuestion(0)
        }
    }
    
    func showNewQuestion(_ idx: Int) {
        guard let type = QuestionType(rawValue: idx) else {
            return
        }
        if let questionV = questionViews.first(where: { $0.type == type }) {
            print("have", type.rawValue)
            view.addSubview(questionV)
            return
        }
        switch type {
        case .selectVenue:
            let v = SelectVenueView(type: type, to: view, onNext: { self.showNewQuestion(idx+1) })
            questionViews.append(v)
        case .basicInfo:
            break
        case .foodPrice:
            break
        }
    }
}
