//
//  LogInViewController.swift
//  QuizMaker
//
//  Created by 中力天和 on 2022/01/18.
//

import UIKit
import SafariServices
import AuthenticationServices
import CryptoKit
import Firebase
import GoogleSignIn
import FirebaseFirestore
import FirebaseFirestoreSwift


class LogInView: UIScrollView {
     
    var base: UIView!
    var stepRounds = [UIView]()
    var stepLbls = [UILabel]()
    
    // step0
    var emailInputF: TextFieldAndTtl!
    //var passwordF: TextFieldAndTtl!
    var registerBtn: UIButton!
    var otherLbl: UILabel?
    var appleButton: UIButton!
    
    //step1
    var surnameKanjiF: TextFieldAndTtl!
    var nameKanjiF: TextFieldAndTtl!
    var surnameKanaF: TextFieldAndTtl!
    var nameKanaF: TextFieldAndTtl!
    var birthDateF: BirthDateField!
    var genderF: TextFieldAndTtl!
    
    init(to v: UIView) {
        super.init(frame: v.fitRect)
        backgroundColor = .superPaleBackGray
        
        v.addSubview(self)
        _=UIButton.closeBtn(to: self, x: 10, y: s.minY+10, theme: .clearBlack, type: .multiply, action: closeSelf)
        base = UIView(fitRect, color: .clear, to: self)
        
        let wd: CGFloat = 30
        let gap: CGFloat = 80
        var x = (w-wd*3-gap*2)/2
        var idx = 1
        let steps = ["SNS認証", "プロフイール入力", "登録完了"]
        for text in steps {
            
            let round = UILabel(CGRect(x: x, y: s.minY+70, w: wd, h: wd),
                                text: "\(idx)", font: .bold, textColor: .white, align: .center, to: self)
            round.round()
            stepRounds.append(round)
            
            let lbl = UILabel(CGRect(x: x-50, y: round.maxY, w: wd+100, h: 30),
                              text: text, align: .center, to: self)
            stepLbls.append(lbl)
            
            if text != steps.last {
                _=UIView(CGRect(x: round.maxX+5, y: round.center.y-2, w: gap-10, h: 4), color: .superPaleGray, to: self)
            }
            
            idx += 1
            x = round.maxX+gap
        }
        
        step(0)
    }
    func step(_ idx: Int) {
        for i in 0..<stepRounds.count {
            stepRounds[i].backgroundColor = idx >= i ? .gray : .superPaleGray
            stepLbls[i].textColor = idx >= i ? .gray : .superPaleGray
        }
        for sub in base.subviews { sub.removeFromSuperview() }
        switch idx {
        case 0: snsRegisterView()
        case 1: registerUserView()
        default: break
        }
    }
    
    func setHead(_ title: String, sub: String) -> CGFloat {
        
        var y = s.minY+10
        
        _ = UILabel(.full_rect(y: &y, h: 40, plusY: 90, view: base),
                    text: title, font: .bold, textSize: 18, align: .center, to: base)
        
        _ = UILabel(.full_rect(y: &y, h: 50, view: base), text: sub, lines: -1, to: base)
        
        return y
    }
    
    func snsRegisterView() {
        
        var y = setHead("携帯番号登録", sub: "ご本人確認のため、SMS認証を行います。\n携帯番号を入力してください。")
        
        emailInputF = TextFieldAndTtl(textF_rect(y: &y, plusY: 20), ttl: "電話番号", to: base)
        emailInputF.textField.keyboardType = .phonePad
        /*
        passwordF = TextFieldAndTtl(.textF_rect(centerX: self.w/2, y: &y), ttl: "パスワード（８桁以上）", to: self)
        passwordF.textField.isSecureTextEntry = true
        passwordF.textField.keyboardType = .alphabet
        
        
        let forgetBtn = UIButton(.full_rect(y: &y, h: 30, view: self),
                                 text: "パスワードを忘れましたか？", textSize: 14, textColor: .gray, to: self)
        forgetBtn.addTarget(self, action: #selector(passwordReset), for: .touchUpInside)*/
        
        registerBtn = UIButton.coloredBtn(.colorBtn(centerX: w/2, y: y),
                                          text: "SNS認証", to: base, action: registerWithPassword)
        y = registerBtn.maxY+20
        
        otherLbl = UILabel(.full_rect(y: &y, h: 30, view: base),
                           text: "その他の登録方法", textColor: .lightGray, align: .center, to: base)
        
        
        appleButton = UIButton.coloredBtn(.colorBtn(centerX: self.w/2, y: y),
                                          text: "Appleで登録", color: .black, to: base, action: signInWithApple)
        appleButton.setImage(UIImage(named: "apple"), for: .normal)
        y = appleButton.maxY+20
        
        y += 20
        let kiyaku = UIButton(CGRect(x: 0, y: y),
                              text: "利用規約・", textSize: 14, textColor: .link, to: base)
        kiyaku.sizeToFit()
        kiyaku.addTarget(self, action: #selector(open_kiyaku), for: .touchUpInside)
        
        let kojinjouhou = UIButton(CGRect(x: 0, y: y),
                                   text: "個人情報保護方針", textSize: 14, textColor: .link, to: base)
        kojinjouhou.sizeToFit()
        kojinjouhou.addTarget(self, action: #selector(open_kojinjouhouhogo), for: .touchUpInside)
        centerMe([kiyaku, kojinjouhou])
        
    }
    
    func registerUserView() {
        
        var y = setHead("プロフィール入力", sub: "必要なプロフィールを入力してください。\n事前登録で、式場をスムーズに予約できます。")
        
        surnameKanjiF = TextFieldAndTtl(textF_rect(y: &y), ttl: "姓", to: base)
        nameKanjiF = TextFieldAndTtl(textF_rect(y: &y), ttl: "名", to: base)
        surnameKanaF = TextFieldAndTtl(textF_rect(y: &y), ttl: "セイ", to: base)
        nameKanaF = TextFieldAndTtl(textF_rect(y: &y), ttl: "メイ", to: base)
        birthDateF = BirthDateField.initMe(textF_rect(y: &y), user: User(), to: base)
        genderF = TextFieldAndTtl(textF_rect(y: &y), ttl: "性別", to: base)
        
        _ = UIButton.coloredBtn(.colorBtn(centerX: base.w/2, y: y), text: "内容を確認して登録", to: base) {
            var errors = [String]()
            if self.surnameKanjiF.empty { errors.append("姓を入力してください") }
            if self.nameKanjiF.empty { errors.append("名を入力してください") }
            if self.surnameKanaF.empty { errors.append("セイを入力してください") }
            if self.nameKanaF.empty { errors.append("メイを入力してください") }
            if self.birthDateF.empty { errors.append("生年月日を入力してください") }
            if self.genderF.empty { errors.append("性別を入力してください") }
            if errors.count > 0 {
                self.showAlert(title: "未入力の項目があります", message: errors.joined(separator: "\n"))
            } else {
                let user = User(nameKanji: self.nameKanjiF.text,
                                surnameKanji: self.surnameKanjiF.text,
                                nameKana: self.nameKanaF.text,
                                surnameKana: self.surnameKanaF.text,
                                birthDate: self.birthDateF.date!.toDate().timestamp(),
                                gender: self.genderF.text)
                try! Ref.users.document(SignIn.uid!).setData(from: user, merge: true) {_ in
                    self.didSuccessLogin()
                }
            }
        }
        contentSize.height = y+20
    }
    
    func textF_rect(y: inout CGFloat, plusY: CGFloat = 10) -> CGRect {
        return .fill_rect(y: &y, h: 70, plusY: plusY, view: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func centerMe(_ views: [UIView]) {
        // 1番目が一番左、最後が一番右の一列に並んだviewsで、viewの間に隙間は無いとする
        var wd = CGFloat()
        views.forEach { wd += $0.w }
        var x = (self.w-wd)/2
        for v in views {
            v.frame.origin.x = x
            x = v.maxX
        }
    }
    /*@objc func passwordReset() {
        endEditing(true)
        if emailInputF.text.isEmpty {
            showAlert(title: "電話番号を入力してください")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailInputF.text) { e in
            if let e = e {
                self.showAlert(title: "メール送信に失敗しました", message: e.localizedDescription)
            } else {
                self.showAlert(title: "パスワードリセットのメールを送信しました")
            }
        }
    }*/
    @objc func open_kiyaku() {
        guard let url = URL(string: "todo kiyaku")
        else {
            showAlert(title: "URLを開けません")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    @objc func open_kojinjouhouhogo() {
        guard let url = URL(string: "todo privacy")
        else {
            showAlert(title: "URLを開けません")
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url)
        }
    }
    // Unhashed nonce.
    private(set) var currentNonce: String?
    
    // ログイン成功
    func didSuccessLogin() {
        print("didSuccessLogin")
        self.waitingController.waiting = false
        NotificationCenter.post(.logInStatusUpdated)
        closeSelf()
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        let charset: Array<Character> =
            Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        var result = ""
        var remainingLength = length
        
        while remainingLength > 0 {
            let randoms: [UInt8] = (0 ..< 16).map { _ in
                var random: UInt8 = 0
                let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
                if errorCode != errSecSuccess {
                    fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
                }
                return random
            }
            
            randoms.forEach { random in
                if remainingLength == 0 { return }
                
                if random < charset.count {
                    result.append(charset[Int(random)])
                    remainingLength -= 1
                }
            }
        }
        return result
    }
    /// ログイン開始
    @objc func signInWithApple() {
        let nonce = randomNonceString()
        currentNonce = nonce
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
        
        let ac = ASAuthorizationController(authorizationRequests: [request])
        ac.delegate = self
        ac.presentationContextProvider = self
        ac.performRequests()
    }
    @objc func signInWithGoogle() {
        waitingController.waiting = true
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            noticeFailDelegate(cause: "")
            return
        }
        let signInConfig = GIDConfiguration.init(clientID: clientId)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: parentViewController) { user, error in
            if let error = error {
                self.noticeFailDelegate(cause: error.localizedDescription)
                return
            }
            guard let user = user else {
                self.noticeFailDelegate(cause: "no user")
                return
            }
            /// Googleでサインイン
            guard let token = user.authentication.idToken else { return }
            let credential = GoogleAuthProvider.credential(withIDToken: token, accessToken: user.authentication.accessToken)
            self.signIn(credential)
        }
    }
    @objc func registerWithPassword() {
        //todo with phoneNumber https://firebase.google.com/docs/auth/ios/phone-auth?authuser=0
        /*waitingController.waiting = true
        let email = emailInputF.text
        let password = passwordF.text
        guard email.isValidEmail else {
            noticeFailDelegate(cause: "正しいメールアドレスを入力してください")
            return
        }
        guard password.count >= 8 else {
            noticeFailDelegate(cause: "パスワードは８文字以上で入力してください")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("already have account?", error)
                Auth.auth().signIn(withEmail: email, password: password) { result, error in
                    guard let result = result, error == nil else {
                        self.noticeFailDelegate(cause: error?.localizedDescription ?? "no result")
                        return
                    }
                    self.registerUser(result)
                }
            } else {
                guard let result = result else {
                    self.noticeFailDelegate(cause: "結果がありません")
                    return
                }
                self.registerUser(result)
            }
        }*/
    }
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            return String(format: "%02x", $0)
        }.joined()
        return hashString
    }
}
extension LogInView: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return window!
    }
}

extension LogInView {
    
    func registerUser(_ result: AuthDataResult) {
        
        Ref.users.document(result.user.uid).getDocument { (snapshot, error) in
            if let error = error {
                print(error.localizedDescription)
                self.noticeFailDelegate(cause: "ユーザー情報の取得に失敗しました")
                return
            }
            // ログインしたことがある
            if snapshot?.data() != nil {
                self.didSuccessLogin()
                return
            }
            // ユーザー情報を登録する
            self.step(1)
        }
    }
    
    /// ログインに失敗した通知を送る
    private func noticeFailDelegate(cause: String) {
        waitingController.waiting = false
        showAlert(title: "サインインに失敗しました", message: cause, completion: nil)
        print("ログインに失敗しました", cause)
    }
}

extension LogInView: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        guard let nonce = currentNonce else {
            fatalError("Invalid state: A login callback was received, but no login request was sent.")
        }
        guard let appleIDToken = appleIDCredential.identityToken else {
            noticeFailDelegate(cause: "Unable to fetch identity token")
            return
        }
        guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
            noticeFailDelegate(cause: "Unable to serialize token string from data: \(appleIDToken.debugDescription)")
            return
        }
        let credential = OAuthProvider.credential(withProviderID: "apple.com", idToken: idTokenString, rawNonce: nonce)
        signIn(credential)
    }
    func signIn(_ credential: AuthCredential) {
        Auth.auth().signIn(with: credential) { (result, error) in
            // ログインエラー
            if let error = error {
                self.noticeFailDelegate(cause: error.localizedDescription)
                return
            }
            // Appleのデータを取得できなかった
            guard let result = result else {
                self.noticeFailDelegate(cause: "Appleのデータを取得できませんでした")
                return
            }
            self.registerUser(result)
        }
    }
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        noticeFailDelegate(cause: error.localizedDescription)
    }
}
extension String {
    var isValidEmail: Bool {
        let email = NSPredicate(format: "SELF MATCHES %@ ", "^([A-Z0-9a-z._+-])+@([A-Za-z0-9.-])+\\.([A-Za-z]{2,})$")
        return email.evaluate(with: self)
    }
    var isValidPassword: Bool {
        let password = NSPredicate(format: "SELF MATCHES %@ ", "^(?=.*[a-z])(?=.*[0-9]).{8,}$")
        return password.evaluate(with: self)
    }
}
