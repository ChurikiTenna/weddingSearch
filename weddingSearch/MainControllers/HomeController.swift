//
//  HomeController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

class HomeController: BasicViewController {
    
    var pages = [RequestTableView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("ホーム", withClose: false)
        subHeader(text: nil)
        headBtns(kindlbls: ["見積もり完了", "見積もり作成中"], selected: pageSelected)
        
        let rect = CGRect(x: 0, y: kindLbl.maxY+10, w: view.w, h: view.h-kindLbl.maxY)
        pages.append(RequestTableView_new(rect, to: view, onGet: onGet, onScroll: onScrollNew))
        pages.append(RequestTableView_done(rect, to: view, onGet: onGet, onScroll: onScrolDone))
        
        onGet()
        pageSelected(0)
    }
    func onScrollNew(x: CGFloat) {
        if x > 50 {
            pages[0].isUserInteractionEnabled = false
            pages[1].isHidden = false
            pages[1].frame.origin.x = view.w
            UIView.animate(withDuration: 0.2) {
                self.pages[0].frame.origin.x = -self.view.w
                self.pages[1].frame.origin.x = 0
            } completion: { Bool in
                self.pages[0].isUserInteractionEnabled = true
                self.pages[0].isHidden = true
            }
        }
        select_pankuzuBtns(1)
    }
    func onScrolDone(x: CGFloat) {
        if x < -50 {
            pages[1].isUserInteractionEnabled = false
            pages[0].isHidden = false
            pages[0].frame.origin.x = -view.w
            UIView.animate(withDuration: 0.2) {
                self.pages[0].frame.origin.x = 0
                self.pages[1].frame.origin.x = self.view.w
            } completion: { Bool in
                self.pages[1].isUserInteractionEnabled = true
                self.pages[1].isHidden = true
            }
        }
        select_pankuzuBtns(0)
    }
    @objc func onGet() {
        let attr = NSMutableAttributedString(string: "見積り完了：", attributes: [.foregroundColor : UIColor.black])
        attr.append(NSAttributedString(string: "\(pages[0].requests.count)件", attributes: [.foregroundColor : UIColor.themeColor]))
        attr.append(NSAttributedString(string: "、見積り中：", attributes: [.foregroundColor : UIColor.black]))
        attr.append(NSAttributedString(string: "\(pages[1].requests.count)件", attributes: [.foregroundColor : UIColor.themeColor]))
        subHead.attributedText = attr
    }
    func pageSelected(_ idx: Int) {
        switch idx {
        case 0: onScrolDone(x: -100)
        default: onScrollNew(x: 100)
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
            .whereField("done", isNotEqualTo: RequestState.requested.rawValue)
            .addSnapshotListener { snap, e in
                var requests = Decoder.decodeAll(RequestData.self, from: snap)
                RequestData.removeOld(from: &requests)
                self.requests = requests
                self.onGet()
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
            .addSnapshotListener { snap, e in
                var requests = Decoder.decodeAll(RequestData.self, from: snap)
                RequestData.removeOld(from: &requests)
                self.requests = requests
                self.onGet()
                self.reloadData()
        }
    }
}
class RequestTableView: UITableView, UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate {
    
    var requests = [(objc: RequestData, id: String)]()
    let onGet: () -> Void
    let onScroll: (CGFloat) -> Void
    var notFoundLbl: UILabel!
    
    init(_ f: CGRect, to view: UIView, onGet: @escaping () -> Void, onScroll: @escaping (CGFloat) -> Void) {
        self.onGet = onGet
        self.onScroll = onScroll
        super.init(frame: f, style: .plain)
        view.addSubview(self)
        dataSource = self
        delegate = self
        separatorStyle = .none
        sectionHeaderTopPadding = 0
        contentInset.top = 10
        contentInset.bottom = 100
        alwaysBounceHorizontal = true
        isDirectionalLockEnabled = true
        register(EstimateCell.self)
        register(EstimateWillBeDeletedCell.self)
        addRefreshControll(target: self, action: #selector(refresh))
        refresh()
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
            return 0
        }
        return requests.count+1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < requests.count {
            let cell = tableView.dequeueCell(EstimateCell.self, indexPath: indexPath)
            cell.setUI(request: requests[indexPath.row], w: w, onDelete: {
                self.showAlert(title: "この見積もり結果を消去しますか？", message: "", btnTitle: "消去", cancelBtnTitle: "キャンセル") {
                    Ref.requests.document(self.requests[indexPath.row].id).delete(completion: {_ in
                        self.refresh()
                    })
                }
            }, onSeeResult: {
                let vc = EstimateResultController(idx: indexPath.row, maxIdx: self.requests.count-1) { idx in
                    return self.requests[idx]
                }
                self.parentViewController.presentFull(vc)
            }, onUpdate: {
                self.refresh()
            })
            return cell
        } else {
            let cell = tableView.dequeueCell(EstimateWillBeDeletedCell.self, indexPath: indexPath)
            cell.setUI(w: w)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if contentOffset.x != 0 {
            onScroll(contentOffset.x)
        }
    }
}
class EstimateCell: UITableViewCell {
    
    var base: UIView!
    var head: UIView!
    var weddingNameLbl: UILabel!
    var deleteBtn: UIButton!
    var seeResultLbl: UIButton!
    var yoyakuLbl: UIButton!
    
    var onDelete: (() -> Void)!
    
    func setUI(request: (objc: RequestData, id: String), w: CGFloat,
               onDelete: @escaping () -> Void,
               onSeeResult: @escaping () -> Void,
               onUpdate: @escaping () -> Void) {
        self.onDelete = onDelete
        
        if base == nil {
            selectionStyle = .none
            
            base = UIView(CGRect(x: 30, y: 5, w: w-60, h: 150), color: .white, to: contentView)
            base.round(16, clip: true)
            base.border(.superPaleGray, width: 2)
            
            head = UIView(CGRect(w: base.w, h: 60), color: .themePale, to: base)
            
            weddingNameLbl = UILabel(CGRect(x: 20, y: 0, w: head.w-80, h: head.h), font: .bold, textColor: .darkText, to: head)
            deleteBtn = ImageBtn(CGPoint(x: head.w-50, y: 10), image: .multiply, width: 40, theme: .clearTheme, to: head)
            deleteBtn.addAction(action: {
                self.onDelete()
            })
            
        }
        weddingNameLbl.text = request.objc.venueInfo?.name
        
        yoyakuLbl?.removeFromSuperview()
        seeResultLbl?.removeFromSuperview()
        
        let y = head.maxY+20
        let wd = (base.w-50)/2
        seeResultLbl = UIButton.coloredBtn(CGRect(x: 20, y: y, w: wd, h: 50), text: "結果を見る", to: base, action: {
            onSeeResult()
        })
        print("request.objc._done", request.objc.done)
        if request.objc._done == .requested {
            yoyakuLbl = UIButton.coloredBtn(CGRect(x: base.w/2+5, y: y, w: wd, h: 50), text: "見学予約する", to: base, action: {})
            self.seeResultLbl.backgroundColor = .superPaleGray
            self.yoyakuLbl.backgroundColor = .superPaleGray
            self.seeResultLbl.isUserInteractionEnabled = false
            self.yoyakuLbl.isUserInteractionEnabled = false
        } else if request.objc._done == .estimated {
            yoyakuLbl = UIButton.coloredBtn(CGRect(x: base.w/2+5, y: y, w: wd, h: 50), text: "見学予約する", to: base, action: {
                let vc = ReserveInspectionController(request: request, onDone: {
                    onUpdate()
                })
                self.parentViewController.presentFull(vc)
            })
        } else {
            yoyakuLbl = UIButton.coloredBtn(CGRect(x: base.w/2+5, y: y, w: wd, h: 50), text: "見学日程", color: .brown, to: base, action: {
                switch request.objc._done {
                case .requested: break
                case .estimated: break
                case .reserveRequested:
                    let vc = CheckInspecitionController(request: request)
                    self.parentViewController.presentFull(vc)
                case .reserveCanceled:
                    let vc = InspectionCanceledController(request: request)
                    self.parentViewController.presentFull(vc)
                case .reserveDecided:
                    let vc = InspectionDecidedController(request: request)
                    self.parentViewController.presentFull(vc)
                }
            })
        }
    }
}
class EstimateWillBeDeletedCell: UITableViewCell {
    var titleLbl: UILabel!
    
    func setUI(w: CGFloat) {
        if titleLbl == nil {
            titleLbl = UILabel(CGRect(x: 30, y: 0, w: w-60, h: 20),
                               text: "※案件情報は１ヶ月後に消滅します", textSize: 15, textColor: .lightGray, align: .right, to: self)
        }
    }
}
extension NSNotification.Name {
    static let didPostRequest = NSNotification.Name("didPostRequest")
}
