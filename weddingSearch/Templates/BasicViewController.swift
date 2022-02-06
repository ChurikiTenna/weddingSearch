//
//  BasicViewController.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/13.
//

import UIKit

var safe: CGRect!

class BasicViewController: UIViewController {
    
    var headerGrad: UIView?
    var notFoundLbl: UILabel?
    var head: UILabel!
    
    override func viewWillAppear(_ animated: Bool) {
        overrideUserInterfaceStyle = .light
        view.backgroundColor = .themeSuperPale
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
        scroll = UIScrollView(CGRect(y: y, w: view.w, h: view.h-y), to: view, insert: 0)
        scroll.alwaysBounceVertical = true
    }
    //rect
    func center_rect(h: CGFloat, y: inout CGFloat, plusY: CGFloat = 20) -> CGRect {
        let r = CGRect(x: 60, y: y, w: view.w-120, h: h)
        y = r.maxY+plusY
        return r
    }
    func textF_rect(y: inout CGFloat, plusY: CGFloat = 20) -> CGRect {
        return .textF_rect(y: &y, plusY: plusY, view: view)
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
    func header(_ ttl: String, withClose: Bool, s: CGRect? = nil) {
        head = view.header(ttl, y: s?.minY ?? safe.minY)
        if withClose {
            _=UIButton.closeBtn(to: view, y: safe.minY+10, action: dismissSelf)
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

// CollectionView専用viewcontroller
class CollectionViewController: BasicViewController {
    
    var collectionView: UICollectionView!
    
    var notFound: UILabel!
    var ttl = ""
    var notFoundTitle = ""
    
    var noMore = false
    //var last: DocumentSnapshot?
    var withClose = true
    
    override func viewWillAppear(_ animated: Bool) {
        if collectionView != nil { return }
        super.viewWillAppear(animated)
        if safe != nil { initMe() }
    }
    override func viewDidAppear(_ animated: Bool) {
        if collectionView != nil { return }
        super.viewDidAppear(animated)
        if safe == nil { safe = view.safeAreaLayoutGuide.layoutFrame }
        initMe()
    }
    private func initMe() {
        header(ttl, withClose: withClose)
        
        let rect = CGRect(x: 5, y: head.maxY+1, w: view.w-10, h: safe.maxY-head.maxY-1)
        var my_layer = UICollectionViewFlowLayout()
        my_layer.scrollDirection = .vertical
        my_layer.itemSize = CGSize(width: rect.width/2-2.5, height: rect.width)
        my_layer.minimumInteritemSpacing = 5
        my_layer.minimumLineSpacing = 5
        layer(&my_layer)
        collectionView = UICollectionView(frame: rect, collectionViewLayout: my_layer)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        view.addSubview(collectionView)
    }
    func layer(_ layer: inout UICollectionViewFlowLayout) { }
    @objc func refresh() { collectionView.refreshControl?.endRefreshing() }
    func getMore() {}
    func makeCell(for idx: IndexPath) -> UICollectionViewCell? { return nil }
    func componentCount() -> Int { return 0 }
}
extension CollectionViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        notFound?.removeFromSuperview()
        if componentCount() == 0 {
            notFound = UILabel(collectionView.frame, text: notFoundTitle, textColor: .gray, align: .center, to: view)
        }
        return componentCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = makeCell(for: indexPath)!
        cell.backgroundColor = .white
        return cell
    }
}
