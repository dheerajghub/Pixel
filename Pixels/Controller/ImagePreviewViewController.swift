//
//  ImagePreviewViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 21/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ImagePreviewViewController: UIViewController, UIScrollViewDelegate {

    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.showsVerticalScrollIndicator = false
        sv.showsHorizontalScrollIndicator = false
        sv.contentInsetAdjustmentBehavior = .never
        return sv
    }()
    
    let imageView: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.image = UIImage(named: "sports")
        imgView.clipsToBounds = true
        return imgView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        setUpContraints()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar(){
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
    }
    
    func setUpContraints(){
        scrollView.pin(to: view)
        imageView.pin(to: scrollView)
    }
    
    func scrollViewDidZoom(scrollView: UIScrollView) {

        if scrollView.zoomScale > 1 {

            if let image = imageView.image {

                let ratioW = imageView.frame.width / image.size.width
                let ratioH = imageView.frame.height / image.size.height

                let ratio = ratioW < ratioH ? ratioW:ratioH

                let newWidth = image.size.width*ratio
                let newHeight = image.size.height*ratio

                let left = 0.5 * (newWidth * scrollView.zoomScale > imageView.frame.width ? (newWidth - imageView.frame.width) : (scrollView.frame.width - scrollView.contentSize.width))
                let top = 0.5 * (newHeight * scrollView.zoomScale > imageView.frame.height ? (newHeight - imageView.frame.height) : (scrollView.frame.height - scrollView.contentSize.height))

                scrollView.contentInset = UIEdgeInsets(top: top, left: left, bottom: top, right: left)
            }
        } else {
            scrollView.contentInset = UIEdgeInsets.zero
        }
    }

}
