//
//  CheckBtn.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/11.
//

import Foundation

import UIKit

class UIButton_withStr: UIButton {
    var string: String?
}

class CheckBtnView: UIView {
    
    var selected: (UIButton_withStr) -> Void
    var btns = [UIButton_withStr]()
    var allowMultipleSelection: Bool
    
    init(_ f: CGRect, to view: UIView,
         allowMultipleSelection: Bool,
         selected: @escaping (UIButton_withStr) -> Void) {
        self.allowMultipleSelection = allowMultipleSelection
        self.selected = selected
        super.init(frame: f)
        view.addSubview(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setOptions(_ options: [(str: String, selected: Bool)]) {
        btns.forEach { $0.removeFromSuperview() }
        btns = []
        
        var y: CGFloat = 0
        var x: CGFloat = 10
        var i = 0
        let oneH: CGFloat = 30
        for option in options {
            let check = UIButton_withStr(CGRect(x: x, y: y, w: w, h: oneH-10),
                                         text: option.str, textColor: .white, color: .lightGray, to: self)
            check.round(check.h/2)
            check.frame.size = check.sizeThatFits(check.frame.size)
            check.frame.size.width += 16
            check.tag = i
            check.string = option.str
            check.addTarget(self, action: #selector(option_selected), for: .touchUpInside)
            if option.selected {
                option_selected(sender: check)
            }
            btns.append(check)
            
            if frame.width-10 < check.frame.maxX {
                y += oneH
                check.frame.origin = CGPoint(x: 10, y: y)
            }
            i += 1
            x = check.frame.maxX+6
        }
        y += oneH
        frame.size.height = y
    }
    @objc func option_selected(sender: UIButton_withStr) {
        sender.isSelected.toggle()
        print("option_selected", sender.isSelected, sender.title(for: .normal)!)
        sender.backgroundColor = sender.isSelected ? .themeColor : .gray
        selected(sender)
        // de-select others
        if !allowMultipleSelection {
            for btn in btns {
                // de-select
                if btn.isSelected, btn != sender {
                    print("de-select", btn.title(for: .normal)!)
                    btn.isSelected = false
                    btn.backgroundColor = .lightGray
                    selected(btn)
                }
            }
        }
    }
}
