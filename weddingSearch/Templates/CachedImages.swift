//
//  CachedImages.swift
//  TeacherMatching
//
//  Created by Tenna on R 3/05/13.
//

import UIKit

class Cached {
    internal static var cachedImage = [(ref: String, image: UIImage)]()
    
    internal static func imageWith(_ ref: String) -> (UIImage)? {
        guard let i = idx(ref) else {
            return nil
        }
        return cachedImage[i].image
    }
    internal static func idx(_ ref: String) -> Int? {
        for i in 0..<cachedImage.count {
            if cachedImage[i].ref == ref { return i }
        }
        return nil
    }
    internal static func addCachedImage(ref: String, image: UIImage) {
        if cachedImage.filter({ $0.ref == ref }).first == nil {
            cachedImage.append((ref: ref, image: image))
        }
        if cachedImage.count > 30 {
            cachedImage.remove(at: 0)
        }
    }
}

class ImageView: UIImageView {
    
    private var imagePath = ""
    
    func loadImageUsingCache(_ path: String?, placeholder: String = "no_image", onDone: (() -> Void)? = nil) {
        image = UIImage(named: placeholder)
        print("loadImageUsingCache")
        guard let path = path else {
            return
        }
        getImage(path, onDone: {})
    }
    func getImage(_ path: String, onDone: (() -> Void)?) {
        print("getImage")
        if let cashed = Cached.imageWith(path) {
            image = cashed
            onDone?()
            return
        }
        imagePath = path
        Ref.getImage(Ref.storage(path)) { image in
            if self.imagePath == path {
                self.image = image
                Cached.addCachedImage(ref: path, image: image)
            }
        }
    }
}
