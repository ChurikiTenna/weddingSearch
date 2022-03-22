//
//  Firebase.swift
//  QuizMaker
//
//  Created by 中力天和 on 2022/01/18.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import CoreLocation
import UIKit
import PDFKit


class SignIn {
    /// ユーザーid
    internal static var uid: String? {
        return Auth.auth().currentUser?.uid
    }
    internal static var email: String? {
        return Auth.auth().currentUser?.email
    }
    internal static var phone: String? {
        return Auth.auth().currentUser?.phoneNumber
    }
    /// ログアウト処理
    internal static func logout() {
        do {
            try Auth.auth().signOut()
            NotificationCenter.post(.logInStatusUpdated)
        } catch let e {
            fatalError(e.localizedDescription)
        }
    }
}

enum FavoriteType: String {
    case users
    case requests
}

struct OnlyDate: Codable {
    var date: Timestamp!
}
struct AdminData: Codable {
    var emails = [String]()
}
class Ref {
    // Firestore 用
    static var store: Firestore { return Firestore.firestore() }
    // collection
    static var users: CollectionReference
    { store.collection("users") }
    static var requests: CollectionReference
    { store.collection("requests") }
    static var admins: CollectionReference
    { store.collection("admins") }
    
    static var now: Timestamp { return Timestamp(date: Date()) }
    static var onlyDate: [String : Any] { return try! Firestore.Encoder().encode(OnlyDate(date: now)) }
    
    static func sendRequest(_ data: RequestData, onDone: @escaping (Error?) -> Void) {
        _ = try! Ref.requests.addDocument(from: data, completion: onDone)
    }
    
    // ユーザ取得
    static func user(uid: String?, onSuccess: @escaping (User) -> Void) {
        guard let uid = uid else { return }
        users.document(uid).getDocument(User.self) { user in
            if let user = user {
                onSuccess(user)
            } else if uid == SignIn.uid {
                SignIn.logout()
            }
        }
    }
    
    // 画像アップロード
    static func uploadImage(images: [UIImage?], fileName: String,
                            onSuccess: @escaping ([String?]) -> Void,
                            onError: @escaping (String) -> Void) {
        let dispatchSemaphore = DispatchSemaphore(value: 0)
        DispatchQueue(label: "imageUploadTask").async {
            // アップロードに失敗したら保持するためにある
            var e: Error?
            var names = [String?]()
            for image in images {
                guard let image = image else {
                    names.append(nil)
                    continue
                }
                // アップロード処理
                let name = fileName + "\(names.count)"
                names.append(name)
                self.uploadImage(name, image: image, onSuccess: {
                    dispatchSemaphore.signal()
                }) { (error) in
                    e = error
                    dispatchSemaphore.signal()
                    return
                }
                dispatchSemaphore.wait()
            }
            DispatchQueue.main.async {
                if let e = e {
                    onError(e.localizedDescription)
                } else {
                    onSuccess(names)
                }
            }
        }
    }
    // 画像アップロード（１つ）
    internal static func uploadImage(_ path: String, image: UIImage,
                                onSuccess: @escaping () -> Void,
                                onError: @escaping (_ error: Error) -> Void) {
        print("upload filePath", path)
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        var image = image
        print("image.size", image.size)
        if image.size.width > 900 || image.size.height > 900 {
            if image.widthWider {
                image = image.resize(resizedSize: CGSize(width: 900, height: 900*image.size.height/image.size.width)) ?? image
            } else {
                image = image.resize(resizedSize: CGSize(width: 900*image.size.width/image.size.height, height: 900)) ?? image
            }
        }
        guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
        print(imageData)
        storage(path).putData(imageData, metadata: metaData) { (_, e) in
            if let e = e { onError(e); return }
            onSuccess()
        }
    }
    internal static func uploadPDF(_ path: String, data: Data,
                                     onSuccess: @escaping () -> Void,
                                     onError: ((String) -> Void)? = nil) {
        print("uploadPDF to", path, data)
        storage(path).putData(data, metadata: nil) { (_, e) in
            if let e = e {
                print("eeeeee", e)
                onError?(e.localizedDescription)
                return
            }
            onSuccess()
        }
    }
    static func storage(_ path: String) -> StorageReference {
        return Storage.storage().reference(withPath: path)
    }
    // 画像ゲット
    internal static func getImage(_ ref: StorageReference,
                                  onDone: @escaping (_ image: UIImage) -> Void) {
        ref.getData(maxSize: 1024*1024*3) { (data, e) in
            
            guard let data = data else { return }
            guard let image = UIImage(data: data) else {
                ref.delete(completion: nil)
                onDone(UIImage(named: "noImage_sauna")!)
                return
            }
            onDone(image)
        }
    }
    internal static func getPDF(_ path: String,
                                  onDone: @escaping (PDFDocument) -> Void) {
        storage(path).getData(maxSize: 1024*1024*30) { (data, e) in
            
            guard let data = data, let doc = PDFDocument(data: data) else { return }
            onDone(doc)
        }
    }
    
}
class Decoder {
    
    static func decode<T: Decodable>(_: T.Type, from container: DocumentSnapshot?,
                                     onDone: @escaping (_:T?) -> Void) {
        guard let data = container?.data() else {
            onDone(nil)
            return
        }
        do {
            let objc = try Firestore.Decoder().decode(T.self, from: data)
            onDone(objc)
        } catch let e {
            onDone(nil)
            print("DECODE ERRRRRROR:", e)
        }
    }
    static func decodeAll<T: Decodable>(_: T.Type, from snap: QuerySnapshot?) -> [(objc: T, id: String)] {
        
        var notifications = [(objc: T, id: String)]()
        guard let docs = snap?.documents else {
            return notifications
        }
        for doc in docs {
            Decoder.decode(T.self, from: doc) { objc in
                if let objc = objc {
                    notifications.append((objc: objc, id: doc.documentID))
                }
            }
        }
        return notifications
    }
}

extension Timestamp {
    func toFullString() -> String {
        return dateValue().toFullString()
    }
    func toString(format: DateFormat) -> String {
        return dateValue().toString(format: format)
    }
    func toChildAge() -> String {
        dateValue().toChildAge()
    }
}
extension Date {
    func timestamp() -> Timestamp {
        Timestamp(date: self)
    }
    func toChildAge() -> String {
        let seconds = Date().timeIntervalSince(self)
        let months = Int(CGFloat(seconds)/3600/24/(365/12))
        let year = months / 12
        let months_left = months % 12
        print("toChildAge", self, months, year, months_left)
        if year == 0 { return "\(months_left)ヶ月" }
        else { return "\(year)歳\(months_left)ヶ月" }
    }
}

extension Query {
    
    func getDocuments<T: Decodable>(_: T.Type, onDone: @escaping (QuerySnapshot?, [(objc: T, id: String)] ) -> Void) {
        getDocuments { snap, e in
            onDone(snap, Decoder.decodeAll(T.self, from: snap))
        }
    }
}
extension DocumentReference {
    
    func getDocument<T: Decodable>(_: T.Type, onDone: @escaping (T?) -> Void) {
        getDocument { snap, e in
            Decoder.decode(T.self, from: snap) { data in
                onDone(data)
            }
        }
    }
}
