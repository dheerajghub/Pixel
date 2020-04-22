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
    
    let cellCardView:UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()
    
    let imgView: UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.cornerRadius = 5
        img.isUserInteractionEnabled = true
        return img
    }()
    
    let opaqueView: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 5
        v.backgroundColor = UIColor(white: 0 , alpha: 0.5)
        return v
    }()
    
    let categoryLabel: UILabel = {
        let cl = UILabel()
        cl.textColor = .white
        cl.font = UIFont(name: "Times-Bold", size: 23)
        cl.textAlignment = .center
        cl.translatesAutoresizingMaskIntoConstraints = false
        return cl
    }()
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(cellCardView)
        cellCardView.addSubview(imgView)
        cellCardView.addSubview(opaqueView)
        cellCardView.addSubview(categoryLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        cellCardView.pin(to: self)
        imgView.pin(to: cellCardView)
        opaqueView.pin(to: cellCardView)
        NSLayoutConstraint.activate([
            categoryLabel.leadingAnchor.constraint(equalTo: cellCardView.leadingAnchor, constant: 15),
            categoryLabel.trailingAnchor.constraint(equalTo: cellCardView.trailingAnchor, constant: -15),
            categoryLabel.bottomAnchor.constraint(equalTo: cellCardView.bottomAnchor),
            categoryLabel.topAnchor.constraint(equalTo: cellCardView.topAnchor)
        ])
    }
    
    func manageData(){
        guard let data = data else {return}
        categoryLabel.text = data.categoryTitle
        imgView.image = UIImage(named: data.categoryImage)
    }
    
}
