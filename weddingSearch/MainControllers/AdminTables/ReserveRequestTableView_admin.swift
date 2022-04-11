//
//  ReserveRequestTableView_admin.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/29.
//

import UIKit

class ReserveRequestTableView_admin: UITableView, UITableViewDelegate, UITableViewDataSource {
    
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
        register(EdtimateCell_admin.self)
        addRefreshControll(target: self, action: #selector(refresh))
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPostRequest, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func refresh() {
        refreshControl?.endRefreshing()
        Ref.requests
            .whereField("done", isEqualTo: RequestState.reserveRequested.rawValue)
            .order(by: "requestedAt", descending: true)
            .getDocuments(RequestData.self) { snap, requests in
                var requests = requests
                RequestData.removeOld(from: &requests)
                self.requests = requests
                self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notFoundLbl?.removeFromSuperview()
        if requests.count == 0 {
            notFoundLbl = UILabel(CGRect(w: w, h: 60), text: "※予約待ちの依頼がありません",
                                  textSize: 15, textColor: .lightGray, lines: 2, align: .center, to: self)
        }
        return requests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EdtimateCell_admin.self, indexPath: indexPath)
        cell.setUI(request: requests[indexPath.row], w: w)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        let request = requests[indexPath.row]
        let vc = ReserveCheckController_admin(request: request, onDone: {
            Ref.sendNotification(userId: request.objc.userId, docID: request.id, type: .inspectionReserveDone,
                                 message: "\(request.objc.venueInfo?.name ?? "")の見学予約日程が確定しました。", onSuccess: {})
            self.requests.remove(at: indexPath.row)
            self.reloadData()
        })
        self.parentViewController.presentFull(vc)
    }
}

class ReserveCheckController_admin: BasicViewController {
    
    var request: (objc: RequestData, id: String)
    let onDone: () -> Void
    
    init(request: (objc: RequestData, id: String), onDone: @escaping () -> Void) {
        self.request = request
        self.onDone = onDone
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        header("希望予約日程", withClose: true)
        subHeader(text: request.objc.venueInfo?.name)
        
        var y = subHeadV.maxY+40
        for reserveKibou in request.objc.reserveKibou ?? [] {
            let btn = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: y), text: reserveKibou.toFullString(), to: view) {
                self.showAlert(title: reserveKibou.toFullString(), message: "上記の日程で決定しますか？", btnTitle: "決定", cancelBtnTitle: "キャンセル") {
                    self.request.objc.done = RequestState.reserveDecided.rawValue
                    self.request.objc.reserveDate = reserveKibou
                    try! Ref.requests.document(self.request.id).setData(from: self.request.objc)
                    self.dismissSelf()
                    self.onDone()
                }
            }
            y = btn.maxY+20
        }
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: y), text: "希望に合う日程がない", color: .lightGray, to: view) {
            self.showAlert(title: "希望に合う日程がない", message: "", btnTitle: "送信", cancelBtnTitle: "キャンセル") {
                self.request.objc.done = RequestState.reserveCanceled.rawValue
                try! Ref.requests.document(self.request.id).setData(from: self.request.objc)
                self.dismissSelf()
                self.onDone()
            }
        }
    }
}
