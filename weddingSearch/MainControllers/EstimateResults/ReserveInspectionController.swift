//
//  ReserveInspectionController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import UIKit

class ReserveInspectionController: BasicViewController {
    
    var request: (objc: RequestData, id: String)
    let datePicker = UIDatePicker()
    let onDone: () -> Void
    var datePickerH: UIView!
    
    var datePickers = [UIButton]()
    var timePickers = [UIButton]()
    var dateTime = [Date?]()
    var editingIdx = 0
    
    var textView: TextView!
    
    var reserveBtn: UIButton!
    
    init(request: (objc: RequestData, id: String), onDone: @escaping () -> Void) {
        self.request = request
        self.onDone = onDone
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("見学予約する", withClose: true)
        subHeader(text: request.objc.venueInfo?.name)
        
        setScrollView(y: subHeadV.maxY)
        
        let lbl = nessesaryLbl(true, y: 10)
        let lbl2 = UILabel(CGRect(x: 90, y: lbl.minY, w: view.w-120, h: 40), lines: 2, to: scroll)
        let attr = NSMutableAttributedString(string: "見学希望日時", attributes: [.font : Font.bold.with(18)])
        attr.append(NSAttributedString(string: "\n※候補枠を３つ登録ください", attributes: [.font : Font.normal.with(14)]))
        lbl2.attributedText = attr
        
        var y = lbl.maxY+20
        for _ in 0...2 {
            dateTimeF(y: &y)
        }
        
        let lbl3 = nessesaryLbl(true, y: y)
        let lbl4 = UILabel(CGRect(x: 90, y: lbl3.minY, w: view.w-120, h: 30), text: "伝えておきたいこと", font: .bold, textSize: 18, to: scroll)
        
        textView = TextView(CGRect(x: 30, y: lbl4.maxY+20, w: view.w-60, h: 120),
                            placeholder: "見学時に確認したいことや、ご要望等ございましたらご記入ください", text: "", to: scroll)
        textView.didBeginEdit = {
            self.scroll.setContentOffset(CGPoint(x: 0, y: lbl4.minY-10), animated: true)
        }
        
        reserveBtn = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: view.h-80), text: "この内容で予約する", to: view) {
            var dates = [Date]()
            for date in self.dateTime {
                if let date = date {
                    dates.append(date)
                }
            }
            self.showAlert(title: "この時間で予約リクエストを送信しますか？",
                           message: dates.map({ $0.toString(format: .full) }).joined(separator: "\n"),
                           btnTitle: "送信", cancelBtnTitle: "キャンセル") {
                self.request.objc.reserveKibou = dates.map({ $0.timestamp() })
                self.request.objc.reserveComment = self.textView.text ?? ""
                try! Ref.requests.document(self.request.id).setData(from: self.request.objc, completion: { e in
                    if let e = e {
                        self.showAlert(title: e.localizedDescription)
                    } else {
                        self.doneReserve()
                    }
                })
            }
        }
        
        datePickerH = UIView(CGRect(y: view.h, w: view.w, h: 50), color: .themePale, to: view)
        let closeBtn = ImageBtn(CGPoint(x: view.w-50, y: 0), image: .chevronD, width: 50, theme: .clearTheme, to: datePickerH)
        closeBtn.addAction {
            self.closeDatePicker()
        }
        
        datePicker.timeZone = NSTimeZone.local
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.backgroundColor = UIColor.white
        datePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        closeDatePicker()
    }
    func dateTimeF(y: inout CGFloat) {
        let editingIdx = timePickers.count
        let dateBtn = UIButton.dropBtn(CGRect(x: 30, y: y, w: 160, h: 50), text: "◯月◯日", to: scroll) {
            self.editingIdx = editingIdx
            self.datePicker.date = self.dateTime[editingIdx] ?? Date()
            self.datePicker.datePickerMode = .date
            self.showDatePicker()
        }
        dateBtn.border(.superPaleGray, width: 1)
        let timeBtn = UIButton.dropBtn(CGRect(x: dateBtn.maxX+10, y: y, w: 140, h: 50), text: "--:--", to: scroll) {
            self.editingIdx = editingIdx
            self.datePicker.date = self.dateTime[editingIdx] ?? Date()
            self.datePicker.datePickerMode = .time
            self.datePicker.minuteInterval = 15
            self.showDatePicker()
        }
        timeBtn.border(.superPaleGray, width: 1)
        y = timeBtn.maxY+10
        
        timePickers.append(timeBtn)
        datePickers.append(dateBtn)
        dateTime.append(nil)
    }
    func closeDatePicker() {
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            self.datePicker.frame.origin.y = self.view.h
            self.datePickerH.frame.origin.y = self.view.h
        } completion: { Bool in
            self.datePicker.removeFromSuperview()
        }
        checkReserveBtn()
    }
    func showDatePicker() {
        self.view.addSubview(self.datePicker)
        UIView.animate(withDuration: 0.2, delay: 0, options: []) {
            self.datePicker.frame = CGRect(x: 0, y: self.view.h-200, width: self.view.w, height: 200)
            self.datePickerH.frame.origin.y = self.view.h-250
        }
    }
    @objc func datePickerValueChanged() {
        let date = datePicker.date
        if datePicker.datePickerMode == .time {
            timePickers[editingIdx].setTitle(date.toString(format: .HHmm), for: .normal)
        } else {
            datePickers[editingIdx].setTitle(date.toString(format: .monthDate), for: .normal)
        }
        dateTime[editingIdx] = date
    }
    func nessesaryLbl(_ bool: Bool, y: CGFloat) -> UILabel {
        let lbl = UILabel(CGRect(x: 30, y: y, w: 50, h: 30),
                          color: bool ? .themeColor : .lightGray, text: bool ? "必須" : "任意",
                          textSize: 14, textColor: .white, align: .center, to: scroll)
        lbl.round(5)
        return lbl
    }
    func checkReserveBtn() {
        for date in dateTime {
            if date == nil {
                reserveBtn.isUserInteractionEnabled = false
                reserveBtn.setTitleColor(.gray, for: .normal)
                reserveBtn.backgroundColor = .superPaleGray
                return
            }
        }
        reserveBtn.isUserInteractionEnabled = true
        reserveBtn.setTitleColor(.white, for: .normal)
        reserveBtn.backgroundColor = .themeColor
    }
    func doneReserve() {
        let white = UIView(CGRect(y: subHeadV.maxY, w: view.w, h: view.h-subHeadV.maxY), color: .white, to: view)
        let text = "ご予約ありがとうございました。日時が決まりましたら、プッシュ通知にてお知らせいたします。"
        let lbl = UILabel(CGRect(x: 30, y: 30, w: view.w-60, h: 200),
                          text: text, textSize: 20, lines: -1, to: white)
        
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            if settings.authorizationStatus == .notDetermined {
                DispatchQueue.main.async {
                    _ = UIButton.coloredBtn(.colorBtn(centerX: white.w/2, y: white.h-180), text: "プッシュ通知ON", to: white) {
                        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
                        UNUserNotificationCenter.current().requestAuthorization(options: authOptions) { authorized, error in
                            self.dismissSelf()
                            self.onDone()
                        }
                    }
                    lbl.text = text + "\n(プッシュ通知をONにしていただくと、\n更新時にすぐ気づくことができます)"
                }
                
            }
        }
        _ = UIButton.coloredBtn(.colorBtn(centerX: white.w/2, y: white.h-120), text: "ホームに戻る", to: white) {
            self.dismissSelf()
            self.onDone()
        }
    }
}
