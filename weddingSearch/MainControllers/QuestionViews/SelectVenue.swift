//
//  SelectVenue.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/15.
//

import UIKit

class SelectVenueView: QuestionView {
    
    override var type: QuestionType { .selectVenue }
    
    override func setUI(y: inout CGFloat) {
        venueSet(idx: 1, y: &y)
        venueSet(idx: 2, y: &y)
        venueSet(idx: 3, y: &y)
    }
    func venueSet(idx: Int, y: inout CGFloat) {
        selectionField(y: &y, title: "式場\(idx)", btnTitle: .selectPrefecture, onTap: {
            
        })
        selectionField(y: &y, btnTitle: .selectVenueHeadC, onTap: {
            
        })
        selectionField(y: &y, btnTitle: .selectVenueName, onTap: {
            
        })
    }
}
