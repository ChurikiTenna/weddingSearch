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
    
    var venueInfos = [VenueInfo(),VenueInfo(),VenueInfo()]
    
    var prefBtns = [UIButton]()
    var nameHBtns = [UIButton]()
    var nameBtns = [UIButton]()
    
    override func setUI(y: inout CGFloat) {
        venueSet(idx: 0, y: &y)
        venueSet(idx: 1, y: &y)
        venueSet(idx: 2, y: &y)
    }
    func venueSet(idx: Int, y: inout CGFloat) {
        prefBtns.append(selectionField(y: &y, title: "式場\(idx+1)", btnTitle: .selectPrefecture, options: nil))
        prefBtns[idx].addAction(action: {
            let vc = OptionWithHeadersViewController(ttl: "都道府県を選択", options: Prefecture.jp) { str in
                print("OptionWithHeadersViewController")
                self.venueInfos[idx].prefecture = str
                self.prefBtns[idx].setTitle(str, for: .normal)
            }
            self.parentViewController.present(vc, animated: true)
            //self.parentViewController.presentFull(vc) nazeka questionViewが閉じる
        })
        nameHBtns.append(selectionField(y: &y, btnTitle: .selectVenueHeadC, options: [], onSelect: { str in
            
        }))
        nameBtns.append(selectionField(y: &y, btnTitle: .selectVenueName, options: [], onSelect: { str in
            
        }))
    }
}

/// 都道府県データ
class Prefecture {
    static let hokkaido_tohoku = ["北海道", "青森県", "岩手県", "宮城県", "秋田県", "山形県", "福島県"]
    static let kanto = ["茨城県", "栃木県", "群馬県", "埼玉県", "千葉県", "東京都", "神奈川県"]
    static let hokuriku_kousinetsu = ["新潟県", "富山県", "石川県", "福井県", "山梨県", "長野県"]
    static let tokai = ["岐阜県", "静岡県", "愛知県", "三重県"]
    static let kinki = ["滋賀県", "京都府", "大阪府", "兵庫県", "奈良県", "和歌山県"]
    static let chugoku_shikoku = ["鳥取県", "島根県", "岡山県", "広島県", "山口県", "徳島県", "香川県", "愛媛県", "高知県"]
    static let kyushu_okinawa = ["福岡県", "佐賀県", "長崎県", "熊本県", "大分県", "宮崎県", "鹿児島県", "沖縄県"]
    
    internal static let jp = [(title: "北海道・東北", texts: hokkaido_tohoku),
                             (title: "関東", texts: kanto),
                             (title: "北陸・甲信越", texts: hokuriku_kousinetsu),
                             (title: "東海", texts: tokai),
                             (title: "近畿", texts: kinki),
                             (title: "中国・四国", texts: chugoku_shikoku),
                             (title: "九州・沖縄", texts: kyushu_okinawa)]
}
