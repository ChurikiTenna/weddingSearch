//
//  UICalender.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/02/06.
//

import UIKit

struct YMD: Equatable {
    static func == (lhs: YMD, rhs: YMD) -> Bool {
        return (lhs.year==rhs.year && lhs.month==rhs.month && lhs.day==rhs.day
                && lhs.start?.hour==rhs.start?.hour && lhs.start?.min==rhs.start?.min
                && lhs.end?.hour==rhs.end?.hour && lhs.end?.min==rhs.end?.min)
    }
    
    var year = 0
    var month = 0
    var day = 0
    var start: Time!
    var end: Time!
    
    func isSameDay(with date: YMD) -> Bool {
        return (date.year==year && date.month==month && date.day==day)
    }
    func isSameDayAndTime(with date: YMD) -> Bool {
        return (date.year==year && date.month==month && date.day==day && date.start?.hour==start?.hour && date.start?.min==start?.min)
    }
    func toDate() -> Date {
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.timeZone = .current
        components.year = year
        components.month = month
        components.day = day
        components.hour = start.hour
        components.minute = start.min
        return calendar.date(from: components)!
    }
    func toDateAndTime() -> String {
        var date = toDate().toString(format: .yearMonthDate)
        if date == Date().toString(format: .yearMonthDate) {
            date = "今日"
        }
        var dateText = "\(date)"
        if start != nil, end != nil {
            dateText += "\(start.hour.toTime):\(start.min.toTime)〜\(end.hour.toTime):\(end.min.toTime)"
        } else if let start = start {
            dateText += "\(start.hour.toTime):\(start.min.toTime)"
        }
        return dateText
    }
    func toString(format: DateFormat) -> String {
        let date = toDate()
        return date.toString(format: format)
    }
    
    init(year: Int, month: Int, day: Int, start: Time? = nil, end: Time? = nil) {
        self.year = year
        self.month = month
        self.day = day
        self.start = start
        self.end = end
    }
}

enum Weekday: String, CaseIterable {
    case sunday
    case monday
    case tuesday
    case wednesday
    case thursday
    case friday
    case saturday
    
    var int: Int {
        switch self {
        case .sunday: return 1
        case .monday: return 2
        case .tuesday: return 3
        case .wednesday: return 4
        case .thursday: return 5
        case .friday: return 6
        case .saturday: return 7
        }
    }
    var color: UIColor {
        switch self {
        case .sunday: return .red
        case .saturday: return .blue
        default: return .gray
        }
    }
    var short: String {
        switch self {
        case .sunday: return "日"
        case .monday: return "月"
        case .tuesday: return "火"
        case .wednesday: return "水"
        case .thursday: return "木"
        case .friday: return "金"
        case .saturday: return "土"
        }
    }
    var long: String {
        return self.short + "曜日"
    }
}

protocol UICalenderDataSource: AnyObject {
    func cellForDate(date: YMD, index: IndexPath, isToday: Bool) -> UICollectionViewCell
}
protocol UICalenderDelegate: AnyObject {
    func tapped(date: YMD, cell: UICollectionViewCell)
}
class UICalender: UIView {
    
    let today: YMD
    var selectedDates = [YMD]()
    var selectedSingleDate: YMD! {
        didSet {
            let idxs = calenderView.indexPathsForVisibleItems
            for idx in idxs {
                let cell = calenderView.cellForItem(at: idx) as! CalenderCell
                if cell.ymd.day == selectedSingleDate.day {
                    cell.select = true
                } else {
                    cell.select = false
                }
            }
        }
    }
    var allowMultipleSelection = true
    
    var year = 0
    var month = 0
    func didSetMonth() {
        monthYearLbl.text = "\(year)/\(month)"
    }
    var firstWeekday = 0
    var maxD = 0
    var dateArry = [Int]()
    
    var monthYearLbl: UILabel!
    var calenderView: UICollectionView!
    var backBtn: UIButton!
    var nextBtn: UIButton!
    weak var delegate: UICalenderDelegate?
    weak var dataSource: UICalenderDataSource?
    
    var monthLimitedTo: [Int]?
    var limitToAfter = 0 {
        didSet {
            if limitToAfter == 0 {
                monthLimitedTo = nil
            } else {
                let now = Date().month
                monthLimitedTo = [Int]()
                for i in 0...limitToAfter {
                    monthLimitedTo?.append(now+i)
                }
                for i in 0..<monthLimitedTo!.count {
                    if monthLimitedTo![i] > 12 {
                        monthLimitedTo![i] -= 12
                    }
                }
                print("monthLimitedTo", monthLimitedTo)
                check_invalidateMonthSwitch()
            }
            
        }
    }
    var selectableWeekday: Weekday? {
        didSet {
            calenderView.reloadData()
        }
    }
    var selectables: [Int]? { return selectableWeekday==nil ? nil : [0,1,2,3,4,5].map({ $0*7+selectableWeekday!.int }) }
    
    init<T: UICollectionViewCell>(_: T.Type, cellWHRatio: CGFloat = 1, y: CGFloat, ymd: YMD?, to v: UIView) {
        var w = v.w-20
        if w > 400 { w = 400 }
        today = Date().ymd()
        super.init(frame: CGRect(x: (v.w-w)/2, y: y, w: w))
        v.addSubview(self)
        selectedSingleDate = ymd
        round(10)
        border(.superPaleGray, width: 1)
        
        monthYearLbl = header("年月")
        if let ymd = ymd {
            self.year = ymd.year
            self.month = ymd.month
        } else {
            self.year = today.year
            self.month = today.month
        }
        
        didSetMonth()
        
        backBtn = ImageBtn(CGPoint(x: 10, y: 5), image: .chevronL, theme: .clearTheme, to: self)
        backBtn.tag = -1
        backBtn.addTarget(self, action: #selector(moveMonth), for: .touchUpInside)
        nextBtn = ImageBtn(CGPoint(x: w-50, y: 5), image: .chevronR, theme: .clearTheme, to: self)
        nextBtn.tag = 1
        nextBtn.addTarget(self, action: #selector(moveMonth), for: .touchUpInside)
        
        let cellW = w/7
        let weekdays = Weekday.allCases// ["日": .red,"月": .gray,"火": .gray,"水": .gray,"木": .gray,"金": .gray,"土": .blue]
        var x = CGFloat()
        let y = monthYearLbl.maxY+1
        for weekday in weekdays {
            _ = UILabel(CGRect(x: x, y: y, w: cellW, h: cellW), text: weekday.short, textSize: 15, textColor: weekday.color, align: .center, to: self)
            x += cellW
        }
        
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: cellW, height: cellW*cellWHRatio)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        flowLayout.sectionInset = .zero
        calenderView = UICollectionView(frame: CGRect(y: y+cellW, w: w, h: flowLayout.itemSize.height*6),
                                        collectionViewLayout: flowLayout)
        calenderView.isScrollEnabled = false
        calenderView.register(T.self)
        calenderView.dataSource = self
        calenderView.delegate = self
        calenderView.backgroundColor = .white
        addSubview(calenderView)
        
        setCalender()
        frame.size.height = calenderView.maxY
    }
    func addTapMonthYearLbl() {
        monthYearLbl.addTap(self, action: #selector(yearMonthTapped))
    }
    @objc private func yearMonthTapped() {
        _=YearMonthPicker(ymd: YMD(year: year, month: month, day: 1), to: self, onSelected: { ymd in
            self.year = ymd.year
            self.month = ymd.month
            self.didSetMonth()
            self.setCalender()
        })
    }
    
    @objc func moveMonth(_ sender: UIButton) {
        month += sender.tag
        // 3ヶ月先までの制限がある場合
        if let monthLimitedTo = monthLimitedTo {
            if !monthLimitedTo.contains(month) {
                month -= sender.tag
                return
            }
            check_invalidateMonthSwitch()
        }
        if month == 0 { year -= 1; month = 12 }
        else if month == 13 { year += 1; month = 1 }
        didSetMonth()
        setCalender()
    }
    func check_invalidateMonthSwitch() {
        if let monthLimitedTo = monthLimitedTo {
            for btn in [backBtn!, nextBtn!] {
                if !monthLimitedTo.contains(month+btn.tag) {
                    btn.tintColor = .superPaleGray
                } else {
                    btn.tintColor = .themeColor
                }
            }
        }
    }
    func setCalender() {
        
        let calendar = Calendar(identifier: .gregorian)
        var components = DateComponents()
        components.year = year
        components.month = month + 1
        components.day = 0
        // 求めたい月の最後の日のDateオブジェクトを得る
        let date = calendar.date(from: components)!
        maxD = calendar.component(.day, from: date)
        
        // ○月1日の曜日を取得
        components.month = month
        components.day = 1
        let firstDate = calendar.date(from: components)!
        firstWeekday = calendar.component(.weekday, from: firstDate)
        
        dateArry = [Int]()
        for _ in 1..<firstWeekday {
            dateArry.append(0)
        }
        for i in 1...maxD {
            dateArry.append(i)
        }
        for _ in 0...42-dateArry.count {
            dateArry.append(0)
        }
        
        calenderView.reloadData()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension UICalender: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 7*6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let day = dateArry[indexPath.row]
        let date = YMD(year: year, month: month, day: day)
        let isToday = today.isSameDay(with: date)
        
        if let dataSource = dataSource {
            return dataSource.cellForDate(date: YMD(year: year, month: month, day: day), index: indexPath, isToday: isToday)
        } else {
            var selected = false
            if allowMultipleSelection {
                selected = selectedDates.filter({ $0.isSameDay(with: date) }).first != nil
            } else if let selectedSingleDate = selectedSingleDate {
                selected = selectedSingleDate.isSameDay(with: date)
            }
            let cell = collectionView.dequeueCell(CalenderCell.self, indexPath: indexPath)
            cell.setDate(ymd: date, isToday: isToday, selected: selected)
            
            if let selectables = selectables {
                cell.isSelectable = selectables.contains(indexPath.row)
            } else {
                cell.isSelectable = day != 0
            }
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        // not selectable
        if dateArry[indexPath.row] == 0 { return }
        
        if let cell = cell as? CalenderCell {
            if !cell.isSelectable { return }
            
            if allowMultipleSelection {
                cell.select.toggle()
                if cell.select { selectedDates.append(cell.ymd) }
                else { selectedDates = selectedDates.filter({ cell.ymd.isSameDay(with: $0) }) }
            } else {
                selectedSingleDate = cell.ymd
            }
            
            if let tapped = delegate?.tapped {
                tapped(cell.ymd, cell)
            }
        }
    }
}

class CalenderCell: UICollectionViewCell {
    
    var dateLbl: UILabel!
    var ymd: YMD!
    var select = false {
        didSet {
            if select { selected() }
            else { de_selected() }
        }
    }
    var isToday: Bool?
    var disablePast = false
    var isSelectable = true {
        didSet {
            if isSelectable {
                if ymd.day==0 { isSelectable = false; return }
                if disablePast, ymd.toDate() < Date() { isSelectable = false; return }
            }
            backgroundColor = isSelectable ? .white : .superPaleGray
            if select, !isSelectable {
                de_selected()
            }
        }
    }
    
    func setDate(ymd: YMD, isToday: Bool, selected: Bool) {
        self.ymd = ymd
        self.isToday = isToday
        
        if dateLbl == nil {
            dateLbl = UILabel(CGRect(w: w, h: h), text: "", font: .bold, textSize: w/3, align: .center, to: self)
        }
        dateLbl.text = ymd.day==0 ? "" : "\(ymd.day)"
        dateLbl.round()
        
        if selected { self.selected() } else { de_selected() }
    }
    internal func selected() {
        dateLbl.backgroundColor = .themeColor
        dateLbl.textColor = .white
    }
    internal func de_selected() {
        dateLbl.backgroundColor = .clear
        dateLbl.textColor = .gray
        if isToday ?? false {
            dateLbl.backgroundColor = .themePale
        }
    }
}

struct Time {
    var hour = 0
    var min = 0
    
    static var end: Time { Time(hour: 23, min: 59) }
    
    func toString() -> String { "\(self.hour.toTime):\(self.min.toTime)" }
}

class YearMonthPicker: UIView, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var ymd: YMD
    var dataList = [[Int]]()
    
    init(ymd: YMD, to view: UIView, onSelected: @escaping (YMD) -> Void) {
        self.ymd = ymd
        let view = view.parentViewController.view!
        super.init(frame: view.fitRect)
        view.addSubview(self)
        backgroundColor = UIColor(white: 0, alpha: 0.5)
        
        dataList.append([])
        dataList.append([])
        
        for i in 1950...Date().year+1 {
            dataList[0].append(i)
        }
        for i in 1...12 {
            dataList[1].append(i)
        }
        
        let picker = UIPickerView(.zero, color: .white, to: self)
        picker.delegate = self
        picker.dataSource = self
        picker.center = center
        picker.selectRow(dataList[0].firstIndex(of: Date().year) ?? 0, inComponent: 0, animated: false)
        picker.selectRow(dataList[1].firstIndex(of: Date().month) ?? 0, inComponent: 1, animated: false)
        
        _ = UIButton.coloredBtn(CGRect(x: w/2-50, y: center.y+120, w: 100, h: 40), text: "OK", to: self) {
            onSelected(self.ymd)
            self.closeSelf()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: "\(dataList[component][row])", attributes: [.foregroundColor: UIColor.black])
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView,
                    numberOfRowsInComponent component: Int) -> Int {
        return dataList[component].count
    }
    func pickerView(_ pickerView: UIPickerView,
                    didSelectRow row: Int,
                    inComponent component: Int) {
        if component==0 {
            ymd.year = dataList[component][row]
        } else {
            ymd.month = dataList[component][row]
        }
    }
}
