//
//  AdminMenuController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import Foundation

class AdminMenuController: BasicViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("管理者ページ", withClose: false)
        
        setScrollView(y: head.maxY)
    }
}
