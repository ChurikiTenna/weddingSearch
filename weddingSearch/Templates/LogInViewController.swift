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


class LogInViewController: BasicViewController {
     
    var btns = [UIButton]()
    
    var emailInputF: TextFieldAndTtl!
    var passwordF: TextFieldAndTtl!
    
    var registerBtn: UIButton!
    
    var otherLbl: UILabel?
    
    var appleButton: UIButton!
    var googleButton: UIButton?
    
    var selectionBar: UIView!
    
    override func viewWillAppear(_ animated: Bool) {
        if registerBtn != nil { return }
        super.viewWillAppear(animated)
        view.backgroundColor = .white
        
        let exp = UILabel(CGRect(x: 16, y: 20, w: view.w-32, h: 30), text: "続けるにはログインが必要です", font: .bold, textSize: 16, align: .center, to: view)
        
        var x = CGFloat()
        for text in ["新規登録", "ログイン"] {
            
            let btn = UIButton(CGRect(x: x, y: exp.frame.maxY+10, w: view.w/2, h: 40), text: text, textSize: 16, to: view)
            btn.addTarget(self, action: #selector(changeSignUpOrIn), for: .touchUpInside)
            if x == 0 {
                selectionBar = UIView(CGRect(y: btn.frame.maxY, w: btn.frame.width, h: 5), color: .themeColor, to: view)
            }
            btns.append(btn)
            x += safe.width/2
        }
        
        var y = selectionBar.frame.maxY+30
        
        emailInputF = TextFieldAndTtl(.textF_rect(centerX: view.w/2, y: &y), ttl: "メールアドレス", to: view)
        emailInputF.textField.keyboardType = .emailAddress
        
        passwordF = TextFieldAndTtl(.textF_rect(centerX: view.w/2, y: &y), ttl: "パスワード", to: view)
        passwordF.textField.isSecureTextEntry = true
        passwordF.textField.keyboardType = .alphabet
        
        
        let forgetBtn = UIButton(full_rect(h: 30, y: &y), text: "パスワードを忘れましたか？", textSize: 14, textColor: .gray, to: view)
        forgetBtn.addTarget(self, action: #selector(passwordReset), for: .touchUpInside)
        
        registerBtn = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: y), text: "登録", to: view, action: registerWithPassword)
        y = registerBtn.maxY+20
        
        otherLbl = UILabel(full_rect(h: 20, y: &y), text: "その他の登録方法", textColor: .lightGray, align: .center, to: view)
        
        
        appleButton = UIButton.coloredBtn(.colorBtn(centerX: view.w/2, y: y), text: "", to: view, action: signInWithApple)
        appleButton.setImage(UIImage(named: "apple"), for: .normal)
        y = appleButton.maxY+20
        
        y += 20
        let kiyaku = UIButton(CGRect(x: 0, y: y), text: "利用規約・", textSize: 14, textColor: .link, to: view)
        kiyaku.sizeToFit()
        kiyaku.addTarget(self, action: #selector(open_kiyaku), for: .touchUpInside)
        
        let kojinjouhou = UIButton(CGRect(x: 0, y: y), text: "個人情報保護方針", textSize: 14, textColor: .link, to: view)
        kojinjouhou.sizeToFit()
        kojinjouhou.addTarget(self, action: #selector(open_kojinjouhouhogo), for: .touchUpInside)
        centerMe([kiyaku, kojinjouhou])
        
        changeSignUpOrIn(btns[0])
    }
    func centerMe(_ views: [UIView]) {
        // 1番目が一番左、最後が一番右の一列に並んだviewsで、viewの間に隙間は無いとする
        var wd = CGFloat()
        views.forEach { wd += $0.w }
        var x = (view.w-wd)/2
        for view in views {
            view.frame.origin.x = x
            x = view.maxX
        }
    }
    @objc func passwordReset() {
        view.endEditing(true)
        if emailInputF.text.isEmpty {
            showAlert(title: "メールアドレスを入力してください")
            return
        }
        Auth.auth().sendPasswordReset(withEmail: emailInputF.text) { e in
            if let e = e {
                self.showAlert(title: "メール送信に失敗しました", message: e.localizedDescription)
            } else {
                self.showAlert(title: "パスワードリセットのメールを送信しました")
            }
        }
    }
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
    // 実際には特に効果なし
    @objc func changeSignUpOrIn(_ b: UIButton) {
        UIView.animate(withDuration: 0.2, animations: {
            self.selectionBar.frame.origin.x = b.frame.minX
        }, completion: {_ in
        
            var text = "ログイン"
            if self.selectionBar.frame.origin.x == 0 {
                text = "登録"
            }
            self.appleButton?.setTitle(" Appleで\(text)", for: .normal)
            self.googleButton?.setTitle("Googleで\(text)", for: .normal)
            self.registerBtn.setTitle(text, for: .normal)
            self.otherLbl?.text = "その他の\(text)方法"
        })
    }
    
    // Unhashed nonce.
    private(set) var currentNonce: String?
    
    // ログイン成功
    func didSuccessLogin() {
        print("didSuccessLogin")
        self.waiting = false
        NotificationCenter.post(.logInStatusUpdated)
        dismiss(animated: true) { }
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
        waiting = true
        guard let clientId = FirebaseApp.app()?.options.clientID else {
            noticeFailDelegate(cause: "")
            return
        }
        let signInConfig = GIDConfiguration.init(clientID: clientId)
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: self) { user, error in
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
        waiting = true
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
        }
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
extension LogInViewController: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return view.window!
    }
}

extension LogInViewController {
    
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
            try! Ref.users.document(result.user.uid).setData(from: User(name: result.user.displayName ?? "", email: result.user.email ?? ""), merge: true) {_ in
                self.didSuccessLogin()
            }
        }
    }
    
    /// SafariViewControllerに遷移する
    /// - Parameter urlString: 表示するURL
    private func transitionSafariViewController(urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let vc = SFSafariViewController(url: url)
        vc.dismissButtonStyle = .close
        present(vc, animated: true, completion: nil)
    }
    /// ログインに失敗した通知を送る
    private func noticeFailDelegate(cause: String) {
        waiting = false
        showAlert(title: "サインインに失敗しました", message: cause, completion: nil)
        print("ログインに失敗しました", cause)
    }
}

extension LogInViewController: ASAuthorizationControllerDelegate {
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
