//
//  EditImageViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 13/08/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import CoreImage

struct filterEffect{
    var filterName:String!
    var filterCIName:String!
}

class EditImageViewController: UIViewController {

    var selectedImg: UIImage!
    var originalImg: UIImage!
    var filters:[filterEffect]!
    var context: CIContext!
    var currentFilter: CIFilter!
    var selectedIndex:Int = 0
    var changesMade:Bool!
   
    let imageView:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let filtersView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .black
        return v
    }()
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsHorizontalScrollIndicator = false
        cv.register(FilterPreviewCollectionViewCell.self, forCellWithReuseIdentifier: "FilterPreviewCollectionViewCell")
        cv.backgroundColor = .clear
        cv.setCollectionViewLayout(layout, animated: false)
        cv.delegate = self
        cv.dataSource = self
        cv.delaysContentTouches = false
        cv.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(imageView)
        view.addSubview(filtersView)
        filtersView.addSubview(collectionView)
        view.backgroundColor = .white
        setUpConstraints()
        setUpNavigationBar()
        
        context = CIContext()
        
        filters = [
            filterEffect(filterName: "Monochrome", filterCIName: "CIColorMonochrome"),
            filterEffect(filterName: "Poster", filterCIName: "CIColorPosterize"),
            filterEffect(filterName: "False", filterCIName: "CIFalseColor"),
            filterEffect(filterName: "Chrome", filterCIName: "CIPhotoEffectChrome"),
            filterEffect(filterName: "Fade", filterCIName: "CIPhotoEffectFade"),
            filterEffect(filterName: "Instant", filterCIName: "CIPhotoEffectInstant"),
            filterEffect(filterName: "Mono", filterCIName: "CIPhotoEffectMono"),
            filterEffect(filterName: "Noir", filterCIName: "CIPhotoEffectNoir"),
            filterEffect(filterName: "Process", filterCIName: "CIPhotoEffectProcess"),
            filterEffect(filterName: "Tonal", filterCIName: "CIPhotoEffectTonal"),
            filterEffect(filterName: "Transfer", filterCIName: "CIPhotoEffectTransfer"),
            filterEffect(filterName: "Sepia Tone", filterCIName: "CISepiaTone")
        ]
        
        changesMade = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let index = IndexPath(row: 0, section: 0)
        imageView.image = originalImg
        collectionView.selectItem(at: index, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func setUpNavigationBar(){
        navigationItem.title = ""
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.isTranslucent = true
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("CANCEL", for: .normal)
        backButton.titleLabel?.font = UIFont(name:"Avenir-Medium", size: 16)
        backButton.setTitleColor(.black, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.titleLabel?.font = UIFont(name:"Avenir-Medium", size: 16)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.addTarget(self, action: #selector(saveButtonPressed), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = saveButton
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
    }
    
    @objc func backBtn(){
        if changesMade {
            alertSheet()
        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func saveButtonPressed(){
        guard let image = self.imageView.image else { return }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(self.image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: filtersView.topAnchor),
            
            filtersView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filtersView.heightAnchor.constraint(equalToConstant: 200),
            
            collectionView.leadingAnchor.constraint(equalTo: filtersView.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: filtersView.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: filtersView.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: filtersView.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setImageFilter(_ filterName:String , _ selectedImage:UIImage) -> UIImage{
        let currImg = CIImage(image: selectedImage)
        currentFilter = CIFilter(name:"\(filterName)")
        currentFilter.setValue(currImg, forKey: kCIInputImageKey)
        guard let image = currentFilter.outputImage else { return originalImg }
        
        if let cgimg = context.createCGImage(image, from: image.extent) {
            let processedImage = UIImage(cgImage: cgimg , scale:self.originalImg.scale ,orientation:self.selectedImg.imageOrientation)
            return processedImage
        }
        return UIImage()
    }
    
    func alertSheet(){
        let optionMenu = UIAlertController(title: "Are you sure?", message: "If you go back now, your image edit will be discarded", preferredStyle: .alert)
        let Discard = UIAlertAction(title: "Cancel", style: .destructive , handler: {
            (alert: UIAlertAction!) -> Void in
            self.dismiss(animated: true, completion: nil)
        })
        
        let cancelAction = UIAlertAction(title: "Stay", style: .cancel)
        optionMenu.addAction(Discard)
        optionMenu.addAction(cancelAction)
        
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Error while saving!", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default , handler: {
                (UIAlertAction) -> Void in
                self.dismiss(animated: true, completion: nil)
            }))
            present(ac, animated: true)
            
        }
    }
    
}

extension EditImageViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filters.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FilterPreviewCollectionViewCell", for: indexPath) as! FilterPreviewCollectionViewCell
        if indexPath.row > 0 {
            cell.filteredImage.image = setImageFilter(filters[indexPath.row - 1].filterCIName , resizeImage(image: selectedImg, targetSize: CGSize(width: 100, height: 100)))
            cell.filterName.text = filters[indexPath.row - 1].filterName
        } else {
            cell.filteredImage.image = originalImg
            cell.filterName.text = "Normal"
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:110, height: 140)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            let cell = collectionView.cellForItem(at: indexPath) as! FilterPreviewCollectionViewCell
            cell.filteredImage.transform = .init(scaleX: 0.95, y: 0.95)
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseIn, animations: {
            let cell = collectionView.cellForItem(at: indexPath) as! FilterPreviewCollectionViewCell
            cell.filteredImage.transform = .identity
        }, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex != indexPath.row {
            if indexPath.row > 0 {
                imageView.image = setImageFilter(filters[indexPath.row - 1].filterCIName, selectedImg)
                changesMade = true
            } else {
                imageView.image = originalImg
                changesMade = false
            }
            
        }
        selectedIndex = indexPath.row
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
}
