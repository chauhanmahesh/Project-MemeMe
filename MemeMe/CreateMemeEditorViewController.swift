//
//  ViewController.swift
//  MemeMe
//
//  Created by Mahesh Chauhan on 2/7/19.
//  Copyright © 2019 Mahesh Chauhan. All rights reserved.
//

import UIKit

class CreateMemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {

    @IBOutlet var cameraPick: UIBarButtonItem!
    @IBOutlet var photoLibraryPick: UIBarButtonItem!
    @IBOutlet var topText: UITextField!
    @IBOutlet var bottomText: UITextField!
    @IBOutlet var memeImage: UIImageView!
    @IBOutlet var navBar: UINavigationBar!
    @IBOutlet var bottomToolbar: UIToolbar!
    @IBOutlet var shareMeme: UIBarButtonItem!
    
    // MARK: Constants
    private let topTextDefaultValue = "TOP"
    private let bottomTextDefaultValue = "BOTTOM"
    
    @IBAction func pickImageFromAlbum(_ sender: Any) {
        openImagePicker(source: .photoLibrary)
    }
    
    @IBAction func pickImageFromCamera(_ sender: Any) {
        openImagePicker(source: .camera)
    }
    
    @IBAction func shareMeme(_ sender: Any) {
        // Let's get the memeImage to be shared first.
        let meme = getMeme()
        let activityController = UIActivityViewController(activityItems: [meme.memeImage], applicationActivities: nil)
        activityController.completionWithItemsHandler = { (activityType, completed:Bool, returnedItems:[Any]?, error: Error?) in
            if completed {
                // So meme is shared properly. So let's save the meme in the gallery.
                self.saveMemeImage(memeImage: meme.memeImage)
            }
        }
        present(activityController, animated: true, completion: nil)
    }
    
    @IBAction func cancelMeme(_ sender: Any) {
        // Let's reset the meme.
        resetMeme()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Also let's subscribe to keyboard notifications.
        subscribeToKeyboardNotifications()
        // Let's set the alignment for Top text field.
        topText.textAlignment = .center
        // Let's set the alignment for Bottom text field.
        bottomText.textAlignment = .center
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        // Let's unsubscribe from keyboard notifications.
        unsubscribeToKeyboardNotifications()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Let's check if camera is available or not and disable the control if required.
        cameraPick.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        // Let's setup top text field style
        setupTextFieldStyle(textField: topText)
        // Let's setup bottom text field style
        setupTextFieldStyle(textField: bottomText)
        // Also lets disable the share initially.
        shareMeme.isEnabled = false
    }
    
    // MARK: Custom Methods
    private func openImagePicker(source: UIImagePickerController.SourceType) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = source
        present(pickerController, animated: true, completion: nil)
    }
    
    private func setupTextFieldStyle(textField: UITextField) {
        // Let's prepare the text attributes.
        let memeTextAttributes: [NSAttributedString.Key: Any] = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSAttributedString.Key.strokeWidth:  2,
        ]
        textField.defaultTextAttributes = memeTextAttributes
        
        // Let's set delegates for textfields.
        textField.delegate = self
    }
    
    private func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    private func saveMemeImage(memeImage: UIImage) {
        UIImageWriteToSavedPhotosAlbum(memeImage, self, nil, nil)
    }
    
    private func getMeme() -> Meme {
        return Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: memeImage.image!, memeImage: generateMemedImage())
    }
    
    private func generateMemedImage() -> UIImage {
        // To generate the memeImage, we will save the whole screen view as an image. However, we need to make sure our memeImage doesn't have toolbars in it.
        // So let's hide the toolbars before generating the meme image.
        hideToolbars()
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Now as meme image is already generated, let's show the toolbars.
        showToolbars()
        return memedImage
    }
    
    private func hideToolbars() {
        navBar.isHidden = true
        bottomToolbar.isHidden = true
    }
    
    private func showToolbars() {
        navBar.isHidden = false
        bottomToolbar.isHidden = false
    }
    
    private func resetMeme() {
        // Let's reset to the initial view so that new meme can be created.
        memeImage.image = nil
        shareMeme.isEnabled = false
        topText.text = ""
        bottomText.text = ""
    }
    
    // MARK: Keyboard Notifications callback.
    @objc func keyboardWillShow(_ notification: Notification) {
        // Let's shift the view up only if bottom text is editing.
        if bottomText.isEditing {
            view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        view.frame.origin.y = 0
    }
    
    // MARK: Delegates.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            memeImage.image = image
            // Also as image is picked, let's enable the share option now.
            shareMeme.isEnabled = true
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (textField == topText && textField.text == topTextDefaultValue) || (textField == bottomText && textField.text == bottomTextDefaultValue) {
            textField.text = ""
        }
    }

}

