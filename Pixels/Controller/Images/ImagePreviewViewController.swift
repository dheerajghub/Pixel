//
//  ImagePreviewViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 21/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController{

    var imageId = 0
    var imageForPreview:FetchImageDetailModel?
    
    let imageView: CustomImageView = {
        let imgView = CustomImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        return imgView
    }()
    
    let backView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0.5
        return v
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView()
        aI.style = .large
        aI.color = .white
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(backView)
        view.addSubview(imageView)
        view.addSubview(activityIndicator)
        setUpContraints()
        setUpNavigationBar()
        activityIndicator.startAnimating()
        FetchImageDetailModel.fetchImages(url: "\(Constants.BASE_URL)/photos", id: "\(imageId)") { (imageForPreview) in
            self.imageForPreview = imageForPreview
            self.imageView.cacheImageWithLoader(withURL: imageForPreview.imageUrl, view: self.backView)
            self.view.reloadInputViews()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        navigationController?.navigationBar.isHidden = false
        tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    func setUpNavigationBar(){
        navigationItem.title = ""
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "blackBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
        let editButton = UIButton(type: .system)
        editButton.setImage(UIImage(named: "edit")?.withRenderingMode(.alwaysOriginal), for: .normal)
        editButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: editButton)
        editButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = editButton
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func backBtn(){
        navigationController?.popViewController(animated: true)
    }
    
    @objc func editButtonPressed(){
        let VC = EditImageViewController()
        VC.selectedImg = self.imageView.image
        VC.originalImg = self.imageView.image
        let navVC = UINavigationController(rootViewController: VC)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    func setUpContraints(){
        backView.pin(to: view)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}
