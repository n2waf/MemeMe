//
//  ViewController.swift
//  MemeMe
//
//  Created by nF ™ on 12/05/2020.
//  Copyright © 2020 nF ™. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate , UITextFieldDelegate{

    
    // MARK: OUTLETS
    @IBOutlet weak var tab: UIToolbar!
    @IBOutlet weak var PickerImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var bottomText: UITextField!
    @IBOutlet weak var cancel: UIBarButtonItem!
    @IBOutlet weak var share: UIBarButtonItem!
    @IBOutlet weak var naviBar: UINavigationBar!
    
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white ,
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth:  -2
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }

    override func viewWillAppear(_ animated: Bool) {
        
        // MARK: SETUP TEXTFIELDS
        topText.defaultTextAttributes = memeTextAttributes
        bottomText.defaultTextAttributes = memeTextAttributes
        topText.textAlignment = .center
        bottomText.textAlignment = .center
        topText.delegate = self
        bottomText.delegate = self
        
        // MARK: CHECK IF CAMERA AVAILABLE
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        
        // MARK: SUBSCRIBE KEYBOARD NOTFICATIONS
        subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeFromKeyboardNotifications()
    }
    
    // MARK: ACTIONS
    @IBAction func PickAnImage(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func PickAnImageFromCamera(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func shareButton(_ sender: Any) {
        save()
    }
    @IBAction func cancelButton(_ sender: Any) {
        PickerImageView.image = nil
        topText.text = "TOP"
        bottomText.text = "BOTTOM"
    }
    
    
    // MARK: IMAGE PICKER HANDLE
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
     {
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerOriginalImage")] as? UIImage {
            PickerImageView.image = image
            PickerImageView.contentMode = .scaleAspectFill
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController)
    {
        print("User Cancel")
        dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.text = ""
    }
    
    
    // MARK: NOTIFICATIONS FUNCS
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboadWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self,name:UIResponder.keyboardWillHideNotification,object: nil)
    }
    
    // MARK: KEYBOARD CONTROL
    @objc func keyboardWillShow(_ notification:Notification) {
        
        view.frame.origin.y = -getKeyboardHeight(notification)
    }
    
    @objc func keyboadWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    // MARK: IMAGE SHARING
    func save(){
        // Create the meme
        if PickerImageView.image != nil {
            let memedImage = generateMemedImage()
            let meme = Meme(topText: topText.text!, bottomText: bottomText.text!, originalImage: PickerImageView.image!, memedImage: memedImage)
            let Activity = UIActivityViewController(activityItems: [meme.memedImage!], applicationActivities: nil)
            DispatchQueue.main.async {
                self.present(Activity,animated: true)
            }
        }

    }
    
    
    func generateMemedImage() -> UIImage {
        
        // Render view to an image
        tab.isHidden = true
        naviBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        tab.isHidden = false
        naviBar.isHidden = false
        return memedImage
    }
    
}

