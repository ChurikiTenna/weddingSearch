//
//  CheckInspecitionController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import UIKit

class CheckInspecitionController: BasicViewController {
    
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
                                          text: "日時確認中", color: .superPaleGray, to: view, action: {})
        greyBtn.setTitleColor(.lightGray, for: .normal)
        
        var y = greyBtn.maxY+30
        let datesLbl = UILabel(rect(y: &y, h: 30), text: "見学希望日程", font: .bold, textSize: 17, textColor: .darkGray, to: view)
        datesLbl.underBar()
        
        _ = UILabel(rect(y: &y, h: 100, plus: 30),
                            text: request.objc.reserveKibou!.map({ $0.dateValue().toString(format: .full) }).joined(separator: "\n\n"),
                            textSize: 16, textColor: .darkGray, lines: -1, to: view)
        
        let detailsLbl = UILabel(rect(y: &y, h: 30), text: "伝えておきたいこと", font: .bold,  textSize: 17, textColor: .darkGray, to: view)
        detailsLbl.underBar()
        
        let comment = UILabel(rect(y: &y, h: 100),
                            text: request.objc.reserveComment!,
                            textSize: 16, textColor: .darkGray, lines: -1, to: view)
        comment.fitHeight()
    }
    func rect(y: inout CGFloat, h: CGFloat, plus: CGFloat = 20) -> CGRect {
        let rect = CGRect(x: view.w/2-150, y: y, w: 300, h: h)
        y = rect.maxY+plus
        return rect
    }
}
