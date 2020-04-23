//
//  CategoryViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 22/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    var imgs = [String]()
    var query = ""
    var FetchedImages:FetchImageModel?
    var imageList:[ListImageData]?
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 255/255, alpha: 1)
        return cv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView()
        aI.style = .large
        aI.color = .darkGray
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.scrollDirection = .vertical
        collectionView.setCollectionViewLayout(layout, animated: false)
        let customLayout = PinterestLayout()
        collectionView.collectionViewLayout = customLayout
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        setUpConstraints()
        ///Assigning Custom layout
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        setUpNavigationBar()
        activityIndicator.startAnimating()
        FetchImageModel.fetchImages(url: "\(Constants.BASE_URL)/search", query: "\(query)", perPage: "20", page: "1") { (FetchedImages) in
            self.FetchedImages = FetchedImages
            self.getImageArray(FetchedImages)
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func getImageArray(_ data:FetchImageModel){
        var images = [ListImageData]()
        let imgResult = data.photoData
        for i in 0..<imgResult!.count{
            let img = ListImageData(id: imgResult![i].id, height: imgResult![i].height, width: imgResult![i].width, thumbnail: imgResult![i].thumbnail)
            images.append(img)
        }
        if imageList == nil {
            imageList = images
        } else {
            imageList?.append(contentsOf: images)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    
    func setUpNavigationBar(){
        navigationItem.title = "\(query)"
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        self.navigationController!.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: UIFont(name: "Times-Bold", size: 22)!,
            NSAttributedString.Key.foregroundColor: UIColor.black
        ]
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "whiteBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
    }
        
    @objc func backBtn(){
        navigationController?.popViewController(animated: true)
    }
    
    func setUpConstraints(){
        collectionView.pin(to: view)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
}

extension CategoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let imageList = imageList {
            return imageList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.data = imageList![indexPath.row].thumbnail
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
      return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                cell.imgView.transform = .init(scaleX: 0.95, y: 0.95)
                cell.backView.transform = .init(scaleX: 0.95, y: 0.95)
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                cell.imgView.transform = .identity
                cell.backView.transform = .identity
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImagePreviewViewController()
        vc.imageId = imageList![indexPath.row].id
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CategoryViewController: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    if let imageList = imageList {
        let cellWidth = (collectionView.frame.width - 44) / 2
        let imageRatio = CGFloat(imageList[indexPath.row].width) / CGFloat(imageList[indexPath.row].height)
        return CGFloat(cellWidth / imageRatio)
    }
    return CGFloat()
  }
}

