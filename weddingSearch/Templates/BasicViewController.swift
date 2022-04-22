//
//  BasicViewController.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/13.
//

import UIKit

class BasicViewController: UIViewController {
    
    var headerGrad: UIView?
    var notFoundLbl: UILabel?
    var head: UILabel!
    var subHeadV: UIView!
    var subHead: UILabel!
    
    var kindlbls = [String]()
    var kindLbl: UILabel!
    var pankuzuBtns = [UIButton_round]()
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    override var shouldAutorotate: Bool { return false }
    
    func subHeader(text: String?) {
        subHeadV = UIView(CGRect(y: head.maxY, w: view.w, h: 50), color: .themePale, to: view)
        subHead = UILabel(CGRect(x: 20, w: view.w-120, h: subHeadV.h), textSize: 16, to: subHeadV)
        if let text = text {
            subHead.attributedText = NSAttributedString(string: text,
                                                        attributes: [.font : Font.bold.with(16),
                                                                    .foregroundColor: UIColor.themeColor])
        }
    }
    func headBtns(kindlbls: [String], selected: @escaping (Int) -> Void) {
        self.kindlbls = kindlbls
        setKindLbl(kindlbls[0])
        
        var x = view.w-100
        for i in 0..<kindlbls.count {
            let btn = UIButton_round(CGRect(x: x, y: kindLbl.center.y-20, w: 40, h: 40), to: view)
            btn.addAction {
                self.select_pankuzuBtns(i)
                selected(i)
            }
            pankuzuBtns.append(btn)
            x = btn.maxX
        }
        for idx in 0..<self.pankuzuBtns.count {
            self.pankuzuBtns[idx].selected(0==idx)
        }
    }
    func select_pankuzuBtns(_ i: Int) {
        self.kindLbl.text = kindlbls[i]
        for idx in 0..<self.pankuzuBtns.count {
            self.pankuzuBtns[idx].selected(i==idx)
        }
    }
    func setKindLbl(_ text: String) {
        kindLbl = UILabel(CGRect(x: 30, y: (subHeadV?.maxY ?? subHead?.maxY ?? head.maxY)+10, w: view.w-100, h: 60),
                          text: text, font: .bold, textSize: 24, to: view)
    }
    override func viewWillAppear(_ animated: Bool) {
        overrideUserInterfaceStyle = .light
        if view.backgroundColor == nil { view.backgroundColor = .white }
    }
    /// table notfound
    func showNotFound(_ arry: [Any]?, text: String, y: CGFloat? = nil) -> Int {
        notFoundLbl?.removeFromSuperview()
        if arry == nil || arry!.count == 0 {
            notFoundLbl = UILabel(CGRect(x: 50, y: y != nil ? y! : view.h/2-40, w: view.w-100, h: 40),
                                  text: text, textColor: .gray, lines: 2, align: .center,
                                  to: view)
            return 0
        }
        return arry!.count
    }
    //scroll
    var scroll: UIScrollView!
    func setScrollView(y: CGFloat) {
        scroll = UIScrollView(CGRect(y: y, w: view.w, h: view.h-y), to: view)
        scroll.alwaysBounceVertical = true
    }
    //rect
    func center_rect(h: CGFloat, y: inout CGFloat, plusY: CGFloat = 20) -> CGRect {
        let r = CGRect(x: 60, y: y, w: view.w-120, h: h)
        y = r.maxY+plusY
        return r
    }
    func full_rect(h: CGFloat, y: inout CGFloat, plusY: CGFloat = 20) -> CGRect {
        return .full_rect(y: &y, h: h, view: view)
    }
    func fill_rect(h: CGFloat, y: inout CGFloat, plusY: CGFloat = 20) -> CGRect {
        let r = CGRect(y: y, w: view.w, h: h)
        y = r.maxY+plusY
        return r
    }
    func half_rect(left: Bool, h: CGFloat, y: inout CGFloat) -> CGRect {
        if left {
            return .left_rect(h: h, y: &y, view: view)
        } else {
            return .right_rect(h: h, y: &y, view: view)
        }
    }
    //header
    func subHeader(_ title: String, y: inout CGFloat) -> UIView {
        let v = UIView(CGRect(y: y, w: view.w, h: 50), to: scroll)
        _ = UILabel(CGRect(x: 20, w: view.w-40, h: v.h), text: title, textSize: 18, textColor: .themeColor, to: v)
        y = v.maxY
        return v
    }
    func header(_ ttl: String, y: CGFloat = s.minY, withClose: Bool) {
        head = view.header(ttl, y: y)
        if withClose {
            _=UIButton.closeBtn(to: view, y: y+10, action: dismissSelf)
        }
    }
    // 待ってる途中
    var gray: UIView!
    var maru: UIView!
    
    var waiting = false {
        didSet {
            if waiting, oldValue != waiting {
                view.isUserInteractionEnabled = false
                gray?.removeFromSuperview()
                gray = UIView.grayBack(to: view, alpha: 0.2)
                maru = UIView(CGRect(x: view.w, y: view.h/2-10, w: 20, h: 20),
                              color: .white,
                              to: gray)
                maru.round(0.5)
                animateWaiting()
            }
        }
    }
    func animateWaiting() {
        if view.frame.midX < maru.frame.origin.x {
            maru.center.x = view.w/2-30
        } else {
            maru.center.x += 30
        }
        DispatchQueue.main.asyncAfter(deadline: .now()+0.2) {
            if self.waiting {
                self.animateWaiting()
            } else {
                self.view.isUserInteractionEnabled = true
                self.gray.removeFromSuperview()
            }
        }
    }
}

// tableview専用viewcontroller
class TableViewController: BasicViewController {
    
    var notFound: UILabel!
    var ttl = ""
    var notFoundTitle = ""
    
    var noMore = false
    //var last: DocumentSnapshot?
    var withClose = true
    
    var cellHeight = [IndexPath: CGFloat]()
    var tableView: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        if tableView != nil { return }
        super.viewDidAppear(true)
        
        header(ttl, withClose: withClose)
        head.adjustsFontSizeToFitWidth = false
        
        tableView = UITableView(CGRect(y: head.maxY+1, w: view.w, h: view.h-head.maxY-1), color: .white, to: view)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.sectionHeaderTopPadding = 0
        tableView.addRefreshControll(target: self, action: #selector(refresh))
    }
    @objc func refresh() { tableView.refreshControl?.endRefreshing() }
    func getMore() {}
    func makeCell(for idx: IndexPath) -> UITableViewCell? { return nil }
    func componentCount() -> Int { return 0 }
}
extension TableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        // 一番下までスクロールしていないなら無視する
        if !(indexPath.row >= componentCount() - 1 && tableView.isDragging) { return }
        getMore()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notFound?.removeFromSuperview()
        if componentCount() == 0 {
            notFound = UILabel(tableView.frame, text: notFoundTitle, textColor: .gray, align: .center, to: view)
        }
        return componentCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: indexPath)!
        cell.selectionStyle = .none
        cell.backgroundColor = .white
        tableView.rowHeight = cell.h
        cellHeight[indexPath] = cell.h
        return cell
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight[indexPath] ?? 300
    }
}
