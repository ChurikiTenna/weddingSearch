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
            .getDocuments(RequestData.self) { snap, requests in
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
        let vc = EstimateDetailController_admin(request: requests[indexPath.row], onDone: {
            self.requests.remove(at: indexPath.row)
            self.reloadData()
        })
        self.parentViewController.presentFull(vc)
    }
}

