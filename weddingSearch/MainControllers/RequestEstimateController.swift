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
    func getView(type: QuestionType) -> QuestionView? {
        return questionViews.first(where: { $0.type == type })
    }
    func getV<T: QuestionView>(_: T.Type) -> T? {
        for questionView in questionViews {
            if let questionView = questionView as? T { return questionView }
        }
        return nil
    }
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .superPaleBackGray
        
        header("見積もり依頼", withClose: false)
        
        let lbl = UILabel(CGRect(x: 30, y: head.maxY, w: view.w-60, h: 300), textSize: 20, lines: -1, to: view)
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
        
        Ref.user(uid: SignIn.uid!) { user in
            self.user = user
            if user == nil {
                _ = LogInView(to: self.view)
            }
        }
    }
    func resetQViews() {
        while self.questionViews.count > 0 {
            self.questionViews[0].removeFromSuperview()
            self.questionViews.remove(at: 0)
        }
    }
    func showNewQuestion(_ idx: Int) {
        if idx < 0 {
            resetQViews()
            return
        }
        print("showNewQuestion", idx, currentType.rawValue)
        guard let type = QuestionType(rawValue: idx) else {
            view.endEditing(true)
            _ = DetailEnterDoneView(to: view, onDone: {
                print("remove allquestionViews")
                DispatchQueue.main.async {
                    self.resetQViews()
                }
            })
            guard let user = user else { return }
            for venueInfo in self.getV(SelectVenueView.self)?.venueInfos ?? [] {
                if venueInfo.name.isEmpty { continue }
                let data = RequestData(userId: SignIn.uid!,
                                       userInfo: user,
                                       venueInfo: venueInfo,
                                       basicInfo: self.getV(SelectBasicInfo.self)?.basicInfoData,
                                       foodPrice: self.getV(SelectFoodPriceView.self)?.foodPrice,
                                       drinkData: self.getV(SelectDrink.self)?.drinkData,
                                       kyoshiki: self.getV(SelectKyoshiki.self)?.kyoshiki,
                                       flowerData: self.getV(SelectFlower.self)?.flowerData,
                                       otherFlowerData: self.getV(SelectOtherFlower.self)?.otherFlowerData,
                                       itemData: self.getV(SelectItems.self)?.itemData,
                                       hikidemonoData: self.getV(SelectHikidemono.self)?.hikidemonoData,
                                       photoData: self.getV(SelectPhoto.self)?.photoData,
                                       movieData: self.getV(SelectTypeOfVideo.self)?.movieData,
                                       brideClothingData: self.getV(SelectBrideClothing.self)?.clothingData,
                                       groomClothingData: self.getV(SelectGroomClothing.self)?.clothingData,
                                       parentClothingData: self.getV(SelectParentClothing.self)?.clothingData,
                                       other: self.getV(EnterOtherInfo.self)?.textV.text)
                
                Ref.sendRequest(data) { e in
                    if let e = e {
                        self.showAlert(title: "データの送信に失敗しました", message: e.localizedDescription)
                    } else {
                        NotificationCenter.default.post(name: .didPostRequest, object: nil)
                    }
                }
            }
            return
        }
        let lastType = currentType
        currentType = type
        if let questionV = getView(type: type) {
            if lastType.rawValue < currentType.rawValue {
                questionV.slideIn(to: view, fromRight: true)
            } else {
                questionV.slideIn(to: view, fromRight: false)
            }
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
        
        let lbl = UILabel(CGRect(x: 40, y: 60, w: view.w-80, h: 300), textSize: 20, lines: -1, to: self)
        let attr = NSMutableAttributedString(string: "ご回答ありがとうございました。\n見積が届くまで、お待ちください。\n",
                                             attributes: [.foregroundColor : UIColor.black])
        attr.appendParaStyle(align: .center, lineSpacing: 4)
        lbl.attributedText = attr
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus != .authorized {
                DispatchQueue.main.async {
                    _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-180), text: "プッシュ通知ON", to: self) {
                        
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                            return
                        }
                        if UIApplication.shared.canOpenURL(settingsUrl) {
                            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                                print("Settings opened: \(success)") // Prints true
                            })
                        }
                    }
                    let attr = NSMutableAttributedString(string: "ご回答ありがとうございました。\n見積が届くまで、お待ちください。\n",
                                                         attributes: [.foregroundColor : UIColor.black])
                    attr.append(NSAttributedString(string: "(プッシュ通知をONにしていただくと、\n更新時にすぐ気づくことができます)",
                                                   attributes: [.foregroundColor : UIColor.themeColor,
                                                                    .font: Font.normal.with(15)]))
                    attr.appendParaStyle(align: .center, lineSpacing: 4)
                    lbl.attributedText = attr
                }
                
            }
        }
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-120), text: "ホームに戻る", to: self) {
            self.closeSelf()
            onDone()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
