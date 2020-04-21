//
//  ImageCategoryCollectionViewCell.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 21/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ImageCategoryCollectionViewCell: UICollectionViewCell {
    
    var data:CategoryData?{
        didSet{
            manageData()
        }
    }
    
    private let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        return img
    }()
    
    private let opaqueView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor(white: 0 , alpha: 0.5)
        return v
    }()
    
    private let categoryLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .white
        cl.font = UIFont(name: "Times-Bold", size: 23)
        cl.textAlignment = .center
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
    }()
    
    let categoryBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.addTarget(self, action: #selector(categoryPressed), for: .touchUpInside)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(imgView)
        addSubview(opaqueView)
        addSubview(categoryLabel)
        addSubview(categoryBtn)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        imgView.pin(to: self)
        opaqueView.pin(to: self)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            categoryLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            categoryLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            categoryLabel.topAnchor.constraint(equalTo: self.topAnchor)
        ])
        categoryBtn.pin(to: self)
    }
    
    func manageData(){
        guard let data = data else {return}
        categoryLabel.text = data.categoryTitle
        imgView.image = UIImage(named: data.categoryImage)
    }
    
    @objc func categoryPressed(){
        
    }
    
}
