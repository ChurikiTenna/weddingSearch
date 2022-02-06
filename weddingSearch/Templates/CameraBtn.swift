//
//  CameraBtn.swift
//  SOLOZ
//
//  Created by 中力天和 on 2021/10/15.
//

import UIKit

protocol CameraBtnDelegate: AnyObject {
    func imageUpdated(image: UIImage, at idx: Int)
    func imageDeleted(at idx: Int)
}
// 投稿写真選択ボタン
class CameraBtn: ImageView {
    
    internal var back: UIButton!
    internal var imageChanged = false
    internal weak var delegate: CameraBtnDelegate!
    
    convenience init(_ f: CGRect, tag: Int, delegate: CameraBtnDelegate, to view: UIView) {
        self.init(frame: f)
        back = UIButton(frame, color: .white, to: view)
        back.setImage(UIImage(systemName: "camera.fill"), for: .normal)
        back.tintColor = .superPaleGray
        back.round(10)
        self.tag = tag
        self.delegate = delegate
        round(10)
        isUserInteractionEnabled = true
        contentMode = .scaleAspectFill
        clipsToBounds = true
        view.addSubview(self)
        let tap = UITapGestureRecognizer(target: self, action: #selector(showImagePicker))
        addGestureRecognizer(tap)
    }
    func circle() {
        round(0.5)
        back.round(0.5)
    }
    
    @objc private func showImagePicker() {
        
        if image != nil {
            image = nil
            imageChanged = true
            delegate.imageDeleted(at: tag)
        } else {
            let c = UIImagePickerController()
            c.sourceType = .photoLibrary
            c.popoverPresentationController?.sourceView = self
            c.popoverPresentationController?.sourceRect = CGRect(x: self.w/2, y: self.h/2, w: 10, h: 10)
            c.delegate = self
            parentViewController.present(c, animated: true)
        }
    }
}
extension CameraBtn: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        // 画像の容量チェック
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else { return }
        image = originalImage
        imageChanged = true
        delegate.imageUpdated(image: originalImage, at: tag)
        picker.dismiss(animated: true, completion: nil )
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
