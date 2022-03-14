//
//  SelectBasicInfo.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/10.
//

import UIKit

struct BasicInfoData: Codable {
    var pplToInvite = ""
    var childToInvite = ""
    var season = ""
    var budget = ""
}

class SelectBasicInfo: QuestionView {
    
    override var type: QuestionType { .basicInfo }
    
    var basicInfoData = BasicInfoData() {
        didSet {
            checkDone(check: {
                if basicInfoData.pplToInvite.isEmpty { return false }
                if basicInfoData.childToInvite.isEmpty { return false }
                if basicInfoData.season.isEmpty { return false }
                if basicInfoData.budget.isEmpty { return false }
                return true
            })
        }
    }
    
    var pplBtn: UIButton!
    var childBtn: UIButton!
    var seasonBtn: UIButton!
    var budgetBtn: UIButton!
    
    override func setUI(y: inout CGFloat) {
        // ppls
        let pplRange = RangeHelper.shared.rangeFrom([10,30,60,100,200])
        let ppls = RangeHelper.shared.toText(from: pplRange, unit: "人")
        pplBtn = selectionField(y: &y, title: "パーティーの招待人数は？", btnTitle: .selectPpl, options: ppls) { str in
            self.basicInfoData.pplToInvite = str
        }
        childBtn = selectionField(y: &y, title: "うち、子供の数は？", btnTitle: .selectPpl, options: ppls) { str in
            self.basicInfoData.childToInvite = str
        }
        // season
        var seasons = [String]()
        for i in 1...12 {
            seasons.append("\(i)月")
        }
        seasonBtn = selectionField(y: &y, title: "結婚式の時期は？", btnTitle: .selectSeason, options: seasons) { str in
            self.basicInfoData.season = str
        }
        // budget
        let budgetRange = RangeHelper.shared.rangeFrom([200,250,300,350,400,500,600,800], min: 100)
        let budgets = RangeHelper.shared.toText(from: budgetRange, unit: "万円")
        budgetBtn = selectionField(y: &y, title: "結婚式のご予算は？（式場に支払う総額）", btnTitle: .selectPrice, options: budgets) { str in
            self.basicInfoData.budget = str
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
            if range.upperBound == Int(rangeMax) {
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
