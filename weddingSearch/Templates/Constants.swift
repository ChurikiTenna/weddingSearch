//
//  Constants.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/13.
//

import UIKit
import NotificationCenter

class Constants {
    static let notifyBefore = 10
    static let starsCount = 5
}

class SizeValidator: NSObject {
    
    /// 許容できる画像の最大容量
    internal static let maxImageFileSize: UInt = 1000 * 1000 * 30
    /// 許容できる動画の最大容量
    internal static let maxMovieFileSize: UInt = 1000 * 1000 * 100
    
    enum MediaType {
        case image
        case movie
    }
    /// 可能な画像かどうか判定する
    internal static func ok(fileUrl: URL, type: MediaType) -> Bool {
        var fileAttribute: [FileAttributeKey: Any]!
        do {
            fileAttribute = try FileManager.default.attributesOfItem(atPath: fileUrl.path)
        } catch {
          print("Error: \(error)")
        }
        let fileSize = fileAttribute[.size] as! UInt64
        print("fileSize", fileSize, maxMovieFileSize)
        return fileSize <= (type == .image ? maxImageFileSize : maxMovieFileSize)
    }
}
