//
//  ViewController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/02.
//

import UIKit

class ViewController: UITabBarController {
    
    var vcs = [UIViewController]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //SignIn.logout()
        overrideUserInterfaceStyle = .light
        
        NotificationCenter.addObserver(self, action: #selector(setUI), name: .logInStatusUpdated)
        
        tabBar.tintColor = .black
        tabBar.layer.borderWidth = 0
        tabBar.clipsToBounds = true
        //UITabBar.appearance().barTintColor = .white
        let appearance = UITabBarAppearance()
        appearance.backgroundColor = .white
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        
    }
    @objc func setUI() {
        vcs = []
        
        let vc0 = HomeController()
        vc0.tabBarItem = UITabBarItem(title: "ホーム", image: UIImage(systemName: "house"), tag: 0)
        //vc0.tabBarItem.selectedImage = UIImage(named: "asobu_s")
        vcs.append(vc0)
        
        let vc1 = RequestEstimateController()
        vc1.tabBarItem = UITabBarItem(title: "見積もり依頼", image: UIImage(systemName: "doc.text.magnifyingglass"), tag: 1)
        //vc1.tabBarItem.selectedImage = UIImage(named: "myPage_s")
        vcs.append(vc1)
        
        let vc2 = MyPageController()
        vc2.tabBarItem = UITabBarItem(title: "マイページ", image: UIImage(systemName: "person"), tag: 1)
        //vc2.tabBarItem.selectedImage = UIImage(named: "myPage_s")
        vcs.append(vc2)

        self.viewControllers = vcs.map { UINavigationController(rootViewController: $0) }
        self.setViewControllers(vcs, animated: false)
    }
    override func viewDidAppear(_ animated: Bool) {
        s = view.safeAreaLayoutGuide.layoutFrame
        view.backgroundColor = .white
        if SignIn.uid == nil {
            let vc = FirstController()
            vc.modalPresentationStyle = .fullScreen
            present(vc, animated: false)
        } else {
            setUI()
        }
    }
}

class FirstController: BasicViewController {
    
    var pages = [(image: "page2", title: "気になる式場の費用がわかる！",
                  sub: "ユーザーが入力した条件に基づいて、\n概算費用をお返しします"),
                 (image: "page3", title: "最終見積もりの金額に近い！",
                  sub: "過去の各式場の価格データを用いているため、\n最終的な金額とブレが少ない参考価格です"),
                 (image: "page4", title: "時間を節約できる！",
                  sub: "見学のときは数時間拘束されがち…\n式場に足を運ばなくても\n短時間で欲しい情報を集められます"),
                 (image: "page5", title: "アプリで見学予約までできる！",
                  sub: "見積結果を見て実際に見学したい\n式場があれば、アプリを使って\nその場で予約しましょう"),
                 (image: "page6", title: "さっそく\nマイチャペをはじめましょう！",
                  sub: "プライバシーポリシーと利用規約に同意して")]
    var pageIdx = 0
    
    var base: UIView!
    var imgV: UIImageView!
    var idxIcons = [UIView]()
    var titleL: UILabel!
    var subL: UILabel!
    
    var startBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        base = UIView(s, to: view)
        base.isUserInteractionEnabled = false
        let titleY = base.h-200
        imgV = UIImageView(CGRect(x: view.w/2-160, y: (titleY-320)/2, w: 320, h: 320), name: "", to: base)
        
        let count = CGFloat(pages.count)
        var x = (view.w-count*6-(count-1)*20)/2
        for _ in 0..<pages.count {
            let round = UIView(CGRect(x: x, y: titleY-20+base.minY, w: 6, h: 6), color: .superPaleGray, to: view)
            round.round()
            self.idxIcons.append(round)
            x = round.maxX+20
        }
        titleL = UILabel(CGRect(x: 40, y: titleY, w: view.w-80, h: 60),
                         font: .bold, textSize: 20, lines: -1, align: .center, to: base)
        subL = UILabel(CGRect(x: 40, y: titleL.maxY+10, w: view.w-80),
                       textSize: 16, lines: -1, align: .center, to: base)
        
        view.addSwipe(self, action: #selector(swiped))
        NotificationCenter.addObserver(self, action: #selector(didLogIn), name: .logInStatusUpdated)
        
        movePage(0)
    }
    @objc func didLogIn() {
        self.dismissSelf()
    }
    var startX = CGFloat()
    @objc func swiped(sender: UISwipeGestureRecognizer) {
        print("swiped")
        let x = sender.location(in: view).x
        switch sender.state {
        case .began: startX = x
        case .changed: base.frame.origin.x = x-startX
        case .ended:
            if base.frame.origin.x > 0, 0 < pageIdx {
                UIView.animate(withDuration: 0.2) {
                    self.base.frame.origin.x = self.view.w
                } completion: { Bool in
                    self.base.frame.origin.x = -self.view.w
                    self.movePage(self.pageIdx-1)
                    UIView.animate(withDuration: 0.2) {
                        self.base.frame.origin.x = 0
                    }
                }
            } else if base.frame.origin.x < 0, pageIdx < pages.count-1 {
                UIView.animate(withDuration: 0.2) {
                    self.base.frame.origin.x = -self.view.w
                } completion: { Bool in
                    self.base.frame.origin.x = self.view.w
                    self.movePage(self.pageIdx+1)
                    UIView.animate(withDuration: 0.2) {
                        self.base.frame.origin.x = 0
                    }
                }
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.base.frame.origin.x = 0
                }
            }
        default: break
        }
    }
    func movePage(_ idx: Int) {
        self.pageIdx = idx
        imgV.image = UIImage(named: pages[idx].image)
        for i in 0..<idxIcons.count {
            idxIcons[i].backgroundColor = i==idx ? .themeColor : .superPaleGray
        }
        titleL.text = pages[idx].title
        subL.text = pages[idx].sub
        subL.fitHeight()
        
        startBtn?.removeFromSuperview()
        if idx == pages.count-1 {
            startBtn = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: s.maxY-60), text: "はじめる", to: view, action: {
                _ = LogInView(to: self.view)
            })
            let attr = NSMutableAttributedString(string: "プライバシーポリシー", attributes: [.foregroundColor : UIColor.link])
            attr.append(NSAttributedString(string: "と", attributes: [.foregroundColor : UIColor.black]))
            attr.append(NSAttributedString(string: "利用規約", attributes: [.foregroundColor : UIColor.link]))
            attr.append(NSAttributedString(string: "に同意して", attributes: [.foregroundColor : UIColor.black]))
            subL.attributedText = attr
        }
    }
}
