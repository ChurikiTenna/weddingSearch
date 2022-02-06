//
//  DateField.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

class BirthDateField: YearMonthDateField {
    static func initMe(_ f: CGRect, user: User, to scroll: UIView) -> BirthDateField {
        return BirthDateField(f, title: "生年月日", date: Date(), to: scroll)
    }
    override func allowAnyMonth() -> Bool { return true }
}
class YearMonthDateField: TextFieldAndTtl {
    
    var date: YMD? {
        didSet {
            setText()
        }
    }
    func allowAnyMonth() -> Bool { return false }
    
    init(_ f: CGRect, title: String, date: Date?, to view: UIView) {
        super.init(f, ttl: title, placeholder: "\(title)を選択", text: "", to: view)
        view.addSubview(self)
        self.date = date?.ymd()
        textField.addTap(self, action: #selector(selectDate))
        
        setText()
    }
    @objc func selectDate() {
        superview?.endEditing(true)
        let vc = SelectDateController(selectedDate: date, allowAnyMonth: allowAnyMonth(), title: ttlLbl.text!) { ymd in
            self.date = ymd
        }
        parentViewController.presentFull(vc)
    }
    
    func setText() {
        if let date = date {
            textField.text = date.toDate().toString(format: .yearMonthDate)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SelectDateController: BasicViewController {
    
    var calenderView: UICalender!
    let selectedDate: YMD?
    let datesSelected: (YMD) -> Void
    let ttl: String
    let allowAnyMonth: Bool
    
    init(selectedDate: YMD?, allowAnyMonth: Bool, title: String, datesSelected: @escaping (YMD) -> Void) {
        self.datesSelected = datesSelected
        self.ttl = title
        self.selectedDate = selectedDate
        self.allowAnyMonth = allowAnyMonth
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header(ttl, withClose: true)
        _=UIButton.boldBtn(text: "OK", y: s.minY, target: self, action: #selector(dateSelected), to: view)
        
        calenderView = UICalender(CalenderCell.self, y: head.maxY+10, ymd: selectedDate, to: view)
        calenderView.allowMultipleSelection = false
        print("allowAnyMonth", allowAnyMonth)
        if allowAnyMonth {
            print("calenderView.addTapMonthYearLbl()")
            calenderView.addTapMonthYearLbl()
        }
    }
    
    @objc func dateSelected() {
        let time = Time(hour: 23, min: 59)
        guard let selectedSingleDate = calenderView.selectedSingleDate else {
            showAlert(title: "日付を選択してください")
            return
        }
        let ymd = YMD(year: selectedSingleDate.year, month: selectedSingleDate.month, day: selectedSingleDate.day, start: time, end: time)
        datesSelected(ymd)
        dismissSelf()
    }
}
