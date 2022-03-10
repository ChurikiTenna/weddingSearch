//
//  QuestionView.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/15.
//

import UIKit

enum QuestionType: Int, CaseIterable {
    case selectVenue
    case basicInfo
    case foodPrice
    case needDrinkQ
    case knoshiki
    case flowerPrice
    case otherFlower
    case otherItems
    case hikidemono
    case photoToTake
    case typeOfVideo
    case brideClothing
    case groomClothing
    case parentClothing
    case otherInfo
    
    var question: String {
        switch self {
        case .selectVenue: return "Q1. 金額を見積もりたい式場を\nお選びください(最大3式場まで)"
        case .basicInfo: return "Q2. 以下の基本情報について\n教えてください"
        case .foodPrice: return "Q3. 披露宴で出す\nコース料理の料金は?"
        case .needDrinkQ: return "Q4. 以下の飲み物は必要ですか?"
        case .knoshiki: return "Q5. 挙式は行いますか?"
        case .flowerPrice: return "Q6. 必要な装花とそれぞれの予算を教えてください"
        case .otherFlower: return "Q7. 以下のお花は必要ですか?予算と合わせて教えてください"
        case .otherItems: return "Q8. 次のアイテムはどのように手配しますか?"
        case .hikidemono: return "Q9. 引出物と引菓子の予算を教えてください"
        case .photoToTake: return "Q10. 撮影する写真について教えてください"
        case .typeOfVideo: return "Q11. 撮影するビデオについて教えてください"
        case .brideClothing: return "Q12. 新婦衣装の手配方法を教えてください"
        case .groomClothing: return "Q13. 新郎衣装の手配方法を教えてください"
        case .parentClothing: return "Q14. ご両親の衣装と数量を教えてください"
        case .otherInfo: return "Q15.その他にマイチャペに伝えたいことがあれば教えてください\n (例: 見積を知りたい式場がなかったなど、何でも大丈夫です)"
        }
    }
    func view(to v: UIView, onBack: @escaping () -> Void, onNext: @escaping () -> Void) -> QuestionView {
        switch self {
        case .selectVenue: return SelectVenueView(to: v, onBack: onBack, onNext: onNext)
        case .basicInfo: return SelectBasicInfo(to: v, onBack: onBack, onNext: onNext)
        case .foodPrice: return SelectFoodPriceView(to: v, onBack: onBack, onNext: onNext)
        case .needDrinkQ: return SelectDrink(to: v, onBack: onBack, onNext: onNext)
        case .flowerPrice: return SelectFlower(to: v, onBack: onBack, onNext: onNext)
        case .otherFlower: return SelectOtherFlower(to: v, onBack: onBack, onNext: onNext)
        case .knoshiki: return SelectKyoshiki(to: v, onBack: onBack, onNext: onNext)
        case .otherItems: return SelectItems(to: v, onBack: onBack, onNext: onNext)
        case .hikidemono: return SelectHikidemono(to: v, onBack: onBack, onNext: onNext)
        case .photoToTake: return SelectPhoto(to: v, onBack: onBack, onNext: onNext)
        case .typeOfVideo: return SelectTypeOfVideo(to: v, onBack: onBack, onNext: onNext)
        case .brideClothing: return SelectBrideClothing(to: v, onBack: onBack, onNext: onNext)
        case .groomClothing: return SelectGroomClothing(to: v, onBack: onBack, onNext: onNext)
        case .parentClothing: return SelectParentClothing(to: v, onBack: onBack, onNext: onNext)
        case .otherInfo: return EnterOtherInfo(to: v, onBack: onBack, onNext: onNext)
        }
    }
}

class QuestionView: UIScrollView {
    
    var type: QuestionType { fatalError() }
    
    var questionLbl: UILabel!
    var answerBtn: UIButton!
    
    let onNext: () -> Void
    
    init(to view: UIView, onBack: @escaping () -> Void, onNext: @escaping () -> Void) {
        self.onNext = onNext
        super.init(frame: view.fitRect)
        slideIn(to: view)
        backgroundColor = .superPaleBackGray
        alwaysBounceVertical = true
        
        _=UIButton.closeBtn(to: self, x: 10, y: 10, theme: .clearBlack, type: .chevronL, action: onBack)
        
        questionLbl = UILabel(CGRect(x: 50, y: 10, w: w-100, h: 0), color: UIColor(white: 1, alpha: 0.6),
                              text: type.question, font: .bold, textSize: 20, lines: -1, align: .center, to: self)
        questionLbl.fitHeight(plusH: 20)
        
        var y = questionLbl.maxY+40
        setUI(y: &y)
        
        answerBtn = UIButton.coloredBtn(.colorBtn(centerX: w/2, y: y+20), text: "回答する", to: self, action: {
            self.onNext()
        })
        contentSize.height = answerBtn.maxY+40
    }
    func setUI(y: inout CGFloat) { }
    func slideIn(to view: UIView, fromRight: Bool = true) {
        frame.origin.x = fromRight ? view.w : -view.w
        view.addSubview(self)
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = 0
        }
    }
    func slideOut() {
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.x = -self.w
        } completion: { Bool in
            self.removeFromSuperview()
        }
    }
    
    enum BtnTitleType: String {
        case selectAnswer = "回答を選択"
        case selectPrice = "金額を選択"
        case selectPpl = "人数を選択"
        case selectPrefecture = "都道府県を選択"
        case selectVenueHeadC = "式場の頭文字を選択"
        case selectVenueName = "式場名を選択"
        case selectSeason = "時期を選択"
    }
    func selectionField(y: inout CGFloat, title: String, btnTitle: BtnTitleType = .selectAnswer,
                        options: [String]?, onSelect: ((String) -> Void)? = nil) -> UIButton {
        let lbl = UILabel.grayTtl(.colorBtn(centerX: w/2, y: y), ttl: title, to: self)
        y = lbl.maxY
        return selectionField(y: &y, btnTitle: btnTitle, options: options, onSelect: onSelect)
    }
    func selectionField(y: inout CGFloat, btnTitle: BtnTitleType = .selectAnswer,
                        options: [String]?, onSelect: ((String) -> Void)? = nil) -> UIButton {
        let field = UIButton.dropBtn(.colorBtn(centerX: w/2, y: y), text: btnTitle.rawValue, to: self, action: nil)
        y = field.maxY+10
        if let options = options {
            field.addAction(action: {
                let vc = OptionViewController(ttl: btnTitle.rawValue, options: options, selectedIdx: nil, selected: { str in
                    onSelect!(str)
                    field.setTitle(str, for: .normal)
                })
                self.parentViewController.present(vc, animated: true)
            })
        }
        
        return field
    }
    func halfImage(imageName: String) -> CGFloat {
        let imgV = UIImageView(CGRect(x: 0, y: 0, w: w, h: 400), name: imageName, mode: .scaleAspectFill, to: self)
        insertSubview(imgV, at: 0)
        return imgV.maxY+10
    }
    func bottomTexts(y: inout CGFloat, text: String) {
        let lbl = UILabel(CGRect(x: 40, y: y, w: w-80),
                          text: text, textSize: 15, textColor: .gray, lines: -1, to: self)
        lbl.fitHeight()
        y = lbl.maxY+10
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
