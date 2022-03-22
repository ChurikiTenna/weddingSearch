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
    var pages = [RequestTableView]()
    
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
        
        kindLbl = UILabel(CGRect(x: 30, y: statusV.maxY+10, w: view.w-100, h: 60),
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
        let rect = CGRect(x: 0, y: kindLbl.maxY+10, w: view.w, h: view.h-kindLbl.maxY)
        pages.append(RequestTableView_new(rect, to: view))
        pages.append(RequestTableView_done(rect, to: view))
        
        pageSelected(0)
    }
    func pageSelected(_ idx: Int) {
        kindLbl.text = kindlbls[idx]
        for i in 0..<pankuzuBtns.count {
            pankuzuBtns[i].selected(i==idx)
        }
        for i in 0..<pages.count {
            pages[i].isHidden = idx != i
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

class RequestTableView_new: RequestTableView {
    
    @objc override func refresh() {
        super.refresh()
        guard let uid = SignIn.uid else { return }
        Ref.requests
            .whereField("userId", isEqualTo: uid)
            .whereField("done", isEqualTo: RequestState.resulted.rawValue)
            .getDocuments(RequestData.self) { snap, requests in
            self.requests = requests
            self.reloadData()
        }
    }
}
class RequestTableView_done: RequestTableView {
    
    @objc override func refresh() {
        super.refresh()
        guard let uid = SignIn.uid else { return }
        Ref.requests
            .whereField("userId", isEqualTo: uid)
            .whereField("done", isEqualTo: RequestState.requested.rawValue)
            .getDocuments(RequestData.self) { snap, requests in
            self.requests = requests
            self.reloadData()
        }
    }
}
class RequestTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var requests = [(objc: RequestData, id: String)]()
    var notFoundLbl: UILabel!
    
    init(_ f: CGRect, to view: UIView) {
        super.init(frame: f, style: .plain)
        view.addSubview(self)
        dataSource = self
        delegate = self
        separatorStyle = .none
        sectionHeaderTopPadding = 0
        contentInset.top = 10
        contentInset.bottom = 100
        register(EstimateCell.self)
        addRefreshControll(target: self, action: #selector(refresh))
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPostRequest, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // for override
    @objc func refresh() {
        refreshControl?.endRefreshing()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notFoundLbl?.removeFromSuperview()
        if requests.count == 0 {
            notFoundLbl = UILabel(CGRect(w: w, h: 60), text: "※まだ案件が登録されておりません",
                                  textSize: 15, textColor: .lightGray, lines: 2, align: .center, to: self)
        }
        return requests.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EstimateCell.self, indexPath: indexPath)
        cell.setUI(request: requests[indexPath.row], w: w, onDelete: {
            self.showAlert(title: "この見積もり依頼を消去しますか？", message: "", btnTitle: "消去", cancelBtnTitle: "キャンセル") {
                Ref.requests.document(self.requests[indexPath.row].id).delete(completion: {_ in 
                    self.refresh()
                })
            }
        })
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
}
class EstimateCell: UITableViewCell {
    
    var base: UIView!
    var weddingNameLbl: UILabel!
    var deleteBtn: UIButton!
    var seeResultLbl: UIButton!
    var yoyakuLbl: UIButton!
    
    var onDelete: (() -> Void)!
    
    func setUI(request: (objc: RequestData, id: String), w: CGFloat, onDelete: @escaping () -> Void) {
        self.onDelete = onDelete
        
        if base == nil {
            base = UIView(CGRect(x: 30, y: 5, w: w-60, h: 150), color: .white, to: contentView)
            base.round(16, clip: true)
            base.border(.superPaleGray, width: 2)
            
            let head = UIView(CGRect(w: base.w, h: 60), color: .themePale, to: base)
            
            weddingNameLbl = UILabel(CGRect(x: 20, y: 0, w: head.w-80, h: head.h), font: .bold, textColor: .darkText, to: head)
            deleteBtn = ImageBtn(CGPoint(x: head.w-50, y: 10), image: .multiply, width: 40, theme: .clearTheme, to: head)
            deleteBtn.addAction(action: {
                self.onDelete()
            })
            
            let y = head.maxY+20
            let wd = (base.w-50)/2
            seeResultLbl = UIButton.coloredBtn(CGRect(x: 20, y: y, w: wd, h: 50), text: "結果を見る", to: base, action: {
                
            })
            yoyakuLbl = UIButton.coloredBtn(CGRect(x: base.w/2+5, y: y, w: wd, h: 50), text: "見学予約する", to: base, action: {
                
            })
        }
        weddingNameLbl.text = request.objc.venueInfo?.name
        if request.objc.done == RequestState.requested.rawValue {
            self.seeResultLbl.backgroundColor = .superPaleGray
            self.yoyakuLbl.backgroundColor = .superPaleGray
        } else {
            self.seeResultLbl.backgroundColor = .themeColor
            self.yoyakuLbl.backgroundColor = .themeColor
        }
    }
}
extension NSNotification.Name {
    static let didPostRequest = NSNotification.Name("didPostRequest")
}
