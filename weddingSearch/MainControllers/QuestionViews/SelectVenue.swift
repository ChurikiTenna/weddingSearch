//
//  SelectVenue.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/15.
//

import UIKit

struct VenueInfo: Codable {
    var prefecture = ""
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
    var nameBtns = [UIButton]()
    func prefecture(idx: Int) -> String {
        var pref = self.venueInfos[idx].prefecture
        if pref.isEmpty { pref = "no" }
        pref.removeLast()
        return pref
    }
    
    let venueSearch = VenueSearch()
    func venues(_ idx: Int) -> [String] {
        print("self.venueInfos[idx].head", self.venueInfos[idx].prefecture)
        let pref = prefecture(idx: idx)
        return venueSearch.venues
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
        })
        nameBtns.append(selectionField(y: &y, btnTitle: .selectVenueName, options: nil))
        nameBtns[idx].addAction(action: {
            print("possibles", self.possibles)
            let vc = VenueSearchController(options: self.possibles[idx]) { str in
                self.venueInfos[idx].name = str
                self.nameBtns[idx].setTitle(str, for: .normal)
            }
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
class AllPrefecture {
        
    static let hokkaido_tohoku = ["北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"]
    static let kanto = ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県"]
    static let hokuriku_kousinetsu = ["新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県"]
    static let tokai = ["岐阜県", "静岡県", "愛知県", "三重県"]
    static let kinki = ["滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"]
    static let chugoku_shikoku = ["鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県"]
    static let kyushu_okinawa = ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]

    internal static let jp: KeyValuePairs = ["北海道・東北": hokkaido_tohoku, "関東": kanto, "北陸・甲信越": hokuriku_kousinetsu, "東海": tokai, "近畿": kinki, "中国・四国": chugoku_shikoku, "九州・沖縄": kyushu_okinawa, "海外": ["海外"]]
    
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
    
    var venues = [(prefecture: String, name: String)]()
    
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
                if venue.count < 2 { continue }
                venues.append((prefecture: venue[0], name: venue[1]))
            }
        } catch let error as NSError {
            print("エラー: \(error)")
            return
        }
    }
}

class VenueSearchController: BasicViewController {
    
    let onSelected: (String) -> Void
    let options: [String]
    var optionBtns = [UIButton]()
    var searchF: SearchFieldView!
    var availables: [String] {
        if searchF.text==nil || searchF.text!.isEmpty { return options }
        else { return options.filter({ $0.contains(searchF.text!) }) }
    }
    
    init(options: [String], onSelected: @escaping (String) -> Void) {
        self.options = options
        self.onSelected = onSelected
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("式場を選択", y: 0, withClose: true)
        var y = head.maxY+1
        searchF = SearchFieldView(full_rect(h: 50, y: &y), placeholder: "式場名で検索", searchDelegate: self, to: view)
        
        setScrollView(y: searchF.maxY)
        reloadBtns()
    }
    func reloadBtns() {
        optionBtns.forEach({ $0.removeFromSuperview() })
        optionBtns = []
        
        var y = CGFloat()
        availables.forEach { str in
            let btn = UIButton(CGRect(x: 20, y: y+10, w: self.view.w-40, h: 60), color: .white, to: self.scroll)
            btn.round(20)
            btn.addAction {
                self.onSelected(str)
                self.dismissSelf()
            }
            _ = UILabel(CGRect(x: 20, w: btn.w-40, h: btn.h),
                        text: str, font: .bold, textSize: 15, textColor: .darkGray, lines: -1, align: .center, to: btn)
            self.optionBtns.append(btn)
            y = btn.maxY
        }
        scroll.contentSize.height = y+40
    }
}
extension VenueSearchController: SearchFieldViewDelegate {
    func searchTextDidChange() {
        DispatchQueue.main.async {
            self.reloadBtns()
        }
    }
    
    func doSearch() {
        
    }
    
    func doBegin() {
        
    }
    
    
}
