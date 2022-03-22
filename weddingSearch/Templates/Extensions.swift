//
//  Extensions.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/13.
//

import UIKit
import AVFoundation
import AVKit

var s: CGRect!

enum Font {
    case normal
    case bold
    
    func with(_ size: CGFloat) -> UIFont {
        switch self {
        case .normal: return .systemFont(ofSize: size)
        case .bold: return .boldSystemFont(ofSize: size)
        }
    }
}

enum NotificationName: String {
    case logInStatusUpdated
    case profileUpdated
}
extension NotificationCenter {
    static func post(_ name: NotificationName) {
        NotificationCenter.default.post(name: Notification.Name(name.rawValue), object: nil)
    }
    static func addObserver(_ target: Any, action: Selector, name: NotificationName) {
        NotificationCenter.default.addObserver(target, selector: action, name: Notification.Name(name.rawValue), object: nil)
    }
}
class CAShapeLayer_str: CAShapeLayer {
    var str = ""
}
extension UIView {
    
    var slightlyBiggerRect: CGRect {
        CGRect(x: minX-5, y: minY-5, w: w+10, h: w+10)
    }
    func header(_ text: String, y: CGFloat = 0, h: CGFloat = 50) -> UILabel {
        clipsToBounds = true
        let v = UIView(CGRect(w: w, h: y+h), color: .white, to: self)
        let header = UILabel(CGRect(x: 50, y: y, w: w-100, h: h-1),
                             color: .white,
                             text: text, font: .bold, textSize: 20, lines: 2, align: .center,
                             to: v)
        v.underBar()
        return header
    }
    
    func dashed_border(_ color: UIColor? = .darkGray) {
        guard let color = color else {
            for layer in self.layer.sublayers ?? [] {
                guard let layer = layer as? CAShapeLayer_str else { continue }
                layer.removeFromSuperlayer()
            }
            return
        }
        let layer = CAShapeLayer_str()
        layer.str = "dashed"
        layer.strokeColor = color.cgColor
        layer.fillColor = UIColor.clear.cgColor
        layer.lineDashPattern = [4,2]
        layer.path = UIBezierPath(rect: fitRect).cgPath
        self.layer.addSublayer(layer)
    }
    func roundWhiteShadow() {
        backgroundColor = .white
        round()
        shadow()
    }
    func animate(to view: UIView) {
        alpha = 0
        view.addSubview(self)
        UIView.animate(withDuration: 0.2) {
            self.alpha = 1
        }
    }
    func round(_ ratio: CGFloat = 0.5, clip: Bool = false) {
        if ratio > 0.5 {
            layer.cornerRadius = ratio
        } else {
            layer.cornerRadius = h*ratio
        }
        if self is UIScrollView || self is UILabel || self is UIImageView {
            clipsToBounds = true
        } else {
            clipsToBounds = clip
        }
    }
    var fitRect: CGRect { CGRect(w: w, h: h) }
    func ovarRect(value: CGFloat) -> CGRect { CGRect(x: -value, y: -value, w: w+value*2, h: h+value*2) }
    
    func topBar() {
        _=UIView(CGRect(w: w, h: 1), color: .superPaleGray, to: self)
    }
    func underBar() {
        _=UIView(CGRect(y: h-1, w: w, h: 1), color: .superPaleGray, to: self)
    }
    func moveToCenterX() {
        guard let superview = superview else {
            return
        }
        frame.origin.x = (superview.w-w)/2
    }
    func getImage() -> UIImage {
        UIGraphicsBeginImageContextWithOptions(frame.size, true, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        context.setShouldAntialias(false)
        layer.render(in: context)
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
    func addTap(_ target: Any?, action: Selector) {
        isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
    func addSwipe(_ target: Any?, action: Selector) {
        isUserInteractionEnabled = true
        let tap = UIPanGestureRecognizer(target: target, action: action)
        addGestureRecognizer(tap)
    }
    
    convenience init(_ frame: CGRect? = nil, color: UIColor = .clear, to v: UIView) {
        self.init(frame: frame ?? .zero)
        backgroundColor = color
        v.addSubview(self)
    }
    internal static func grayBack(to v: UIView, alpha: CGFloat = 0.3) -> UIView {
        var view = v
        while true {
            if let v = view.superview { view = v } else { break }
        }
        return UIView(CGRect(origin: .zero, size: UIScreen.main.bounds.size), color: .gray(alpha: 0.3), to: view)
    }
    
    @objc func closeSelf() {
        UIView.animate(withDuration: 0.2) {
            self.alpha = 0
        } completion: { (Bool) in
            self.removeFromSuperview()
        }
    }
    @objc func popDown() {
        guard let superview = superview else {
            return
        }
        UIView.animate(withDuration: 0.2) {
            self.frame.origin.y = superview.h
        } completion: { (Bool) in
            self.removeFromSuperview()
        }
    }
    /// アプリ共通の影を設定する
    func shadow(radius: CGFloat = 5, opacity: Float = 0.3, color: UIColor = .black) {
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
        layer.shadowOffset = .zero
    }
    func border(_ color: UIColor = .themeColor, width: CGFloat = 3) {
        layer.borderWidth = width
        layer.borderColor = color.cgColor
    }
    /// 親viewcontroller
    var waitingController: BasicViewController {
        return parentViewController as! BasicViewController
    }
    var parentViewController: UIViewController! {
        var parentResponder: UIResponder? = self
        while true {
            guard let nextResponder = parentResponder?.next else { return nil }
            if let viewController = nextResponder as? UIViewController {
                return viewController
            }
            parentResponder = nextResponder
        }
    }
    func showAlert(title: String, message: String = "", image: String? = nil,
                   btnTitle: String = "OK", cancelBtnTitle: String? = nil,
                   completion: (() -> Void)? = nil) {
        parentViewController.showAlert(title: title, message: message,
                                       image: image,
                                       btnTitle: btnTitle, cancelBtnTitle: cancelBtnTitle,
                                       completion: completion)
    }
    var w: CGFloat { return frame.width }
    var h: CGFloat { return frame.height }
    var minY: CGFloat { return frame.minY }
    var maxY: CGFloat { return frame.maxY }
    var minX: CGFloat { return frame.minX }
    var maxX: CGFloat { return frame.maxX }
}
extension UIButton {
    
    // deprecated iOS15 : titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
    func titleInset(top: CGFloat = 10, leading: CGFloat = 10, bottom: CGFloat = 10, trailing: CGFloat = 10) {
        if configuration == nil {
            self.configuration = .plain()
        }
        configuration?.contentInsets = NSDirectionalEdgeInsets(top: top, leading: leading, bottom: bottom, trailing: trailing)
    }
    
    convenience init(_ frame: CGRect,
                     text: String = "", font: Font = .bold, textSize: CGFloat = 15, textColor: UIColor = .black, lines: Int = 1,
                     color: UIColor = .clear, to view: UIView) {
        self.init(frame: frame)
        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.numberOfLines = lines
        setTitle(text, for: .normal)
        titleLabel?.font = font.with(textSize)
        setTitleColor(textColor, for: .normal)
        backgroundColor = color
        view.addSubview(self)
        addTarget(self, action: #selector(animateBtn), for: .touchUpInside)
    }
    func addAction(action: @escaping () -> Void) {
        addAction(UIAction(handler: { UIAction in
            action()
        }), for: .touchUpInside)
    }
    // 12丸、影付きボタン
    static func whiteShadowBtn(_ target: Any?, action: Selector?, y: CGFloat, text: String, to view: UIView) -> UIButton {
        return .whiteShadowBtn(target, action: action, f: CGRect(x: 20, y: y, w: view.w-40, h: 46), text: text, to: view)
    }
    static func whiteShadowBtn(_ target: Any?, action: Selector?, f: CGRect, text: String, to view: UIView) -> UIButton {
        let btn = UIButton(f, text: text, font: .bold, textSize: 18, color: .white, to: view)
        btn.round(12)
        btn.shadow()
        guard let target = target, let action = action else {
            btn.setTitleColor(.lightGray, for: .normal)
            return btn
        }
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    func fitWidth() {
        guard let size = titleLabel?.sizeThatFits(CGSize(width: superview?.w ?? 0, height: h)) else { return }
        frame.size.width = size.width+20
    }
    // 灰色ボタン
    static func grayBtn(_ f: CGRect, text: String, target: Any?, action: Selector, to v: UIView) -> UIButton {
        let btn = UIButton(f, text: text, font: .bold, textSize: f.height*0.4,
                           color: .superPaleGray, to: v)
        btn.round(0.2)
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    // 背景色なしの目立つボタン
    static func boldBtn(text: String, y: CGFloat = s.minY, target: Any?, action: Selector, to v: UIView) -> UIButton {
        
        let btn = UIButton(CGRect(x: v.w-100, y: y, w: 80, h: 50),
                           text: text, font: .bold, textSize: 18, textColor: .black, to: v)
        btn.contentHorizontalAlignment = .right
        btn.addTarget(target, action: action, for: .touchUpInside)
        return btn
    }
    // 矢印付き,選択肢用ボタン
    static func selectionBtn(_ f: CGRect, text: String, to v: UIView) -> UIButton {
        let btn = UIButton(f, text: text, font: .bold, textSize: 16,
                           color: .superPaleGray, to: v)
        btn.titleInset(trailing: 40)
        btn.contentHorizontalAlignment = .left
        btn.titleLabel?.adjustsFontSizeToFitWidth = false
        btn.round(8)
        _ = UIImageView(CGRect(x: btn.w-30, y: (btn.h-20)/2, w: 20, h: 20), name: "chevron.down", tint: .gray, to: btn)
        return btn
    }
    
    //背景colorボタン
    static func coloredBtn(_ f: CGRect, text: String, color: UIColor = .themeColor, to view: UIView,
                           action: @escaping () -> Void) -> UIButton {
        let btn = UIButton(f, text: text, font: .bold, textSize: 17, textColor: .white, color: color, to: view)
        btn.round(0.5)
        btn.addAction {
            action()
        }
        return btn
    }
    static func lineInquiry(y: CGFloat, to view: UIView) -> UIButton {
        let lineInquiry = UIButton(CGRect(x: view.w/2-141, y: y, w: 282, h: 50), to: view)
        lineInquiry.setImage(UIImage(named: "lineInquiry"), for: .normal)
        lineInquiry.addAction {
            //todo to line
        }
        return lineInquiry
    }
    //dropdownボタン
    static func dropBtn(_ f: CGRect, text: String, to view: UIView,
                        action: (() -> Void)?) -> UIButton {
        let btn = UIButton(f, text: text, font: .bold, textSize: 17, textColor: .black, color: .white, to: view)
        btn.round(0.2)
        if f.width < 200 {
            btn.titleEdgeInsets.left = 10
        } else {
            btn.titleEdgeInsets.left = 40
        }
        btn.titleEdgeInsets.right = 40
        btn.titleLabel?.adjustsFontSizeToFitWidth = false
        if let action = action { btn.addAction(action: action) }
        _ = UIImageView(CGRect(x: btn.w-40, y: btn.h/2-10, w: 20, h: 20),
                        name: ImageType.chevronD.rawValue, tint: .gray, to: btn)
        return btn
    }
    
    @objc func animateBtn() {
        self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1, y: 1)
        }
    }
    func roundShadow() {
        round(0.5)
        shadow()
    }
    
    internal static func closeBtn(to view: UIView,
                                  x: CGFloat = 10, y: CGFloat = 0, theme: ImageBtn.ColorType = .clearBlack,
                                  type: ImageType = .multiply, action: @escaping () -> Void) -> UIButton {
        let b = ImageBtn(CGPoint(x: x, y: y), image: type, theme: theme, to: view)
        b.round(clip: true)
        b.addAction(UIAction(handler: { UIAction in
            action()
        }), for: .touchUpInside)
        return b
    }
    // ボタンの縦横比は一定とする
    func setAdjustedImage(named name: String, tintColor: UIColor = .white) {
        var image: UIImage!
        if let temp = UIImage(named: name) {
            image = temp
        } else {
            image = UIImage(systemName: name)
        }
        self.tintColor = tintColor
        setImage(image, for: .normal)
        
        if image.widthWider {
            let ratio = image.size.height/image.size.width
            let topBottom = (w-(w*0.8*ratio))/2
            titleInset(top: topBottom, leading: w*0.1, bottom: topBottom, trailing: w*0.1)
        } else {
            let ratio = image.size.width/image.size.height
            let leftRight = (w-(w*0.8*ratio))/2
            titleInset(top: w*0.1, leading: leftRight, bottom: w*0.1, trailing: leftRight)
        }
        
    }
}
extension UILabel {
    
    static func grayTtl(_ f: CGRect, ttl: String, to v: UIView) -> UILabel {
        return UILabel(f, text: ttl, textSize: 16, textColor: .black, to: v)
    }
    convenience init(_ frame: CGRect, color: UIColor = .clear, text: String? = nil,
                     font: Font = .normal, textSize: CGFloat = 15, textColor: UIColor = .black, lines: Int = 1, align: NSTextAlignment = .left,
                     to view: UIView?) {
        self.init(frame: frame)
        self.text = text
        self.textColor = textColor
        backgroundColor = color
        numberOfLines = lines
        textAlignment = align
        self.font = font.with(textSize)
        if let view = view { view.addSubview(self) }
    }
    static func redLive(y: CGFloat, to view: UIView) -> UILabel {
        let liveLbl = UILabel(CGRect(x: 10, y: y, w: 45, h: 20),
                              color: .red, font: .bold, textSize: 11, textColor: .white, align: .center,
                              to: view)
        liveLbl.round(0.2)
        return liveLbl
    }
    func fitWidth(maxW: CGFloat = 800, wdPlus: CGFloat = 0) {
        let ht = h
        frame.size = sizeThatFits(CGSize(width: maxW, height: h))
        frame.size.height = ht
        frame.size.width += wdPlus
    }
    func fitHeight(maxH: CGFloat = 800, plusH: CGFloat = 0) {
        let wd = w
        frame.size = sizeThatFits(CGSize(width: w, height: maxH))
        frame.size.height += plusH
        frame.size.width = wd
    }
    func flexibleFontSize() {
        adjustsFontSizeToFitWidth = true
        minimumScaleFactor = 0.6
    }
}


extension UITextView {
    
    convenience init(_ f: CGRect, textSize: CGFloat = 15, to v: UIView) {
        self.init(frame: f)
        backgroundColor = .white
        round(8)
        font = Font.normal.with(textSize)
        textColor = .black
        v.addSubview(self)
        contentInset = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        border(.superPaleGray, width: 1)
        addDoneToolbar("Done")
    }
    
    func addDoneToolbar(_ title: String) {
        
        let toolbar = UIToolbar()
        toolbar.barStyle = .default
        toolbar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: title, style: .done, target: self, action: #selector(doneButtonTapped))
        ]
        toolbar.sizeToFit()
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        self.inputAccessoryView = toolbar
    }
    @objc func doneButtonTapped() { self.resignFirstResponder() }
    
    func fitHeight() {
        let size = CGSize(width: w, height: .greatestFiniteMagnitude)
        frame.size = sizeThatFits(size)
        frame.size.width = size.width
    }
    
}

extension CGRect {
    
    init(x: CGFloat = 0, y: CGFloat = 0, w: CGFloat = UIScreen.main.bounds.width, h: CGFloat = 0) {
        self.init(x: x, y: y, width: w, height: h)
    }
    static func drumBtn(centerX: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: centerX-130, y: y, w: 260, h: 100)
    }
    static func colorBtn(centerX: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: centerX-150, y: y, w: 300, h: 50)
    }
    static func colorBtn(x: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: x, y: y, w: 120, h: 50)
    }
    static func colorBtn(maxX: CGFloat, y: CGFloat) -> CGRect {
        return CGRect(x: maxX-120, y: y, w: 120, h: 50)
    }
    
    static func fill_rect(y: inout CGFloat, h: CGFloat, plusY: CGFloat = 20, view: UIView) -> CGRect {
        let r = CGRect(y: y, w: view.w, h: h)
        y = r.maxY+plusY
        return r
    }
    static func full_rect(y: inout CGFloat, h: CGFloat, plusY: CGFloat = 20, view: UIView) -> CGRect {
        let r = CGRect(x: 30, y: y, w: view.w-60, h: h)
        y = r.maxY+plusY
        return r
    }
    static func left_rect(h: CGFloat, y: inout CGFloat, view: UIView) -> CGRect {
        let r = CGRect(x: 20, y: y, w: (view.w-50)/2, h: h)
        return r
    }
    static func right_rect(h: CGFloat, y: inout CGFloat, view: UIView) -> CGRect {
        let r = CGRect(x: view.w/2+5, y: y, w: (view.w-50)/2, h: h)
        y = r.maxY+20
        return r
    }
}
extension UIColor {
    
    internal static var themeColor: UIColor {
        return UIColor(hue: 253/360, saturation: 64/100, brightness: 96/100, alpha: 1)
    }
    internal static var themePale: UIColor {
        return UIColor(hue: 246/360, saturation: 8/100, brightness: 96/100, alpha: 1)
    }
    internal static var brown: UIColor {
        return UIColor(hue: 23/360, saturation: 78/100, brightness: 72/100, alpha: 1)
    }
    internal static var lineGreen: UIColor {
        return UIColor(hue: 106/360, saturation: 71/100, brightness: 75/100, alpha: 1)
    }
    static func gray(alpha: CGFloat) -> UIColor {
        UIColor(red: 0, green: 0, blue: 40/255, alpha: alpha)
    }
    internal static var superPaleGray: UIColor {
        return UIColor(white: 0.92, alpha: 1)
    }
    internal static var superPaleBackGray: UIColor {
        return UIColor(white: 0.96, alpha: 1)
    }
    
    internal static func gradient(_ size: CGSize, colors: [UIColor]) -> UIColor {
        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = CGRect(origin: .zero, size: size)
        backgroundGradientLayer.colors = colors.map { $0.cgColor }
        UIGraphicsBeginImageContext(size)
        backgroundGradientLayer.render(in: UIGraphicsGetCurrentContext()!)
        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: backgroundColorImage!)
    }
}


extension UIImage {
    /// 画像をリサイズ
    internal func resize(resizedSize: CGSize) -> UIImage? {
        let widthRatio = resizedSize.width / size.width
        let heightRatio = resizedSize.height / size.height
        let ratio = widthRatio < heightRatio ? widthRatio : heightRatio
        let newResizedSize = CGSize(width: size.width * ratio, height: size.height * ratio)
        
        UIGraphicsBeginImageContextWithOptions(newResizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: newResizedSize))
        let resizedImage: UIImage? = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
    /// 画像が横長か
    internal var widthWider: Bool {
        return size.width > size.height
    }
}

extension UIImageView {
    
    convenience init(_ f: CGRect, name: String? = nil, mode: ContentMode = .scaleAspectFit, tint: UIColor = .themeColor, to view: UIView) {
        self.init(frame: f)
        if let name = name {
            if let img = UIImage(named: name) {
                image = img
            } else {
                image = UIImage(systemName: name)
            }
        }
        tintColor = tint
        contentMode = mode
        clipsToBounds = true
        view.addSubview(self)
    }
}

extension UIViewController {
    
    @objc func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    func presentFull(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        vc.view.backgroundColor = .white
        present(vc, animated: true, completion: nil)
    }
    /// ImagePickerを表示する
    @objc internal func showImagePicker(delegate: (UIImagePickerControllerDelegate & UINavigationControllerDelegate)? = nil) {
        let picker = UIImagePickerController()
        if delegate == nil {
            picker.delegate = self as? UIImagePickerControllerDelegate & UINavigationControllerDelegate
        } else {
            picker.delegate = delegate
        }
        picker.sourceType = .photoLibrary
        picker.navigationBar.barTintColor = .black
        present(picker, animated: true, completion: nil)
    }
    internal func showVideoPicker(delegate: UIImagePickerControllerDelegate & UINavigationControllerDelegate) {
        let picker = UIImagePickerController()
        picker.delegate = delegate
        picker.mediaTypes = ["public.movie"]
        picker.sourceType = .photoLibrary
        picker.navigationBar.barTintColor = .black
        present(picker, animated: true, completion: nil)
    }
    func playVideo(url: URL) {
        let vc = AVPlayerViewController()
        vc.player = AVPlayer(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    // ボタンが1つのアラートを取得する
    func showAlert(title: String,
                   message: String = "",
                   image: String? = nil,
                   btnTitle: String = "OK",
                   cancelBtnTitle: String? = nil,
                   completion: (() -> Void)? = nil) {
        if let vc = self as? BasicViewController {
            vc.waiting = false
        }
        
        let v = UIView.grayBack(to: view)
        let white = UIView(CGRect(x: v.w/2-150, y: v.h/2-200, w: 300, h: 300), color: .white, to: v)
        white.round(20)
        let lbl = UILabel(CGRect(x: 40, y: 40, w: white.w-80, h: white.h-80-50), lines: -1, to: white)
        lbl.attributedText = .twoLine(text: title, gray: message, miniText: 15)
        if let image = image {
            lbl.fitHeight()
            _ = UIImageView(CGRect(x: white.w/2-50, y: white.h/2-20, w: 100, h: 100), name: image, to: white)
        }
        
        _=UIView(CGRect(y: white.h-50, w: white.w, h: 1), color: .superPaleGray, to: white)
        
        var okRect = CGRect(y: white.h-50, w: white.w, h: 50)
        if let cancelBtnTitle = cancelBtnTitle {
            let cancelBtn = UIButton(CGRect(y: white.h-50, w: white.w/2, h: 50),
                                     text: cancelBtnTitle, font: .bold, textSize: 18, textColor: .red, to: white)
            cancelBtn.addAction {
                v.closeSelf()
            }
            
            _=UIView(CGRect(x: cancelBtn.maxX-0.5, y: white.h-50, w: 1, h: 50), color: .superPaleGray, to: white)
            okRect.origin.x = white.w/2
            okRect.size.width = white.w/2
        }
        let okBtn = UIButton(okRect, text: btnTitle, font: .bold, textSize: 18, to: white)
        okBtn.addAction {
            v.closeSelf()
            completion?()
        }
    }
}
extension UIAlertController {
    
    func action(btnTitle: String, completion: (() -> Void)?) {
        addAction(UIAlertAction(title: btnTitle, style: .default, handler: {
            (action: UIAlertAction!) -> Void in
            if let completion = completion {
                completion()
            }
        }))
    }
    func addCancel(btnTitle: String = "キャンセル") {
        addAction(UIAlertAction(title: btnTitle, style: .cancel, handler: {
            (action: UIAlertAction!) -> Void in
        }))
    }
}
extension UITableView {
    
    internal func register<T: UITableViewCell>(_ classType: T.Type) {
        let className = String(describing: classType)
        register(classType, forCellReuseIdentifier: className)
    }
    internal func dequeueCell<T: UITableViewCell>(_ classType: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: classType)
        return self.dequeueReusableCell(withIdentifier: className, for: indexPath) as! T
    }
    func addRefreshControll(target: Any, action: Selector) {
        let refresh = UIRefreshControl()
        refresh.addTarget(target, action: action, for: .valueChanged)
        refreshControl = refresh
    }
}
extension UICollectionView {
    
    internal func register<T: UICollectionViewCell>(_ classType: T.Type) {
        let className = String(describing: classType)
        register(classType, forCellWithReuseIdentifier: className)
    }
    internal func dequeueCell<T: UICollectionViewCell>(_ classType: T.Type, indexPath: IndexPath) -> T {
        let className = String(describing: classType)
        return self.dequeueReusableCell(withReuseIdentifier: className, for: indexPath) as! T
    }
    func addRefreshControll(target: Any, action: Selector) {
        let refresh = UIRefreshControl()
        refresh.addTarget(target, action: action, for: .valueChanged)
        refreshControl = refresh
    }
}

extension NSAttributedString {
    
    static func twoLine(grayTtl: String, bigContent: String, color: UIColor = .black, miniText: CGFloat = 13) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: grayTtl + "\n",
                                             attributes: [.foregroundColor: UIColor.gray,
                                                          .font: Font.normal.with(miniText)])
        attr.append(NSAttributedString(string: bigContent + "\n",
                                       attributes: [.foregroundColor : color,
                                                    .font: Font.bold.with(miniText+5)]))
        attr.appendParaStyle(align: .center, lineSpacing: 2)
        return attr
    }
    static func twoLine(text: String, gray: String, miniText: CGFloat = 13) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: text + "\n",
                                             attributes: [.foregroundColor: UIColor.black,
                                                          .font: Font.bold.with(miniText+4)])
        attr.append(NSAttributedString(string: gray + "\n",
                                       attributes: [.foregroundColor : UIColor.gray,
                                                    .font: Font.normal.with(miniText)]))
        attr.appendParaStyle(align: .left, lineSpacing: 1)
        return attr
    }
    static func singleLine(gray: String, emphasized: String) -> NSMutableAttributedString {
        let attr = NSMutableAttributedString(string: gray + " ",
                                             attributes: [.foregroundColor: UIColor.gray,
                                                          .font: Font.normal.with(13)])
        attr.append(NSAttributedString(string: emphasized,
                                       attributes: [.foregroundColor: UIColor.black,
                                                    .font: Font.normal.with(13)]))
        attr.appendParaStyle(align: .center, lineSpacing: 2)
        return attr
    }
}
extension NSMutableAttributedString {
    
    func appendParaStyle(align: NSTextAlignment, lineSpacing: CGFloat) {
        let para = NSMutableParagraphStyle()
        para.lineSpacing = lineSpacing
        para.alignment = align
        addAttribute(.paragraphStyle, value: para, range: NSRange(0..<length))
    }
}
class TextField: UITextField {
    
    var key: String?
    var padding = UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    
    convenience init(_ f: CGRect, delegate: UITextFieldDelegate?, placeholder: String, to v: UIView) {
        self.init(frame: f)
        backgroundColor = .white
        round(8)
        font = Font.normal.with(f.height*0.5)
        textColor = .black
        returnKeyType = .done
        self.delegate = delegate
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        v.addSubview(self)
        //addDoneToolbar("Done")
    }
    func setUnitLbl(unit: String, keyboardType: UIKeyboardType) {
        textAlignment = .right
        self.keyboardType = keyboardType
        padding.right = 40
        _=UILabel(CGRect(x: w-padding.right, w: padding.right, h: 40), text: unit, textSize: 16, textColor: .lightGray, align: .center, to: self)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }

    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}

extension UISearchBar {
    
    convenience init(_ f: CGRect, to v: UIView, placeholder: String, delegate: UISearchBarDelegate) {
        self.init(frame: f)
        self.delegate = delegate
        v.addSubview(self)
        backgroundColor = .white
        backgroundImage = UIImage()
        if let field = value(forKey: "searchField") as? UITextField {
            field.backgroundColor = .superPaleGray
            field.textColor = .black
            field.font = Font.normal.with(f.height*0.3)
        }
        tintColor = .themeColor
        searchTextField.leftView?.tintColor = .themeColor
        searchTextField.attributedPlaceholder = .init(string: placeholder,
                                                      attributes: [.foregroundColor: UIColor.lightGray])
    }
}

enum DateFormat: String {
    case docName = "yyyy-MM-dd-HH-mm-ss"
    case full = "yyyy年MM月dd日 HH時mm分"
    case year = "yyyy年"
    case yearMonthDate = "yyyy年MM月dd日"
    case yearMonthDateE = "yyyy年MM月dd日 (EEEE)"
    case monthDate = "MM月dd日"
    case MDE = "MM月dd日 (E)"
    case ymd = "yyyy/MM/dd/HH/mm" // do not change this format!!
    case HHmm = "HH:mm"
}

extension Date {
    func toFullString() -> String {
        return toString(format: .full)
    }
    func toString(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.locale = Locale(identifier: "ja_JP")
        let str = dateFormatter.string(from: self)
        //if str.first == "0" { str.removeFirst() }
        return str
    }
    func text() -> String {
        
        var dateText = self.toString(format: .yearMonthDateE)
        let todayText = Date().toString(format: .yearMonthDateE)
        if dateText == todayText {
            dateText = "今日"
        } else if todayText.components(separatedBy: "年").first == dateText.components(separatedBy: "年").first {
            dateText = self.toString(format: .MDE)
        }
        return dateText
    }
    static func today() -> Date {
        return Date()
    }

    func get(_ direction: SearchDirection,
            _ weekDay: Weekday,
            considerToday: Bool = false) -> Date {

        let dayName = weekDay.rawValue

        let weekdaysName = getWeekDaysInEnglish().map { $0.lowercased() }

        assert(weekdaysName.contains(dayName), "weekday symbol should be in form \(weekdaysName)")

        let searchWeekdayIndex = weekdaysName.firstIndex(of: dayName)! + 1

        let calendar = Calendar(identifier: .gregorian)

        if considerToday && calendar.component(.weekday, from: self) == searchWeekdayIndex {
            return self
        }

        var nextDateComponent = calendar.dateComponents([], from: self)
        nextDateComponent.weekday = searchWeekdayIndex

        let date = calendar.nextDate(after: self,
                                     matching: nextDateComponent,
                                     matchingPolicy: .nextTime,
                                     direction: direction.calendarSearchDirection)

        return date!
      }
    func getWeekDaysInEnglish() -> [String] {
        var calendar = Calendar(identifier: .gregorian)
        calendar.locale = Locale(identifier: "en_US_POSIX")
        return calendar.weekdaySymbols
    }
    enum Weekday: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
    }

    enum SearchDirection {
        case next
        case previous

        var calendarSearchDirection: Calendar.SearchDirection {
            switch self {
            case .next: return .forward
            case .previous: return .backward
            }
        }
    }
    
    var month: Int {
        let current = Calendar.current
        return current.component(.month, from: self)
    }
    var year: Int {
        let current = Calendar.current
        return current.component(.year, from: self)
    }
    var day: Int {
        let current = Calendar.current
        return current.component(.day, from: self)
    }
    var zeroAM: Date {
        Date.from(year: year, month: month, day: day)
    }
    var lastDayOfTheMonth: Int {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 0
        // 求めたい月の最後の日のDateオブジェクトを得る
        let date = calendar.date(from: components) ?? Date()
        return calendar.component(.day, from: date)
    }
    var thisMonthLastDate: Date {
        Date.from(year: year, month: month, day: lastDayOfTheMonth)
    }
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(calendar: .current, year: year, month: month, day: day)
        return components.date ?? Date()
    }
}
extension Int {
    
    var priceText: String {
        let text = "\(self)".reversed()
        var newText = ""
        var i = 0
        for c in text {
            if i != 0, i % 3 == 0 {
                newText.append(",")
            }
            newText.append("\(c)")
            i += 1
        }
        newText.append("￥")
        return String(newText.reversed())
    }
}
extension String {
    func toDate(format: DateFormat) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        return dateFormatter.date(from: self)
    }
    func int() -> Int {
        return UserDefaults.standard.integer(forKey: self)
    }
    func str() -> String? {
        return UserDefaults.standard.string(forKey: self)
    }
    func dict() -> [String : Any]? {
        return UserDefaults.standard.dictionary(forKey: self)
    }
    func set(_ i: Any?) {
        UserDefaults.standard.set(i, forKey: self)
        UserDefaults.standard.synchronize()
    }
}

extension UICollectionViewLayout {
    
    static func lessonLayout(fitTo view: UIView) -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let w = view.w/2-7
        flowLayout.itemSize = CGSize(width: w, height: w*1.1)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 5
        flowLayout.sectionInset = .zero
        return flowLayout
    }
}
