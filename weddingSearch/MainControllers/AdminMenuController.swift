//
//  AdminMenuController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import Foundation
import UIKit
import UniformTypeIdentifiers

class AdminMenuController: BasicViewController {
    
    var tableView: RequestTableView_admin!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("管理者ページ", withClose: false)
        
        kindLbl = UILabel(CGRect(x: 30, y: head.maxY+10, w: view.w-100, h: 60),
                          text: "お見積もり依頼一覧", font: .bold, textSize: 24, to: view)
        
        tableView = RequestTableView_admin(CGRect(y: kindLbl.maxY, w: view.w, h: view.h-kindLbl.maxY), to: view)
        
    }
}
class RequestTableView_admin: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var requests = [(objc: RequestData, id: String)]()
    var notFoundLbl: UILabel!
    
    init(_ f: CGRect, to view: UIView) {
        super.init(frame: f, style: .plain)
        view.addSubview(self)
        dataSource = self
        delegate = self
        separatorStyle = .none
        sectionHeaderTopPadding = 0
        contentInset.top = 10
        contentInset.bottom = 100
        register(EdtimateCell_admin.self)
        addRefreshControll(target: self, action: #selector(refresh))
        refresh()
        
        NotificationCenter.default.addObserver(self, selector: #selector(refresh), name: .didPostRequest, object: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func refresh() {
        refreshControl?.endRefreshing()
        Ref.requests
            .whereField("done", isEqualTo: RequestState.requested.rawValue)
            .getDocuments(RequestData.self) { snap, requests in
            self.requests = requests
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notFoundLbl?.removeFromSuperview()
        if requests.count == 0 {
            notFoundLbl = UILabel(CGRect(w: w, h: 60), text: "※見積もり待ちの依頼がありません",
                                  textSize: 15, textColor: .lightGray, lines: 2, align: .center, to: self)
        }
        return requests.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(EdtimateCell_admin.self, indexPath: indexPath)
        cell.setUI(request: requests[indexPath.row], w: w)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("didSelectRowAt")
        let vc = EstimateDetailController_admin(request: requests[indexPath.row], onDone: {
            self.requests.remove(at: indexPath.row)
            self.reloadData()
        })
        self.parentViewController.presentFull(vc)
    }
}
class EdtimateCell_admin: UITableViewCell {
    
    var base: UIView!
    var userNameLbl: UILabel!
    var requestAtLbl: UILabel!
    var okBtn: UIButton!
    
    func setUI(request: (objc: RequestData, id: String), w: CGFloat) {
        
        if base == nil {
            selectionStyle = .none
            
            base = UIView(CGRect(x: 30, y: 5, w: w-60, h: 100), color: .white, to: self)
            base.round(16, clip: true)
            base.border(.themePale, width: 2)
            
            userNameLbl = UILabel(CGRect(x: 30, y: 20, w: base.w-150, h: 30), font: .bold, textColor: .darkText, to: base)
            requestAtLbl = UILabel(CGRect(x: 30, y: userNameLbl.maxY, w: base.w-150, h: 30), textColor: .gray, to: base)
            
            okBtn = UIButton.coloredBtn(CGRect(x: base.w-120, y: base.h/2-20, w: 100, h: 40), text: "詳細を見る", to: base, action: {})
            okBtn.isUserInteractionEnabled = false
        }
        Ref.user(uid: request.objc.userId) { user in
            self.userNameLbl.text = user.surnameKanji + " " + user.nameKanji
        }
        requestAtLbl.text = "依頼作成日：\(request.objc.requestedAt.toString(format: .MDE))"
    }
}

class EstimateDetailController_admin: BasicViewController {
    
    var request: (objc: RequestData, id: String)
    var detailV: EstimateRequestDetailView!
    let onDone: () -> Void
    
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
        header("お見積もり前提", withClose: true)
        
        detailV = EstimateRequestDetailView(CGRect(y: head.maxY, w: view.w, h: view.h-head.maxY-90), request: request, to: view)
        _ = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: detailV.maxY+10), text: "お見積もりをアップロード", to: view) {
            self.showPDFPicker()
        }
    }
    
    @objc func showPDFPicker() {
        
        let types: [UTType] = [.pdf]
        let pickerViewController = UIDocumentPickerViewController(forOpeningContentTypes: types, asCopy: true)
        pickerViewController.delegate = self
        presentFull(pickerViewController)
    }
}
extension EstimateDetailController_admin: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        controller.dismiss(animated: true, completion: nil)
        print("didPickDocumentsAt", urls.count)
        guard let url = urls.first else {
            return
        }
        if let document = CGPDFDocument(url as CFURL) {
            let grey = UIView(view.fitRect, color: UIColor(white: 0, alpha: 0.1), to: view)
            let white = UIView(CGRect(x: grey.w/2-150, y: grey.h/2-200, w: 300, h: 400), color: .white, to: grey)
            white.round(16)
            let imgV = UIImageView(CGRect(x: white.w/2-100, y: 30, w: 200, h: 240), to: white)
            imgV.image = document.image(pageNum: 1)
            
            let okBtn = UIButton(CGRect(y: white.h-100, w: white.w, h: 50), text: "PDFを送信", textSize: 16, to: white)
            okBtn.underBar()
            okBtn.topBar()
            okBtn.addAction {
                grey.removeFromSuperview()
                self.waiting = true
                let path = "estimates/\(self.request.id)/\(Date().toFullString())"
                do {
                    let data = try Data(contentsOf: url)
                    Ref.uploadPDF(path, data: data) {
                        self.request.objc.done = RequestState.resulted.rawValue
                        self.request.objc.estimatePDFPath = path
                        try! Ref.requests.document(self.request.id).setData(from: self.request.objc, completion: {_ in
                            self.showAlert(title: "お見積もりをアップロードしました", completion: {
                                self.onDone()
                                self.dismissSelf()
                            })
                        })
                    } onError: { e in
                        self.showAlert(title: "PDFのアップロードに失敗しました", message: e)
                    }
                } catch {
                    self.showAlert(title: "PDFデータを取得できません", message: error.localizedDescription)
                }

            }
            let cancelBtn = UIButton(CGRect(y: white.h-50, w: white.w, h: 50),
                                     text: "キャンセル", textSize: 16, textColor: .systemRed, to: white)
            cancelBtn.addAction {
                grey.removeFromSuperview()
            }
        } else {
            showAlert(title: "PDFデータが不正です")
        }
    }
}
class EstimateRequestDetailView: UIScrollView {
    
    let request: (objc: RequestData, id: String)
    var detailLbl: UILabel!
    
    var itemData : ItemsData?
    var hikidemonoData : HikidemonoData?
    var photoData : PhotoData?
    var movieData : MovieData?
    var brideClothingData : BrideClothingData?
    var groomClothingData : GroomClothingData?
    var parentClothingData : ParentClothingData?
    var other : String?
    
    init(_ f: CGRect, request: (objc: RequestData, id: String), to view: UIView) {
        self.request = request
        super.init(frame: f)
        view.addSubview(self)
        
        detailLbl = UILabel(CGRect(x: 30, y: 0, w: w-60, h: h-60), lines: -1, to: self)
        
        var attr = NSMutableAttributedString()
        addHead(to: &attr, type: .selectVenue)
        addSub(to: attr, text: "式場")
        addTxt(to: attr, text: request.objc.venueInfo?.name)
        
        addHead(to: &attr, type: .basicInfo)
        addSub(to: attr, text: "招待人数")
        addTxt(to: attr, text: (request.objc.basicInfo?.pplToInvite ?? "")+"人")
        addSub(to: attr, text: "子供の数")
        addTxt(to: attr, text: (request.objc.basicInfo?.childToInvite ?? "")+"人")
        addSub(to: attr, text: "結婚式の時期")
        addTxt(to: attr, text: request.objc.basicInfo?.season)
        addSub(to: attr, text: "結婚式の予算")
        addTxt(to: attr, text: request.objc.basicInfo?.budget)
        
        addHead(to: &attr, type: .foodPrice)
        addSub(to: attr, text: "コース料理の料金")
        addTxt(to: attr, text: request.objc.foodPrice)
        
        addHead(to: &attr, type: .needDrinkQ)
        addSub(to: attr, text: "ウェルカムドリンク")
        addTxt(to: attr, text: request.objc.drinkData?.welcome)
        addSub(to: attr, text: "乾杯用シャンパン")
        addTxt(to: attr, text: request.objc.drinkData?.champain)
        
        addHead(to: &attr, type: .knoshiki)
        addSub(to: attr, text: "挙式")
        addTxt(to: attr, text: request.objc.kyoshiki)
        
        addHead(to: &attr, type: .flowerPrice)
        addSub(to: attr, text: "メインテーブル")
        addTxt(to: attr, text: request.objc.flowerData?.mainTable)
        addSub(to: attr, text: "ゲストテーブル")
        addTxt(to: attr, text: request.objc.flowerData?.guestTable)
        addSub(to: attr, text: "ケーキテーブル")
        addTxt(to: attr, text: request.objc.flowerData?.cakeTable)
        
        addHead(to: &attr, type: .otherFlower)
        addSub(to: attr, text: "ブーケ（挙式用）")
        addTxt(to: attr, text: request.objc.otherFlowerData?.bouket)
        addSub(to: attr, text: "ブーケ（お色直し用）")
        addTxt(to: attr, text: request.objc.otherFlowerData?.onaoshi)
        addSub(to: attr, text: "両親に贈呈する花束")
        addTxt(to: attr, text: request.objc.otherFlowerData?.forParent)
        
        addHead(to: &attr, type: .otherFlower)
        addSub(to: attr, text: "ブーケ（挙式用）")
        addTxt(to: attr, text: request.objc.otherFlowerData?.bouket)
        addSub(to: attr, text: "ブーケ（お色直し用）")
        addTxt(to: attr, text: request.objc.otherFlowerData?.onaoshi)
        addSub(to: attr, text: "両親に贈呈する花束")
        addTxt(to: attr, text: request.objc.otherFlowerData?.forParent)
        
        addHead(to: &attr, type: .otherItems)
        addSub(to: attr, text: "招待状")
        addTxt(to: attr, text: request.objc.itemData?.invitation)
        addSub(to: attr, text: "席次表")
        addTxt(to: attr, text: request.objc.itemData?.seatList)
        addSub(to: attr, text: "席札")
        addTxt(to: attr, text: request.objc.itemData?.seatName)
        addSub(to: attr, text: "メニュー表")
        addTxt(to: attr, text: request.objc.itemData?.menuList)
        
        addHead(to: &attr, type: .hikidemono)
        addSub(to: attr, text: "引出物")
        addTxt(to: attr, text: request.objc.hikidemonoData?.hikidemono)
        addSub(to: attr, text: "引菓子")
        addTxt(to: attr, text: request.objc.hikidemonoData?.hikigashi)
        
        addHead(to: &attr, type: .photoToTake)
        addSub(to: attr, text: "スナップアルバム")
        addTxt(to: attr, text: request.objc.photoData?.snapAlbum)
        addSub(to: attr, text: "型物写真")
        addTxt(to: attr, text: request.objc.photoData?.katabutsuPhoto)
        addSub(to: attr, text: "前撮り撮影")
        addTxt(to: attr, text: request.objc.photoData?.maedori)
        
        addHead(to: &attr, type: .typeOfVideo)
        addSub(to: attr, text: "フォトムービー")
        addTxt(to: attr, text: request.objc.movieData?.photoMovie)
        addSub(to: attr, text: "撮って出しエンドロール")
        addTxt(to: attr, text: request.objc.movieData?.endroll)
        
        addHead(to: &attr, type: .brideClothing)
        addSub(to: attr, text: "洋装（WD）１着目")
        addTxt(to: attr, text: request.objc.brideClothingData?.western_wd_1)
        addSub(to: attr, text: "洋装（WD）２着目")
        addTxt(to: attr, text: request.objc.brideClothingData?.western_wd_2)
        addSub(to: attr, text: "洋装（CD）１着目")
        addTxt(to: attr, text: request.objc.brideClothingData?.western_cd_1)
        addSub(to: attr, text: "洋装（CD）２着目")
        addTxt(to: attr, text: request.objc.brideClothingData?.western_cd_2)
        addSub(to: attr, text: "和装（打掛、白無垢）")
        addTxt(to: attr, text: request.objc.brideClothingData?.japanese)
        
        addHead(to: &attr, type: .groomClothing)
        addSub(to: attr, text: "洋装（タキシード）")
        addTxt(to: attr, text: request.objc.groomClothingData?.western_tax)
        addSub(to: attr, text: "洋装（カジュアルスーツ）")
        addTxt(to: attr, text: request.objc.groomClothingData?.western_casual)
        addSub(to: attr, text: "和装（紋付）")
        addTxt(to: attr, text: request.objc.groomClothingData?.japanese)
        
        addHead(to: &attr, type: .parentClothing)
        addSub(to: attr, text: "モーニングコート（お父様用）")
        addTxt(to: attr, text: request.objc.parentClothingData?.dad)
        addSub(to: attr, text: "留袖（お母様用）")
        addTxt(to: attr, text: request.objc.parentClothingData?.mom)
        
        addHead(to: &attr, type: .otherInfo)
        addTxt(to: attr, text: "\n" + (request.objc.other ?? ""))
        
        detailLbl.attributedText = attr
        detailLbl.fitHeight()
        contentSize.height = detailLbl.maxY+30
    }
    func addHead(to attr: inout NSMutableAttributedString, type: QuestionType) {
        attr.append(NSAttributedString(string: "\n\n\(type.question.replacingOccurrences(of: "\n", with: ""))\n", attributes: [NSAttributedString.Key.font : Font.bold.with(20)]))
    }
    func addSub(to attr: NSMutableAttributedString, text: String?) {
        attr.append(NSAttributedString(string: "\n\(text ?? "")：  ", attributes: [NSAttributedString.Key.font : Font.bold.with(17)]))
    }
    func addTxt(to attr: NSMutableAttributedString, text: String?) {
        attr.append(NSAttributedString(string: text ?? "", attributes: [NSAttributedString.Key.font : Font.normal.with(15)]))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension CGPDFDocument {
    
    func image(pageNum: Int) -> UIImage? {
        
        guard let page = self.page(at: pageNum) else {
            return nil
        }
        let pageRect = page.getBoxRect(.mediaBox)
        let renderer = UIGraphicsImageRenderer(size: pageRect.size)
        let image = renderer.image { ctx in
            UIColor.white.set()
            ctx.fill(pageRect)
            ctx.cgContext.translateBy(x: 0.0, y: pageRect.size.height)
            ctx.cgContext.scaleBy(x: 1.0, y: -1.0)
            ctx.cgContext.drawPDFPage(page)
        }
        return image
    }
}
