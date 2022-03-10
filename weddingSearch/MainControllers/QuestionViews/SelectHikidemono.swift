//
//  SelectHikidemono.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectHikidemono: QuestionView {
    
    var type: QuestionType { .hikidemono }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page27")
        selectionField(y: &y, title: "引出物", btnTitle: .selectPrice, onTap: {
            
        })
        selectionField(y: &y, title: "引菓子", btnTitle: .selectPrice, onTap: {
            
        })
        let texts = ["・引出物はゲストに配られる贈呈品のことで、カタログギフトや食器等が一般的です",
                     "・引菓子は、引出物と一緒に贈られるお菓子のことです"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
