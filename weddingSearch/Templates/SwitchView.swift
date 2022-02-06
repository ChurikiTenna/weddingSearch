//
//  SwitchView.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/14.
//

import UIKit

protocol SwitchViewDelegate: AnyObject {
    func didChangeSelection(idx: Int, switchView: SwitchView)
}
class SwitchView: UIView {
    
    internal var id = ""
    
    internal weak var delegate: SwitchViewDelegate?
    var selectedBack: UIView!
    var optionCount = 0
    var texts = [UILabel]()
    var colors = [UIColor]()
    var selectedIdx = 0
    
    func initUI(id: String = "",
                roundRatio: CGFloat? = nil,
                colors: [UIColor]? = nil,
                options: [String],
                delegate: SwitchViewDelegate?) {
        self.id = id
        self.delegate = delegate
        if let roundRatio = roundRatio { round(roundRatio) }
        optionCount = options.count
        if let colors = colors {
            self.colors = colors
        } else {
            for _ in 0..<optionCount { self.colors.append(.themeColor) }
        }
        var idx = 0
        var sukima = CGFloat()
        if roundRatio != nil { sukima = 2 }
        var x = sukima
        let wd = (frame.width-CGFloat(optionCount+1)*sukima)/CGFloat(optionCount)
        for str in options {
            let f = CGRect(x: x, y: sukima, w: wd, h: frame.height-sukima*2)
            if idx == selectedIdx {
                selectedBack = UIView(f, color: self.colors[selectedIdx], to: self, insert: 0)
                if let roundRatio = roundRatio { selectedBack.round(roundRatio) }
                else {
                    selectedBack.frame.size.height = 5
                    selectedBack.frame.origin.y = f.maxY-5
                }
                delegate?.didChangeSelection(idx: selectedIdx, switchView: self)
            }
            let text = UILabel(f, text: str, textSize: frame.height*0.36, align: .center, to: self)
            texts.append(text)
            idx += 1
            x += wd+sukima
        }
        if roundRatio != nil {
            backgroundColor = .superPaleGray
        } else {
            underBar()
        }
        fill_section(selectedIdx)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let location = touches.first?.location(in: self) else { return }
        let oneSection = frame.width/CGFloat(optionCount)
        var idx = 0
        while true {
            if CGFloat(idx)*oneSection...CGFloat(idx+1)*oneSection ~= location.x {
                fill_section(idx)
                selectedIdx = idx
                delegate?.didChangeSelection(idx: idx, switchView: self)
                break
            }
            idx += 1
        }
    }
    func fill_section(_ idx: Int) {
        if selectedBack.h > 10 {
            for i in 0..<texts.count {
                if i == idx {
                    texts[idx].textColor = .white
                } else {
                    texts[i].textColor = .black
                }
            }
        }
        
        UIView.animate(withDuration: 0.1) {
            self.selectedBack.frame.origin.x = self.texts[idx].frame.minX
            self.selectedBack.backgroundColor = self.colors[idx]
        }
        
    }
}

class SwitchBtn: UIButton {
    
    var thumb: UIView!
    
    init(_ f: CGRect, isSelected: Bool, to view: UIView, didToggle: @escaping (Bool) -> Void) {
        super.init(frame: f)
        backgroundColor = .lightGray
        view.addSubview(self)
        thumb = UIView(CGRect(y: 2, w: h-4, h: h-4), color: .white, to: self)
        thumb.round(0.5)
        thumb.isUserInteractionEnabled = false
        round(0.5)
        addAction(UIAction(handler: { action in
            self.select()
            didToggle(self.isSelected)
        }), for: .touchUpInside)
        
        self.isSelected = !isSelected
        select()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func select() {
        isSelected.toggle()
        backgroundColor = isSelected ? .themeColor : .lightGray
        UIView.animate(withDuration: 0.2) {
            self.thumb.frame.origin.x = self.isSelected ? self.w-self.thumb.w-2 : 2
        }
    }
}
