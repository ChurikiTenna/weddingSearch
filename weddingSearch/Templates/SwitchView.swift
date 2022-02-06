//
//  SwitchView.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/14.
//

import UIKit

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
