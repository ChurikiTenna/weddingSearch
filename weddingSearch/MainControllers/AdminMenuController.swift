//
//  AdminMenuController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import Foundation
import UIKit

class AdminMenuController: BasicViewController {
    
    var tableView: RequestTableView_admin!
    var pages = [UITableView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("管理者ページ", withClose: false)
        
        headBtns(kindlbls: ["お見積もり依頼一覧", "日程予約依頼"], selected: pageSelected)
        
        let rect = CGRect(x: 0, y: kindLbl.maxY+10, w: view.w, h: view.h-kindLbl.maxY)
        pages.append(RequestTableView_admin(rect, to: view, onScroll: onScrollNew))
        pages.append(ReserveRequestTableView_admin(rect, to: view, onScroll: onScrolDone))
        
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
    func pageSelected(_ idx: Int) {
        switch idx {
        case 0: onScrolDone(x: -100)
        default: onScrollNew(x: 100)
        }
    }
}
