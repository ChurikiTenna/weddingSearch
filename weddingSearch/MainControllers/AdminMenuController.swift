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
        pages.append(RequestTableView_admin(rect, to: view))
        pages.append(ReserveRequestTableView_admin(rect, to: view))
        
        pageSelected(0)
    }
    func pageSelected(_ idx: Int) {
        for i in 0..<self.pages.count {
            self.pages[i].isHidden = idx != i
        }
    }
}
