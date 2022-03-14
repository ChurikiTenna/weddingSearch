//
//  SelectTypeOfVideo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct MovieData: Codable {
    var photoMovie = ""
    var endroll = ""
}

class SelectTypeOfVideo: QuestionView {
    
    override var type: QuestionType { .typeOfVideo }
    
    var movieData = MovieData() {
        didSet {
            checkDone(check: {
                if movieData.photoMovie.isEmpty { return false }
                if movieData.endroll.isEmpty { return false }
                return true
            })
        }
    }
    
    override func setUI(y: inout CGFloat) {
        y = halfImage(imageName: "page29")
        _=selectionField(y: &y, title: "フォトムービーは必要ですか？", options: ["必要","不要"], onSelect: { str in
            self.movieData.photoMovie = str
        })
        _=selectionField(y: &y, title: "撮って出しエンドロールは必要ですか？", options: ["必要","不要"], onSelect: { str in
            self.movieData.endroll = str
        })
        let texts = ["・フォトムービーとは、オープニングや新郎新婦の紹介で使われる演出ムービーです",
                    "・撮って出しは、挙式当日の流れを1日追う記録撮影を指します"]
        bottomTexts(y: &y, text: texts.joined(separator: "\n\n"))
    }
}
