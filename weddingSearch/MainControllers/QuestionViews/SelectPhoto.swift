//
//  SelectPhoto.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

class SelectPhoto: QuestionView {
    
    var type: QuestionType { .photoToTake }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page28")
        selectionField(y: &y, title: "スナップアルバムは必要ですか？", onTap: {
            
        })
        selectionField(y: &y, title: "型物写真は必要ですか？", onTap: {
            
        })
        selectionField(y: &y, title: "式場で前撮り撮影を行いますか？", onTap: {
            
        })
        let texts = ["・スナップアルバムとは式の写真を製本したもので、200~300カットが一般的です",
                     "・型物写真とはフォトスタジオで撮影する記念写真(2~3ポーズ)を指します"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
