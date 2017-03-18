//
//  ViewController.swift
//  PicturePickerTest
//
//  Created by Kirill Kudymov on 2017-03-03.
//  Copyright © 2017 Kirill Kudymov. All rights reserved.
//

import UIKit

class CreateMemeViewController: UIViewController, UINavigationControllerDelegate {

    // MARK: - Properties
    
    var keyboardIsUp = false
    
    // MARK: - Outlets
    
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareMemeButton: UIBarButtonItem!
    @IBOutlet weak var takePhotoButton: UIBarButtonItem!
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sign up for keyboard notification
        subscribeToKeyboardNotifications()

        // Disable camera button if camera is not available on the device
        takePhotoButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // Configure attributes for text fields
        configTextField(topTextField)
        configTextField(bottomTextField)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Disable share button untill a picture has been chosen
        if memeImageView.image == nil {
            shareMemeButton.isEnabled = false
        } else {
            shareMemeButton.isEnabled = true
        }
    }
    

    // MARK: - Notifications
    
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: .UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    
    // MARK: - Keyboard Mangement
    
    func keyboardWillShow(_ notification: Notification) {
        
        // Need to check if keeboard on the screen because when a user
        // rotates the device keyboardWillShow comes without keyboardWillHide
        if !keyboardIsUp {
            view.frame.origin.y -= getKeyboardHeight(notification)
            keyboardIsUp = true
        }
    }
    
    func keyboardWillHide(_ notification: Notification) {
        
        if keyboardIsUp {
            view.frame.origin.y += getKeyboardHeight(notification)
            keyboardIsUp = false
        }
    }
    
    func getKeyboardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        var keyboardHeight: CGFloat = 0
        
        // Move view up only if user edits bottom text field
        if bottomTextField.isFirstResponder {
            let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
            keyboardHeight = keyboardSize.cgRectValue.height
        }
        
        return keyboardHeight
    }

    
    // MARK: - text field configuration
    
    func configTextField(_ textField: UITextField) {
        
        let memeTextAttributes: [String:Any] = [
            NSStrokeColorAttributeName: UIColor.black,
            NSForegroundColorAttributeName: UIColor.white,
            NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
            NSStrokeWidthAttributeName: -3.0,
            ]

        textField.delegate = self
        textField.backgroundColor = UIColor.clear
        textField.defaultTextAttributes = memeTextAttributes
        textField.textAlignment = .center

    }
    
    // MARK: - Image Management
    
    func save(memeImage: UIImage) {
        
        let date = NSDate()
        // Create Meme
        let meme = Meme(topTextFieldText: topTextField.text, bottomTextFieldText: bottomTextField.text, originalImage: memeImageView.image, memeImage: memeImage, dateCreated: date)
        
        // Get access to shared model
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        // Write meme to the shared model
        appDelegate.memes.append(meme)
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func generateMemeImage() -> UIImage {
        
        // Create Image Context with the size of memeImageView
        UIGraphicsBeginImageContext(memeImageView.frame.size)
        
        // Find origin of memeImageView in window coordinates
        let memeImageViewOrigin = memeImageView.convert(view.frame.origin, from: nil)
        
        // Draw view hierarchy from memeImageView into the context
        view.drawHierarchy(in: CGRect(x: memeImageViewOrigin.x, y: memeImageViewOrigin.y, width: view.bounds.size.width, height: view.bounds.size.height), afterScreenUpdates: true)
        
        let memeImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        return memeImage
    }
    

    // MARK: - Actions
    
    @IBAction func takePhoto(_ sender: UIBarButtonItem) {
        
        // Create and set up UIImagePickerController
        let pickImageViewController = UIImagePickerController()
        pickImageViewController.delegate = self
        pickImageViewController.allowsEditing = true
        
        // tag = 0 - camera button; tag = 1 - album button
        switch sender.tag {
        case 0:
            pickImageViewController.sourceType = .camera
        case 1:
            pickImageViewController.sourceType = .photoLibrary
        default:
            print("Unrecognized sender tag")
        }
        
        present(pickImageViewController, animated: true, completion: nil)

    }
    
    @IBAction func shareMeme(_ sender: Any) {
        
        let memeImage = generateMemeImage()
        let activityViewController = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = {
            _ in
            self.save(memeImage: memeImage)
        }
        present(activityViewController, animated: true, completion: nil)
        
    }

    @IBAction func cancel(_ sender: Any) {
        
        // Clear and reset entire interface
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memeImageView.image = nil
        shareMemeButton.isEnabled = false
        dismiss(animated: true, completion: nil)
    }
    
    
    // MARK: - Deinitializer
    
    deinit {
        unsubscribeFromKeyboardNotifications()
    }
    
}

    // MARK: - Image Picker Controller Extension

extension CreateMemeViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info["UIImagePickerControllerEditedImage"] as? UIImage {
            memeImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}


    // MARK: - Text Field Delegate Extension

extension CreateMemeViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let text = textField.text {
            if text == "TOP" || text == "BOTTOM" {
                textField.text = ""
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}

