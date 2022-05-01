//
//  MyPageController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

class MyPageController: BasicViewController {
    
    enum Rows: CaseIterable {
        case term
        case privacy
        case questions
        case evaluateApp
        case inquiry
        #if DEBUG
        case logout
        #endif
        
        var title: String {
            switch self {
            case .term: return "利用規約"
            case .privacy: return "プライバシーポリシー"
            case .questions: return "よくある質問"
            case .evaluateApp: return "アプリを評価する"
            case .inquiry: return "お問い合わせ（LINE）"
            #if DEBUG
            case .logout: return "ログアウト"
            #endif
            }
        }
        var image: String {
            switch self {
            case .term: return "doc.text"
            case .privacy: return "lock.fill"
            case .questions: return "questionmark.app"
            case .evaluateApp: return "star.fill"
            case .inquiry: return "line"
            #if DEBUG
            case .logout: return ""
            #endif
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
#if DEBUG
                case .logout:
                    self.showAlert(title: "ログアウトしますか？", btnTitle: "ログアウト", cancelBtnTitle: "キャンセル") {
                        SignIn.logout()
                    }
#endif
                case .term:
                    self.open_kiyaku()
                case .privacy:
                    self.open_kojinjouhouhogo()
                case .questions:
                    let vc = TextPageController(ttl: "FAQ", contents:
                        [(ttl: "Q. マイチャペはどういうアプリですか？",
                          content: ["結婚式場の概算見積もりを簡単にアプリ上で閲覧することができるアプリです。金額を知りたい結婚式場がマイチャペに登録されているか、まずは見積もり依頼フォームから確認してみましょう"]),
                         (ttl: "Q. マイチャペは有料でしょうか？",
                          content: ["無料でお使いいただけます"]),
                         (ttl: "Q. 概算見積もりとは何ですか？",
                          content: ["概算見積もりとは、ユーザー様の希望条件に対し、結婚式にかかる代金を大まかに算出した金額のことです"]),
                         (ttl: "Q. マイチャペで出される見積もり金額は結婚式場が作っているものですか？",
                          content: ["いいえ、あくまでマイチャペが作成する参考価格であり、式場が出している公式価格ではございません"]),
                         (ttl: "Q. 概算見積もりがあると、何が嬉しいですか？",
                          content: ["結婚式場に直接足を運ばなくても、複数の結婚式場の見積もり金額をアプリで簡単に得ることができます"]),
                         (ttl: "Q. 見積もりを得るためにはどうすればよいですか？",
                          content: ["所定の見積もり依頼フォームからご希望の条件をご回答してください"]),
                         (ttl: "Q. 見積もり依頼フォームはどのような内容でしょうか？",
                          content: ["あなたの結婚式に対する希望をお伺いする内容で、主に金額影響が大きい費目に関する設問で構成されております。一部、結婚式を挙げる際にマストで発生する費目や金額的に軽微な費目は含まれておりません。"]),
                         (ttl: "Q. 見積もりは複数得られるのでしょうか？", content: ["1回の見積もり依頼につき、最大3式場までお問合せいただくことが可能です"]),
                         (ttl: "Q. 見積もりはどのように作っているのでしょうか？",
                          content: ["対象となる結婚式場などの価格データをマイチャペが独自で分析し、見積を作成しております"]),
                         (ttl: "Q. 見積もりの中に割引キャンペーンや日柄は考慮されていますか？",
                          content: ["いいえ、あくまで参考価格のため上記は反映されておりません。また、オリジナル性やカスタム性が高い演出やパフォーマンスも、見積もりには含まれておりません"]),
                         (ttl: "Q. マイチャペを使えば、日本全国の結婚式場の見積もり費用を調べることができますか？",
                          content: ["いいえ、マイチャペに登録されている結婚式場のみ、お調べすることができます"]),
                         (ttl: "Q. 見積もりを得たい式場がマイチャペに登録されていない場合は、どうすればよいでしょうか？",
                          content: ["申し訳ございません、すぐに見積もりをお出しすることが難しいです。ご意見反映のため、お手数ですが問い合わせ用LINEまでご連絡いただけますと幸いです"]),
                         (ttl: "Q. マイチャペを通じ、納得のいく結婚式場が見つかりました。どうすればよいでしょうか？",
                          content: ["まずは対象となる式場の見学予約を行い（マイチャペ上で行えます）、実際に足を運んでみましょう。気になったことや不明点は式場に直接聞いてみましょう"]),
                         (ttl: "Q. マイチャペに掲載されている式場はチャペルのみでしょうか？",
                          content: ["いいえ、教会チャペルのみならず、ホテルやゲストハウスなどジャンル問わず様々な式場が登録されております"]),
                         (ttl: "Q. 見積もりを得るまでにかかる所要時間は？",
                          content: ["見積もり依頼を頂いてから通常数時間以内、遅くとも翌日までにはお返しいたします"])])
                        self.presentFull(vc)
                case .evaluateApp:
                    guard let url = URL(string: "https://itunes.apple.com/jp/app/id1615359139?mt=8") else { return }
                    if UIApplication.shared.canOpenURL(url) {
                        UIApplication.shared.open(url)
                    }
                case .inquiry:
                    self.openLineContact()
                }
            }
            y = btn.maxY
        }
        scroll.contentSize.height = y+70
    }
}
