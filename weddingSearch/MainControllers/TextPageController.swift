//
//  TextPageController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/04/18.
//

import UIKit

class TextPageController: BasicViewController {
    
    var contents: [(ttl: String, content: [String])]
    var ttl: String
    
    init(ttl: String, contents: [(ttl: String, content: [String])]) {
        self.contents = contents
        self.ttl = ttl
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header(ttl, withClose: true)
        
        setScrollView(y: head.maxY)
        var y = CGFloat()
        for content in contents {
            y += 10
            let ttlLbl = UILabel(CGRect(x: 30, y: y, w: view.w-60, h: 30),
                                 text: content.ttl, font: .bold, textSize: 18, lines: -1, to: scroll)
            for content in content.content {
                let contentLbl = UILabel(CGRect(x: 30, y: ttlLbl.maxY, w: view.w-60, h: 0),
                                         text: content, textSize: 16, textColor: .gray, lines: -1, to: scroll)
                contentLbl.fitHeight()
                y = contentLbl.maxY
            }
            _ = UIView(CGRect(x: 20, y: y, w: view.w-40, h: 1), color: .superPaleGray, to: scroll)
        }
        scroll.contentSize.height = y+40
    }
}
