//
//  ViewController.swift
//  ImageFilter
//
//  Created by Владимир on 05.08.17.
//  Copyright © 2017 com.favorite. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

//    var viewButton: UIButton!
    var imagePicker: UIImagePickerController!
    var chooseDialogState: ChooseImageState?
    var stateButtonPressed: StateButtonPressed?
    
    enum ChooseImageState: Int {
        case stateUndefined = 0
        case stateCamera = 1
        case stateGallery = 2
    }
    
    enum StateButtonPressed: Int {
        case pressed = 0
        case success = 1
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        chooseDialogState = ChooseImageState.stateUndefined
        takePhotoCustomButton()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }

   
    func takePhotoCustomButton() {
        let view = UIButton(frame: CGRect(x: 0,
                                            y: 0,
                                            width: 110,
                                            height: 110))
        view.backgroundColor = UIColor.blue
        view.layer.cornerRadius = view.bounds.size.width * 0.5
        view.setTitle("Push me", for: .normal)
        view.setTitleColor(UIColor.white, for: .normal)
        view.center = self.view.center

        self.view.addSubview(view)
        
        tapButtonRecognizer(viewButton: view)
    }
    
    
    func tapButtonRecognizer(viewButton : UIButton) {
        viewButton.addTarget(self, action: #selector(handleTakeOrChoosePhoto), for: .touchUpInside)
    }

    func handleTakeOrChoosePhoto() {
        stateButtonPressed = StateButtonPressed.pressed
        showChooseAlert()
        handleButtonPressedAnimation(x: 0.7, y: 0.7)
        
        changeButtonColor()
    }
    
    func changeButtonColor() {
        let button = self.view.subviews[2]
        
        guard stateButtonPressed != StateButtonPressed.pressed else {
            button.backgroundColor = UIColor.red
            return
        }
        
        button.backgroundColor = UIColor.blue
        return
    }
    
    func handleButtonPressedAnimation(x: Float, y: Float) {
        UIView.animate(withDuration: 0.25, delay: 0, options: UIViewAnimationOptions.curveEaseInOut,
                       animations: {
                        self.view.subviews[2].transform = CGAffineTransform(scaleX: CGFloat(x), y: CGFloat(y))
                        
                        }, completion:nil)
    }
    
    
    func changeBehaviorButton() {
        self.stateButtonPressed = StateButtonPressed.success
        self.handleButtonPressedAnimation(x: 1.0, y: 1.0)
        self.changeButtonColor()
    }
    
    func actionTakeOrChoosePhoto(isCamera: Bool) {
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self 
        imagePicker.sourceType = isCamera ? .camera : .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
  
    
    func showChooseAlert() {
        
        let alert = UIAlertController(title: "Choose an action",
                                      message: nil, preferredStyle: .actionSheet)
        
        
        alert.addAction(UIAlertAction(title: "Camera",
                                      style: .default,
                                      handler:{(UIAlertAction) in
                                        self.chooseDialogState = ChooseImageState.stateCamera
                                        self.actionTakeOrChoosePhoto(isCamera: true)
                                        self.changeBehaviorButton()
                                        
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery",
                                      style: .default,
                                      handler:{ (UIAlertAction) in
                                       self.chooseDialogState = ChooseImageState.stateGallery
                                       self.actionTakeOrChoosePhoto(isCamera: false)
                                        self.changeBehaviorButton()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler:{ (UIAlertAction) in
                                        self.changeBehaviorButton()
                        
        }))
        
       
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        
        if chooseDialogState == ChooseImageState.stateCamera {
            UIImageWriteToSavedPhotosAlbum(image, self, nil, nil)
        }
        
        let encodedData = NSKeyedArchiver.archivedData(withRootObject: image)
        UserDefaults.standard.set(encodedData, forKey: "image")
        presentFilterViewController(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func presentFilterViewController(image: UIImage!) {
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Filter") as? FilterViewController {
            
//            vc.headerImage.image = image
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}

