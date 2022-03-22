//
//  ReserveInspectionController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import Foundation

class ReserveInspectionController: BasicViewController {
    
    let request: (objc: RequestData, id: String)
    
    init(request: (objc: RequestData, id: String)) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        
    }
}
