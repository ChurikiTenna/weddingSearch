//
//  SelectPhoto.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct PhotoData: Codable {
    var snapAlbum = ""
    var katabutsuPhoto = ""
    var maedori = ""
}

class SelectPhoto: QuestionView {
    
    override var type: QuestionType { .photoToTake }
    
    var photoData = PhotoData()
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page28")
        _=selectionField(y: &y, title: "スナップアルバムは必要ですか？", options: ["必要","不要"], onSelect: { str in
            self.photoData.snapAlbum = str
        })
        _=selectionField(y: &y, title: "型物写真は必要ですか？", options: ["必要","不要"], onSelect: { str in
            self.photoData.katabutsuPhoto = str
        })
        _=selectionField(y: &y, title: "式場で前撮り撮影を行いますか？", options: ["行う","行わない"], onSelect: { str in
            self.photoData.maedori = str
        })
        let texts = ["・スナップアルバムとは式の写真を製本したもので、200~300カットが一般的です",
                     "・型物写真とはフォトスタジオで撮影する記念写真(2~3ポーズ)を指します"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
