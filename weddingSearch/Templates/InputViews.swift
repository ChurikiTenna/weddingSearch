//
//  InputViews.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/06/08.
//

import UIKit

class RangeSelectionField: UIView {
    
    var range: Range<Int>
    var maxRange: Range<Int>
    
    var ttlLbl: UILabel!
    var minimumThumb: UIButton!
    var maximumThumb: UIButton!
    var grayBar: UIView!
    var coloredBar: UIView!
    
    init(_ f: inout CGRect, ttl: String, range: Range<Int>?, maxRange: Range<Int>, to view: UIView) {
        self.range = range ?? maxRange
        self.maxRange = maxRange
        super.init(frame: f)
        view.addSubview(self)
        
        ttlLbl = UILabel.grayTtl(CGRect(x: 10, y: 0, w: w, h: 20), ttl: ttl, to: self)
        
        grayBar = UIView(CGRect(x: 50, y: ttlLbl.maxY+20, w: w-130, h: 4), color: .superPaleGray, to: self)
        grayBar.round()
        _ = UILabel(CGRect(y: grayBar.minY-18, w: grayBar.minX-20, h: 40),
                    text: "\(TextConverter.price(maxRange.lowerBound))", font: .bold, textSize: 12, textColor: .gray, align: .center, to: self)
        _ = UILabel(CGRect(x: grayBar.maxX+20, y: grayBar.minY-18, w: w-grayBar.maxX-20, h: 40),
                    text: "\(TextConverter.price(maxRange.upperBound))+", font: .bold, textSize: 12, textColor: .gray, align: .center, to: self)
        
        let minX = grayBar.w*CGFloat(self.range.lowerBound)/CGFloat(maxRange.upperBound)
        let maxX = grayBar.w*CGFloat(self.range.upperBound)/CGFloat(maxRange.upperBound)
        
        coloredBar = UIView(CGRect(y: grayBar.minY, h: grayBar.h), color: .themeColor, to: self)
        
        minimumThumb = UIButton(CGRect(w: 40, h: 20), textColor: .gray, color: .white, to: self)
        minimumThumb.center = CGPoint(x: minX+grayBar.minX, y: grayBar.center.y)
        minimumThumb.roundShadow()
        //minimumThumb.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        minimumThumb.addTarget(self, action: #selector(allTap), for: .allTouchEvents)
        
        maximumThumb = UIButton(CGRect(w: 40, h: 20), textColor: .gray, color: .white, to: self)
        maximumThumb.center = CGPoint(x: maxX+grayBar.minX, y: grayBar.center.y)
        maximumThumb.roundShadow()
        //maximumThumb.titleEdgeInsets = UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
        maximumThumb.addTarget(self, action: #selector(allTap), for: .allTouchEvents)
        
        moveColoredBar()
        
        frame.size.height = grayBar.maxY+20
        f.origin.y = maxY+10
    }
    
    func moveColoredBar() {
        coloredBar.frame.origin.x = minimumThumb.center.x
        coloredBar.frame.size.width = maximumThumb.center.x-coloredBar.minX
        
        let lower = Int((minimumThumb.center.x-grayBar.minX) / grayBar.w * CGFloat(maxRange.upperBound) / 500) * 500
        let upper = Int((maximumThumb.center.x-grayBar.minX) / grayBar.w * CGFloat(maxRange.upperBound) / 500) * 500
        range = lower..<upper
        print("minimumThumb.center.x-grayBar.minX", minimumThumb.center.x, grayBar.minX, lower)
        minimumThumb.setTitle(TextConverter.price(range.lowerBound), for: .normal)
        maximumThumb.setTitle(TextConverter.price(range.upperBound), for: .normal)
    }
    @objc func allTap(sender: UIButton, event: UIEvent) {
        if let x = event.touches(for: sender)?.first?.location(in: grayBar).x {
            
            sender.center.x = grayBar.minX+x
            if minimumThumb.center.x+30 > maximumThumb.center.x {
                if sender == minimumThumb {
                    minimumThumb.center.x = maximumThumb.center.x-30
                } else if sender == maximumThumb {
                    maximumThumb.center.x = minimumThumb.center.x+30
                }
            }
            if sender.center.x < grayBar.minX { sender.center.x = grayBar.minX }
            else if sender.center.x > grayBar.maxX { sender.center.x = grayBar.maxX }
            moveColoredBar()
            
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class OptionViewController: BasicViewController {
    
    let selectedIdx: Int?
    let ttl: String
    let options: [String]
    let selected: (String) -> Void
    
    init(ttl: String, options: [String], selectedIdx: Int?, selected: @escaping (String) -> Void) {
        self.selected = selected
        self.selectedIdx = selectedIdx
        self.ttl = ttl
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if head != nil { return }
        view.backgroundColor = .superPaleBackGray
        header(ttl, y: 0, withClose: true)
        setScrollView(y: head.maxY)
        
        var y: CGFloat = 20
        for i in 0..<options.count {
            let btn = UIButton(CGRect(x: 40, y: y, w: view.w-80, h: 48),
                               text: options[i], font: .bold, textSize: 16,
                               textColor: i == selectedIdx ? .black : .gray,
                               color: i == selectedIdx ? .themeColor : .white,
                               to: scroll)
            btn.round(0.1)
            btn.tag = i
            btn.addTarget(self, action: #selector(optionSelected), for: .touchUpInside)
            y = btn.maxY+5
        }
        scroll.contentSize.height = y+50
    }
    
    @objc func optionSelected(sender: UIButton) {
        selected(options[sender.tag])
        dismissSelf()
    }
}
class OptionWithHeadersViewController: BasicViewController {
    
    let ttl: String
    let options: [(title: String, texts: [String])]
    let selected: (String) -> Void
    
    init(ttl: String, options: [(title: String, texts: [String])], selected: @escaping (String) -> Void) {
        self.selected = selected
        self.ttl = ttl
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if head != nil { return }
        view.backgroundColor = .superPaleBackGray
        header(ttl, y: 0, withClose: true)
        setScrollView(y: head.maxY)
        
        var y: CGFloat = 20
        for ttlIdx in 0..<options.count {
            
            let lbl = UILabel(CGRect(x: 30, y: y, w: view.w-80, h: 48),
                              text: options[ttlIdx].title, font: .bold, textSize: 18, textColor: .darkGray, to: scroll)
            y = lbl.maxY+5
            
            for text in options[ttlIdx].texts {
                
                let btn = UIButton(CGRect(x: 30, y: y, w: view.w-60, h: 48),
                                   text: text, font: .bold, textSize: 16,
                                   textColor: .gray,
                                   color: .white,
                                   to: scroll)
                btn.round(0.1)
                btn.addAction(action: {
                    self.selected(text)
                    self.dismissSelf()
                })
                y = btn.maxY+5
            }
        }
        scroll.contentSize.height = y+50
    }
}
class GridOptionController: BasicViewController {
    
    let selectedBef: String?
    let ttl: String
    let options: [[String]]
    let selected: (String) -> Void
    var btns = [[UIButton]]()
    
    init(ttl: String, options: [[String]], selectedBef: String?, selected: @escaping (String) -> Void) {
        self.selected = selected
        self.selectedBef = selectedBef
        self.ttl = ttl
        self.options = options
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        if head != nil { return }
        view.backgroundColor = .superPaleBackGray
        header(ttl, y: 0, withClose: true)
        setScrollView(y: head.maxY)
        
        var maxCount = 0
        options.forEach({
            if $0.count > maxCount { maxCount = $0.count }
        })
        
        var y: CGFloat = 20
        let wd = (view.w - CGFloat(maxCount-1)*10 - 40)/CGFloat(maxCount)
        var x: CGFloat = 20
        for idx1 in 0..<options.count {
            for idx2 in 0..<options[idx1].count {
                
                let btn = UIButton(CGRect(x: x, y: y, w: wd, h: 40),
                                   text: options[idx1][idx2], font: .bold, textSize: 16,
                                   textColor: .black, color: .white,
                                   to: scroll)
                btn.round(0.5)
                btn.addAction(action: {
                    self.selected(self.options[idx1][idx2])
                    self.dismissSelf()
                })
                if selectedBef == btn.title(for: .normal) {
                    btn.backgroundColor = .themePale
                }
                x = btn.maxX+10
            }
            y += 60
            x = 20
        }
        scroll.contentSize.height = y+50
    }
}

class TextViewAndTtl: UIView {
    
    var ttlLbl: UILabel!
    var placeholderL: UILabel!
    var textView: UITextView!
    
    init(_ f: inout CGRect, ttl: String, placeholder: String? = nil, text: String?, to view: UIView) {
        super.init(frame: f)
        view.addSubview(self)
        
        ttlLbl = UILabel.grayTtl(CGRect(x: 10, y: 0, w: w, h: 20), ttl: ttl, to: self)
        textView = UITextView(CGRect(y: ttlLbl.maxY+8, w: w, h: 180), to: self)
        textView.delegate = self
        if let text = text {
            textView.text = text
        }
        placeholderL = UILabel(CGRect(x: 12, y: 6, w: w-24),
                               text: placeholder == nil ? "\(ttl)を入力してください" : placeholder!,
                               textSize: textView.font?.pointSize ?? 15, textColor: .gray, lines: -1, to: textView)
        placeholderL.fitHeight()
        textViewDidChange(textView)
        
        frame.size.height = textView.maxY
        f.origin.y = maxY+10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TextViewAndTtl: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.addSubview(placeholderL)
        } else {
            placeholderL.removeFromSuperview()
        }
    }
}

class TextFieldAndTtl: UIView {
    
    var ttlLbl: UILabel!
    var textField: TextField!
    var text: String {
        textField.text ?? ""
    }
    var empty: Bool {
        text.isEmpty
    }
    
    init(_ f: CGRect, ttl: String, placeholder: String? = nil, text: String? = nil, to view: UIView) {
        super.init(frame: f)
        view.addSubview(self)
        backgroundColor = .white
        
        ttlLbl = UILabel.grayTtl(CGRect(x: 20, y: 0, w: w-20, h: ttl.count==0 ? 0 : 30), ttl: ttl, to: self)
        ttlLbl.fitWidth(maxW: w-ttlLbl.maxX)
        
        textField = TextField(CGRect(x: 20, y: ttlLbl.maxY, w: w-40, h: h-ttlLbl.maxY), delegate: self,
                              placeholder: (placeholder == nil ? "\(ttl)を入力" : placeholder!), to: self)
        
        if let text = text {
            textField.text = text
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension TextFieldAndTtl: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
