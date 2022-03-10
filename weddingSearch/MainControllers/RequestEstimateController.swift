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
        
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-120), text: "登録する", to: view, action: {
            self.showNewQuestion(0)
        })
    }
    func showNewQuestion(_ idx: Int) {
        print("showNewQuestion", idx, currentType.rawValue)
        guard let type = QuestionType(rawValue: idx) else {
            _ = DetailEnterDoneView(to: view, onDone: {
                print("remove allquestionViews")
                while self.questionViews.count > 0 {
                    self.questionViews[0].removeFromSuperview()
                    self.questionViews.remove(at: 0)
                }
            })
            //todo send to firebase
            return
        }
        currentType = type
        if let questionV = questionViews.first(where: { $0.type == type }) {
            view.addSubview(questionV)
        } else {
            questionViews.append(type.view(to: view, onBack: onBack, onNext: onNext))
        }
        
    }
    func onNext() {
        showNewQuestion(currentType.rawValue+1)
    }
    func onBack() {
        showNewQuestion(currentType.rawValue-1)
    }
}

class DetailEnterDoneView: UIView {
    
    init(to view: UIView, onDone: @escaping () -> Void) {
        super.init(frame: view.fitRect)
        view.addSubview(self)
        backgroundColor = .superPaleBackGray
        
        let lbl = UILabel(CGRect(x: 40, y: 60, w: view.w-80, h: 300), textSize: 20, lines: -1, to: view)
        let attr = NSMutableAttributedString(string: "ご回答ありがとうございました。\n見積が届くまで、お待ちください。",
                                             attributes: [.foregroundColor : UIColor.black])
        attr.append(NSAttributedString(string: "(プッシュ通知をONにしていただくと、\n更新時にすぐ気づくことができます)",
                                       attributes: [.foregroundColor : UIColor.themeColor,
                                                        .font: Font.normal.with(15)]))
        attr.appendParaStyle(align: .center, lineSpacing: 4)
        lbl.attributedText = attr
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-180), text: "プッシュ通知ON", to: view) {
                    let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                    UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { authorized, error in
                        self.closeSelf()
                        onDone()
                    }
                }
            }
        }
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-120), text: "ホームに戻る", to: view) {
            self.closeSelf()
            onDone()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
