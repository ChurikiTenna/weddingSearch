//
//  HomeController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

class HomeController: BasicViewController {
    
    var kindlbls = ["見積もり完了", "見積もり作成中"]
    var kindLbl: UILabel!
    var pankuzuBtns = [UIButton_round]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("ホーム", withClose: false)
        
        let statusV = UIView(CGRect(y: head.maxY, w: view.w, h: 50), color: .themePale, to: view)
        let stateLbl = UILabel(CGRect(x: 20, w: view.w-40, h: statusV.h), textSize: 16, to: statusV)
        let attr = NSMutableAttributedString(string: "見積り完了：", attributes: [.foregroundColor : UIColor.black])
        attr.append(NSAttributedString(string: "0件", attributes: [.foregroundColor : UIColor.themeColor]))
        attr.append(NSAttributedString(string: "、見積り中：", attributes: [.foregroundColor : UIColor.black]))
        attr.append(NSAttributedString(string: "0件", attributes: [.foregroundColor : UIColor.themeColor]))
        stateLbl.attributedText = attr
        
        kindLbl = UILabel(CGRect(x: 20, y: statusV.maxY, w: view.w-100, h: 60),
                          text: "", font: .bold, textSize: 24, to: view)
        var x = view.w-100
        for i in 0..<kindlbls.count {
            let btn = UIButton_round(CGRect(x: x, y: kindLbl.center.y-20, w: 40, h: 40), to: view)
            btn.addAction {
                self.pageSelected(i)
            }
            pankuzuBtns.append(btn)
            x = btn.maxX
        }
        
        pageSelected(0)
    }
    func pageSelected(_ idx: Int) {
        kindLbl.text = kindlbls[idx]
        for i in 0..<pankuzuBtns.count {
            pankuzuBtns[i].selected(i==idx)
        }
    }
}
class UIButton_round: UIButton {
    
    private var roundV: UIView!
    
    init(_ f: CGRect, to view: UIView) {
        super.init(frame: f)
        view.addSubview(self)
        roundV = UIView(CGRect(x: w/2-5, y: h/2-5, w: 10, h: 10), color: .lightGray, to: self)
        roundV.round()
        roundV.isUserInteractionEnabled = false
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selected(_ bool: Bool) {
        roundV.backgroundColor = bool ? .themeColor : .superPaleGray
    }
}
