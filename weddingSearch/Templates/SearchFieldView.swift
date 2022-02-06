//
//  SearchFieldView.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/06/08.
//

import UIKit

protocol SearchFieldViewDelegate: AnyObject {
    func searchTextDidChange()
    func doSearch()
    func doBegin()
}
class SearchFieldView: TextField {
    
    weak var searchDelegate: SearchFieldViewDelegate!
    var searchBtn: ImageBtn!
    var deleteBtn: ImageBtn!
    var keywords: [String] {
        if let text = text, !text.isEmpty {
            return Tokenizer.tokenize(text: text)
        }
        return []
    }
    
    init(_ f: CGRect, placeholder: String, searchBtnType: ImageType = .magnifyingglass, searchDelegate: SearchFieldViewDelegate, to v: UIView) {
        super.init(frame: f)
        self.searchDelegate = searchDelegate
        delegate = self
        //addDoneToolbar("SEARCH")
        
        searchBtn = ImageBtn(CGPoint(x: 5, y: 5), image: searchBtnType, width: f.height-10, theme: .clearBlack, to: self)
        if searchBtnType == .magnifyingglass {
            searchBtn.addTarget(self, action: #selector(search), for: .touchUpInside)
        }
        deleteBtn = ImageBtn(CGPoint(x: f.width-f.height+5, y: 5), image: .closeBtn, width: f.height-10, theme: .red, to: self)
        deleteBtn.addTarget(self, action: #selector(reset), for: .touchUpInside)
        deleteBtn.isHidden = true
        padding = UIEdgeInsets(top: 0, left: f.height, bottom: 0, right: f.height)
        backgroundColor = .white
        round()
        font = Font.normal.with(f.height*0.4)
        textColor = .black
        returnKeyType = .search
        attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.lightGray])
        v.addSubview(self)
        v.addSubview(self)
    }
    @objc func reset() {
        text = nil
        textFieldDidEndEditing(self)
    }
    @objc func search() {
        resignFirstResponder()
        textFieldDidEndEditing(self)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension SearchFieldView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        DispatchQueue.main.async {
            self.deleteBtn.isHidden = self.text?.isEmpty ?? true
            self.searchDelegate.searchTextDidChange()
        }
        return true
    }
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        searchDelegate.doBegin()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        searchDelegate.doSearch()
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        searchDelegate.doSearch()
        return true
    }
}

struct Tokenizer {

    // MARK: - Publics
    static func tokenize(text: String) -> [String] {
        var tokens: [String] = []
        let linguisticTagger = NSLinguisticTagger(tagSchemes: NSLinguisticTagger.availableTagSchemes(forLanguage: "ja"), options: 0)
        linguisticTagger.string = text
        linguisticTagger.enumerateTags(in: NSRange(location: 0, length: text.count),
                            scheme: .tokenType,
                            options: [.omitWhitespace]) { tag, tokenRange, sentenceRange, stop in
            let subString = (text as NSString).substring(with: tokenRange)
            if !tokens.contains(subString) {
                tokens.append(subString)
            }
        }
        print("tokens", tokens)
        return tokens
    }
}
