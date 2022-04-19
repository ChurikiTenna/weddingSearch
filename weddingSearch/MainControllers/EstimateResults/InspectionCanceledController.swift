//
//  InspectionCanceledController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/29.
//

import UIKit

class InspectionCanceledController: BasicViewController {
    
    var request: (objc: RequestData, id: String)
    
    init(request: (objc: RequestData, id: String)) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("見学日程", withClose: true)
        subHeader(text: request.objc.venueInfo?.name ?? "nil")
        setKindLbl("見学日程")
        
        _ = UILabel(CGRect(x: 30, y: kindLbl.maxY+30, w: view.w-60, h: 200),
                  text: "日程調整の結果、ご希望の時間帯で\n予約することができませんでした。\nお手数ですが、下記の問合せから\n再度、希望日を教えてくださいませ。",
                  textSize: 20, lines: -1, to: view)
        
        _ = UIButton.lineInquiry(y: s.maxY-60, to: view)
    }
}

class InspectionDecidedController: BasicViewController {
    
    var request: (objc: RequestData, id: String)
    
    init(request: (objc: RequestData, id: String)) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("見学日程", withClose: true)
        subHeader(text: request.objc.venueInfo?.name ?? "nil")
        setKindLbl("見学日程")
        
        
        let greyBtn = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: kindLbl.maxY+20),
                                          text: "日時確定", color: .themePale, to: view, action: {})
        greyBtn.setTitleColor(.themeColor, for: .normal)
        greyBtn.isUserInteractionEnabled = false
        
        _ = UILabel(.colorBtn(centerX: view.w/2, y: greyBtn.maxY+20),
                    text: request.objc.reserveDate?.toFullString() ?? "", font: .bold, textSize: 20, align: .center, to: view)
        
        let tank = UILabel(.colorBtn(centerX: view.w/2, y: greyBtn.maxY+80),
                    text: "ご予約誠にありがとうございました。当日はご予約の時間に合わせて結婚式場を訪問いただき、受付にてお名前とマイチャペルで見学予約した旨をお伝えください。ご準備いただくものは特にございません。",
                    textSize: 16, textColor: .gray, lines: -1, to: view)
        tank.fitHeight()
        
        _ = UILabel(.colorBtn(centerX: view.w/2, y: s.maxY-120),
                    text: "日程変更や見学キャンセル等は\n以下よりお願いいたします。",
                    textSize: 16, textColor: .gray, lines: 2, align: .center, to: view)
        _ = UIButton.lineInquiry(y: s.maxY-60, to: view)
    }
}
