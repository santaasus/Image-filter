//
//  FilterViewController.swift
//  ImageFilter
//
//  Created by Владимир on 05.08.17.
//  Copyright © 2017 com.favorite. All rights reserved.
//

import Foundation
import UIKit
import KVNProgress

class FilterViewController : UIViewController, UICollectionViewDataSource,
                             UICollectionViewDelegate, UIGestureRecognizerDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerImage: UIImageView!

    var rgbItems: [UIImageView] = []
    
    func addObserver() {
        NotificationManager.addObserver(object: self, selector: #selector(saveFilteredImageDelegateFromExtension), notification: .saveImage)
    }
    
    func deleteObserver() {
        NotificationManager.removeObserver(object: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fillHeaderImageFromCache()
        setLeftMenuButton()
        setRightMenuButton()
        fillCollectionView()
        addObserver()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        
        self.navigationController?.navigationBar.isHidden = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        deleteObserver()
    }
    
    func fillCollectionView() {
        rgbItems.append(headerImage)
        rgbItems.append(headerImage)
        rgbItems.append(headerImage)
        rgbItems.append(headerImage)
        rgbItems.append(headerImage)
        rgbItems.append(headerImage)
        
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.reloadData()
    }
    

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return rgbItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! FilterCell
        
        let color = colorTransform(indexCell: indexPath[1])
       
        DispatchQueue.global(qos: .userInteractive).async {
            var image: UIImage? // It's needed for multithreading when cells are redrawing (there is a lot of lags - because it's drawing in main thread)
            
        
            if color != nil {
                image = (self.rgbItems[(indexPath).row].image?.maskWithColor(color: color!,
                                                                            originImage: self.headerImage.image!))!
            } else {
                 image = self.loadOriginalImageFromCache() // color is nill - default state of image
            }
            
            DispatchQueue.main.async {
             
               cell.imageCell.image = image
            }
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell: FilterCell = collectionView.cellForItem(at: indexPath) as! FilterCell
        
        headerImage.image = cell.imageCell.image
    }
    
    func fillHeaderImageFromCache() {
        let decoded  = UserDefaults.standard.object(forKey: "image") as! Data
        let image = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UIImage
        
        headerImage.image = image
        
    }
    
    func colorTransform(indexCell: Int) -> UIColor! {
        var color: UIColor!
        
        switch indexCell {
            case 0: color = UIColor.darkGray; return color
            case 1: color = UIColor.green;    return color
            case 2: color = UIColor.orange;   return color
            case 3: color = UIColor.cyan;     return color
            case 4: color = UIColor.blue;     return color
            
            default: return color // color is nil
        }
        
    }
    
    func loadOriginalImageFromCache() -> UIImage {
        let decoded  = UserDefaults.standard.object(forKey: "image") as! Data
        return (NSKeyedUnarchiver.unarchiveObject(with: decoded) as? UIImage)!
    }
    
    internal func saveFilteredImageDelegateFromExtension() {
        UIImageWriteToSavedPhotosAlbum(headerImage.image!, self, nil, nil)
        showSuccess()
    }
    
    internal func showSuccess() {
        KVNProgress.showSuccess()
    }
}



