//
//  CheckInspecitionController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import UIKit

class CheckInspecitionController: BasicViewController {
    
    var request: (objc: RequestData, id: String)
    
    init(request: (objc: RequestData, id: String)) {
        self.request = request
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("見学日程", withClose: true)
        subHeader(text: request.objc.venueInfo?.name ?? "nil")
        
    }
}
