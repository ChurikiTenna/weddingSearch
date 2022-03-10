//
//  SelectVenue.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/15.
//

import UIKit

class SelectVenueView: QuestionView {
    
    init(to view: UIView, onNext: @escaping () -> Void) {
        super.init(type: .selectVenue, to: view, onNext: onNext)
    }
    override func setUI(y: inout CGFloat) {
        venueSet(idx: 1, y: &y)
        venueSet(idx: 2, y: &y)
        venueSet(idx: 3, y: &y)
    }
    func venueSet(idx: Int, y: inout CGFloat) {
        let lbl = UILabel.grayTtl(.colorBtn(centerX: w/2, y: y), ttl: "式場\(idx)", to: self)
        y = lbl.maxY
        let prefectureB = UIButton.dropBtn(.colorBtn(centerX: w/2, y: y), text: "都道府県を選択", to: self) {
            
        }
        y = prefectureB.maxY+10
        let headAlphabetB = UIButton.dropBtn(.colorBtn(centerX: w/2, y: y), text: "式場の頭文字を選択", to: self) {
            
        }
        y = headAlphabetB.maxY+10
        let venueNameB = UIButton.dropBtn(.colorBtn(centerX: w/2, y: y), text: "式場名を選択", to: self) {
            
        }
        y = venueNameB.maxY+10
    }
}
