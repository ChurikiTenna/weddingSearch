//
//  SelectVenue.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/15.
//

import UIKit

struct VenueInfo: Codable {
    var prefecture = ""
    var head = ""
    var name = ""
}

class SelectVenueView: QuestionView {
    
    override var type: QuestionType { .selectVenue }
    
    var venueInfos = [VenueInfo(),VenueInfo(),VenueInfo()] {
        didSet {
            checkDone(check: {
                // at least one name
                for venue in venueInfos {
                    if !venue.name.isEmpty { return true }
                }
                return false
            })
        }
    }
    var possibles = [[String](),[String](),[String]()] {
        didSet {
            print("possibles", possibles)
        }
    }
    
    var prefBtns = [UIButton]()
    var nameHBtns = [UIButton]()
    var nameBtns = [UIButton]()
    func prefecture(idx: Int) -> String {
        var pref = self.venueInfos[idx].prefecture
        if pref.isEmpty { pref = "no" }
        pref.removeLast()
        return pref
    }
    
    let venueSearch = VenueSearch()
    func venues(_ idx: Int) -> [String] {
        print("self.venueInfos[idx].head", self.venueInfos[idx].head, self.venueInfos[idx].prefecture)
        var pref = prefecture(idx: idx)
        return venueSearch.venues
        .filter({ $0.head == self.venueInfos[idx].head })
        .filter({ $0.prefecture.contains(pref) }) // 「県」は入っていないけど「道」は入ってるので
        .map({ $0.name })
    }
    
    override func setUI(y: inout CGFloat) {
        venueSet(idx: 0, y: &y)
        venueSet(idx: 1, y: &y)
        venueSet(idx: 2, y: &y)
    }
    func venueSet(idx: Int, y: inout CGFloat) {
        prefBtns.append(selectionField(y: &y, title: "式場\(idx+1)", btnTitle: .selectPrefecture, options: nil))
        prefBtns[idx].addAction(action: {
            let vc = OptionWithHeadersViewController(ttl: "都道府県を選択", options: Prefecture.jp) { str in
                self.venueInfos[idx].prefecture = str
                self.prefBtns[idx].setTitle(str, for: .normal)
                self.didResetHeadOrPref(idx)
            }
            self.parentViewController.present(vc, animated: true)
            //self.parentViewController.presentFull(vc) nazeka questionViewが閉じる
        })
        nameHBtns.append(selectionField(y: &y, btnTitle: .selectVenueHeadC, options: nil))
        nameHBtns[idx].addAction(action: {
            var kanas = Katakana().kanas
            let pref = self.prefecture(idx: idx)
            let venues = self.venueSearch.venues.filter({ $0.prefecture.contains(pref) })
            
            for i in 0..<kanas.count {
                for kana in kanas[i] {
                    if !venues.contains(where: { $0.head == kana }) {
                        guard let idx = kanas[i].firstIndex(of: kana) else { continue }
                        kanas[i].remove(at: idx)
                    }
                }
            }
            let vc = GridOptionController(ttl: "頭文字を選択",
                                          options: Katakana().kanas,
                                          valid: kanas,
                                          selectedBef: self.venueInfos[idx].head,
                                          selected: { str in
                self.venueInfos[idx].head = str
                self.nameHBtns[idx].setTitle(str, for: .normal)
                self.didResetHeadOrPref(idx)
            })
            self.parentViewController.present(vc, animated: true)
        })
        nameBtns.append(selectionField(y: &y, btnTitle: .selectVenueName, options: nil))
        nameBtns[idx].addAction(action: {
            print("possibles", self.possibles)
            let vc = OptionViewController(ttl: "式場名を選択",
                                          options: self.possibles[idx],
                                          selectedIdx: nil,
                                          selected: { str in
                self.venueInfos[idx].name = str
                self.nameBtns[idx].setTitle(str, for: .normal)
            })
            self.parentViewController.present(vc, animated: true)
        })
    }
    func didResetHeadOrPref(_ idx: Int) {
        possibles[idx] = self.venues(idx)
        if possibles[idx].count == 0 {
            self.nameBtns[idx].setTitle("式場がありません", for: .normal)
            self.nameBtns[idx].setTitleColor(.gray, for: .normal)
        } else {
            self.nameBtns[idx].setTitle(BtnTitleType.selectVenueName.rawValue, for: .normal)
            self.nameBtns[idx].setTitleColor(.black, for: .normal)
        }
        self.venueInfos[idx].name = ""
    }
}

/// 都道府県データ
class Prefecture {
    static let hokkaido_tohoku = ["北海道"]
    static let kanto = ["埼玉県", "千葉県", "東京都", "神奈川県"]
    static let hokuriku_kousinetsu = ["長野県"]
    static let tokai = ["静岡県", "愛知県"]
    static let kinki = ["京都府", "大阪府", "兵庫県"]
    //static let chugoku_shikoku = []
    static let kyushu_okinawa = ["福岡県", "沖縄県"]
    
    internal static let jp = [(title: "北海道・東北", texts: hokkaido_tohoku),
                             (title: "関東", texts: kanto),
                             (title: "北陸・甲信越", texts: hokuriku_kousinetsu),
                             (title: "東海", texts: tokai),
                             (title: "近畿", texts: kinki),
                             //(title: "中国・四国", texts: chugoku_shikoku),
                             (title: "九州・沖縄", texts: kyushu_okinawa)]
}
class Katakana {
    let kanas = [["ア","イ","ウ","エ","オ"],
                ["カ","キ","ク","ケ","コ"],
                ["サ","シ","ス","セ","ソ"],
                ["タ","チ","ツ","テ","ト"],
                ["ナ","ニ","ヌ","ネ","ノ"],
                ["ハ","ヒ","フ","ヘ","ホ"],
                ["マ","ミ","ム","メ","モ"],
                ["ヤ","ユ","ヨ"],
                ["ラ","リ","ル","レ","ロ"],
                ["ワ","ヲ","ン"]]
}
class VenueSearch {
    
    var venues = [(prefecture: String, head: String, name: String)]()
    
    init() {
        
        guard let path = Bundle.main.path(forResource:"venues", ofType:"csv") else {
            print("csvファイルがないよ")
            return
        }
        do {
            let csvString = try String(contentsOfFile: path, encoding: String.Encoding.utf8)
            let csvLines = csvString.components(separatedBy: .newlines)
            for data in csvLines {
                let venue = data.components(separatedBy: ",")
                //print("venue", venue)
                if venue.count < 3 { continue }
                venues.append((prefecture: venue[0], head: venue[1], name: venue[2]))
            }
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
    }
}
