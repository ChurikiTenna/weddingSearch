//
//  SelectBasicInfo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct BasicInfoData: Codable {
    var pplToInvite = ""
    var childToInvite = "000"
    var season = ""
    var budget = ""
}

class SelectBasicInfo: QuestionView {
    
    override var type: QuestionType { .basicInfo }
    
    var basicInfoData = BasicInfoData() {
        didSet {
            checkDone(check: {
                if basicInfoData.pplToInvite.isEmpty { return false }
                if basicInfoData.season.isEmpty { return false }
                if basicInfoData.budget.isEmpty { return false }
                return true
            })
        }
    }
    
    var pplBtn: Drum3View!
    var childBtn: Drum3View!
    var seasonBtn: UIButton!
    var budgetBtn: UIButton!
    
    override func setUI(y: inout CGFloat) {
        print("SelectBasicInfoh", frame)
        // ppls
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5, execute: {
            self.isScrollEnabled = false
            self.contentInset.top = s.minY
        })
        let small = frame.height < 700
        if small {
            y -= 40
        } else {
            y -= 20
        }
        let lbl = UILabel.grayTtl(.colorBtn(centerX: w/2, y: y), ttl: "パーティーの招待人数は？", to: self)
        y = lbl.maxY + (small ? -10 : 0)
        pplBtn = Drum3View(.drumBtn(centerX: w/2, y: y), to: self, didBPMchanged: {
            self.basicInfoData.pplToInvite = "\(self.pplBtn.bgm)"
        })
        y = pplBtn.maxY
        let lbl2 = UILabel.grayTtl(.colorBtn(centerX: w/2, y: y), ttl: "うち、子供の数は？", to: self)
        y = lbl2.maxY + (small ? -10 : 0)
        childBtn = Drum3View(.drumBtn(centerX: w/2, y: y), to: self, didBPMchanged: {
            self.basicInfoData.childToInvite = "\(self.childBtn.bgm)"
        })
        y = childBtn.maxY
        // season
        var seasons = [String]()
        for i in 1...12 {
            seasons.append("\(i)月")
        }
        seasonBtn = selectionField(y: &y, margin: (small ? -10 : 0), title: "結婚式の時期は？", btnTitle: .selectSeason,
                                   options: ["3ヵ月以内","半年以内","半年～1年後","1年以上先","未定"]) { str in
            self.basicInfoData.season = str
        }
        // budget
        let budgetRange = RangeHelper.shared.rangeFrom([100,150,200,250,300,350,400,450,500])
        let budgets = RangeHelper.shared.toText(from: budgetRange, unit: "万円") + ["未定"]
        budgetBtn = selectionField(y: &y, margin: (small ? -10 : 0), title: "結婚式のご予算は？（式場に支払う総額）", btnTitle: .selectPrice, options: budgets) { str in
            self.basicInfoData.budget = str
        }
        if small {
            y -= 20
        }
    }
}

class RangeHelper {
    
    static let shared = RangeHelper()
    
    let rangeMax = 99999999999999.0
    
    func rangeFrom(_ array: [Int], min: Int = 0) -> [Range<Int>] {
        var range = [Range<Int>]()
        var last = min
        for value in array {
            range.append(last..<value)
            last = value
        }
        range.append(last..<Int(rangeMax))
        return range
    }
    func toText(from ranges: [Range<Int>], unit: String) -> [String] {
        var texts = [String]()
        for range in ranges {
            let lower = "\(range.lowerBound)"
            let upper = "\(range.upperBound-1)"
            if range.lowerBound == 0 {
                texts.append("\(upper)\(unit)未満")
            } else if range.upperBound == Int(rangeMax) {
                texts.append("\(lower)\(unit)以上")
            } else {
                texts.append("\(lower)〜\(upper)\(unit)")
            }
        }
        return texts
    }
    
    func rangeFrom(_ array: [Double], min: Double = 0) -> [Range<Double>] {
        var range = [Range<Double>]()
        var last = min
        for value in array {
            range.append(last..<value)
            last = value
        }
        range.append(last..<rangeMax)
        return range
    }
    func toText(from ranges: [Range<Double>], unit: String) -> [String] {
        var texts = [String]()
        let minus = ranges.first?.lowerBound ?? 0 <= 2 ? 0.1 : 1
        for range in ranges {
            let lowerV = range.lowerBound
            let lower = Double(Int(lowerV))==lowerV ? "\(Int(lowerV))" : "\(lowerV)"
            let upperV = range.upperBound-minus
            let upper = Double(Int(upperV))==upperV ? "\(Int(upperV))" : "\(upperV)"
            if range.upperBound == rangeMax {
                texts.append("\(lower)\(unit)以上")
            } else {
                texts.append("\(lower)〜\(upper)\(unit)")
            }
        }
        return texts
    }
}
