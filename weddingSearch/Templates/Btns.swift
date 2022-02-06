//
//  Btns.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/14.
//

import UIKit
// 画像ボタン

enum ImageType: String {
    case heart
    case bubble = "text.bubble"
    case highlighter
    case ellipsis
    case trash
    case camera
    case paperplane = "paperplane.fill"
    case chevronBtn
    case scissors
    case closeBtn
    case chevronR = "chevron.right"
    case chevronL2 = "chevron.left.2"
    case chevronR2 = "chevron.right.2"
    case chevronD = "chevron.down"
    case magnifyingglass
    case plus
    case q = "questionmark.circle.fill"
    
    case video = "video.fill"
    case video_slash = "video.slash.fill"
    case audio = "speaker.fill"
    case audio_slash = "speaker.slash.fill"
    case check
    case question
    case hand
    case hint
    case edit
    case miniBtn
    case square_90
    
    var systemImage: UIImage? {
        return UIImage(systemName: rawValue)
    }
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
class ImageBtn: UIButton {
    
    enum ColorType {
        case theme
        case clearTheme
        case clearBlack
        case red
        case blackBase
        case whiteBorder
        
        var tint: UIColor {
            switch self {
            case .whiteBorder: return .themeColor
            case .theme, .clearBlack: return .black
            case .red: return .systemRed
            case .blackBase: return .white
            case .clearTheme: return .themeColor
            }
        }
        var back: UIColor {
            switch self {
            case .whiteBorder: return .white
            case .theme: return .themeColor
            case .red: return .white
            case .clearBlack, .clearTheme: return .clear
            case .blackBase: return .black
            }
        }
    }
    convenience init(_ origin: CGPoint, image: ImageType, width: CGFloat = 40, theme: ColorType = .clearBlack, to view: UIView) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: width, height: width)))
        setImage(UIImage(named: image.rawValue) ?? UIImage(systemName: image.rawValue), for: .normal)
        if theme == .whiteBorder {
            border(.themeColor, width: 3)
        }
        tintColor = theme.tint
        backgroundColor = theme.back
        round(0.5)
        view.addSubview(self)
    }
    convenience init(circleBtn origin: CGPoint, title: String, width: CGFloat, to view: UIView) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: width, height: width)))
        setBackgroundImage(UIImage(named: "circleBtn"), for: .normal)
        setBackgroundImage(UIImage(named: "pushed_circleBtn"), for: .highlighted)
        setBackgroundImage(UIImage(named: "circleColorBtn"), for: .selected)
        setTitle(title)
        view.addSubview(self)
    }
    convenience init(circleBtn origin: CGPoint, image: ImageType, width: CGFloat, to view: UIView) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: width, height: width)))
        setBackgroundImage(UIImage(named: "circleBtn"), for: .normal)
        setBackgroundImage(UIImage(named: "pushed_circleBtn"), for: .highlighted)
        setBackgroundImage(UIImage(named: "circleColorBtn"), for: .selected)
        addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        addTarget(self, action: #selector(didTouchUp), for: .touchUpInside)
        setImage(image.image, for: .normal)
        view.addSubview(self)
    }
    @objc func didTouchDown() {
        contentEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 0, right: 0)
    }
    @objc func didTouchUp() {
        contentEdgeInsets = .zero
    }
    // miniBtn
    convenience init(miniBtn origin: CGPoint, title: String, to view: UIView) {
        self.init(frame: CGRect(origin: origin, size: CGSize(width: 100, height: 44)))
        setBackgroundImage(UIImage(named: ImageType.miniBtn.rawValue), for: .normal)
        setTitle(title)
        view.addSubview(self)
    }
    func setTitle(_ title: String) {
        setTitleColor(.black, for: .normal)
        titleLabel?.font = Font.bold.with(14)
        setTitle(title, for: .normal)
    }
}


extension String {
    /// StringからCharacterSetを取り除く
    func remove(characterSet: CharacterSet) -> String {
        return components(separatedBy: characterSet).joined()
    }
    func getStr() -> String {
        return UserDefaults.standard.string(forKey: self) ?? ""
    }
    func set(_ i: Any) {
        UserDefaults.standard.set(i, forKey: self)
        UserDefaults.standard.synchronize()
    }
}
