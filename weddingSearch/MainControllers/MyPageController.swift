//
//  MyPageController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//


import UIKit
/*
 todo 番号認証機能を反映
 todo カバーする地域は13都道府県だけでOK
 todo 人数情報（成人/こども）の入力方法変更
 todo 見積もり完了以降の流れを今後Update
 todo No.1から通しで確認できるようにしていただく
 */
class MyPageController: BasicViewController {
    
    enum Rows: CaseIterable {
        case term
        case privacy
        case questions
        case evaluateApp
        case inquiry
        case logout
        
        var title: String {
            switch self {
            case .term: return "利用規約"
            case .privacy: return "プライバシーポリシー"
            case .questions: return "よくある質問"
            case .evaluateApp: return "アプリを評価する"
            case .inquiry: return "お問い合わせ（LINE）"
            case .logout: return "ログアウト"
            }
        }
        var image: String {
            switch self {
            case .term: return "doc.text"
            case .privacy: return "lock.fill"
            case .questions: return "questionmark.app"
            case .evaluateApp: return "star.fill"
            case .inquiry: return "line"
            case .logout: return ""
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("マイページ", withClose: false)
        
        setScrollView(y: head.maxY)
        var y = CGFloat()
        for row in Rows.allCases {
            let btn = UIButton(CGRect(y: y, w: view.w, h: 60), to: scroll)
            let icon = UIImageView(CGRect(x: btn.h*0.3, y: btn.h*0.3, w: btn.h*0.4, h: btn.h*0.4),
                                   name: row.image, mode: .scaleAspectFit, tint: .black, to: btn)
            _ = UILabel(CGRect(x: icon.maxX+20, w: 200, h: btn.h),
                        text: row.title, textSize: 17, to: btn)
            btn.underBar()
            btn.addAction {
                switch row {
                case .logout:
                    SignIn.logout()
                case .term:
                    break
                case .privacy:
                    break
                case .questions:
                    break
                case .evaluateApp:
                    break
                case .inquiry:
                    break
                }
            }
            y = btn.maxY
        }
        scroll.contentSize.height = y+70
    }
}
