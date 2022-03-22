//
//  EstimateResultController.swift
//  weddingSearch
//
//  Created by 中力天和 on 2022/03/22.
//

import Foundation
import UIKit
import PDFKit

class EstimateResultController: BasicViewController {
    
    var request: (objc: RequestData, id: String)! {
        didSet {
            setUI()
        }
    }
    var idx: Int
    let maxIdx: Int
    
    var detailV: EstimateRequestDetailView!
    var estimatePDFV: PDFView!
    var lineInquiry: UIButton!
    
    var upBtn: ImageBtn!
    var downBtn: ImageBtn!
    
    var onIdxChange: (Int) -> (objc: RequestData, id: String)
    
    init(idx: Int, maxIdx: Int, onIdxChange: @escaping (Int) -> (objc: RequestData, id: String)) {
        self.idx = idx
        self.maxIdx = maxIdx
        self.onIdxChange = onIdxChange
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        header("結果を見る", withClose: true)
        subHeader()
        upBtn = ImageBtn(CGPoint(x: view.w-90, y: subHeadV.center.y-20), image: .chevronU, to: view)
        upBtn.addAction {
            self.didChangeIdx(self.idx-1)
        }
        downBtn = ImageBtn(CGPoint(x: view.w-50, y: subHeadV.center.y-20), image: .chevronD, to: view)
        downBtn.addAction {
            self.didChangeIdx(self.idx+1)
        }
        
        headBtns(kindlbls: ["金額", "見積もり前提"], selected: pageSelected)
        didChangeIdx(idx)
    }
    func didChangeIdx(_ idx: Int) {
        self.idx = idx
        upBtn.tintColor = idx==0 ? .gray : .themeColor
        upBtn.isUserInteractionEnabled = idx != 0
        downBtn.tintColor = maxIdx==idx ? .gray : .themeColor
        downBtn.isUserInteractionEnabled = maxIdx != idx
        
        request = onIdxChange(idx)
    }
    func setUI() {
        
        subHead.attributedText = NSAttributedString(string: request.objc.venueInfo?.name ?? "nil",
                                                    attributes: [.font : Font.bold.with(16),
                                                                .foregroundColor: UIColor.themeColor])
        detailV?.removeFromSuperview()
        estimatePDFV?.removeFromSuperview()
        lineInquiry?.removeFromSuperview()
        
        var rect = CGRect(y: kindLbl.maxY+10, w: view.w, h: s.maxY-kindLbl.maxY-30)
        detailV = EstimateRequestDetailView(rect, request: request, to: view)
        detailV.clipsToBounds = true
        
        rect.size.height -= 60
        estimatePDFV = PDFView(rect, color: .superPaleGray, to: view)
        estimatePDFV.autoScales = true
        if let path = request.objc.estimatePDFPath {
            Ref.getPDF(path) { doc in
                self.estimatePDFV.document = doc
            }
        }
        lineInquiry = UIButton.lineInquiry(y: estimatePDFV.maxY+10, to: view)
        
        pageSelected(0)
    }
    func pageSelected(_ idx: Int) {
        switch idx {
        case 0:
            detailV.isHidden = true
            estimatePDFV.isHidden = false
            lineInquiry.isHidden = false
        default:
            detailV.isHidden = false
            estimatePDFV.isHidden = true
            lineInquiry.isHidden = true
        }
    }
}
