//
//  ImageCollectionViewCell.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 21/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var data:String?{
        didSet{
            manageData()
        }
    }
    
    let imgView: CustomImageView = {
        let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 8
        return img
    }()
    
    let backView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.alpha = 0.5
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(imgView)
        imgView.pin(to: self)
        backView.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func manageData(){
        guard let data = data else {return}
        imgView.cacheImageWithLoader(withURL: data, view: backView)
    }
    
}
