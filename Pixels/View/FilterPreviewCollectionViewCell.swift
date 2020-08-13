//
//  FilterPreviewCollectionViewCell.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 13/08/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class FilterPreviewCollectionViewCell: UICollectionViewCell {
    
    override var isSelected: Bool {
        didSet{
            filteredImage.layer.borderWidth = isSelected ? 3 : 0
            filterName.textColor = isSelected ? .black : .lightGray
        }
    }
    
    let filteredImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "food")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor.black.cgColor
        return img
    }()
    
    let filterName:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = .lightGray
        l.font = UIFont(name: "Avenir-Medium", size: 14)
        l.text = "Mono"
        l.textAlignment = .center
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(filteredImage)
        addSubview(filterName)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            filteredImage.widthAnchor.constraint(equalToConstant: 100),
            filteredImage.heightAnchor.constraint(equalToConstant: 100),
            filteredImage.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            filteredImage.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterName.topAnchor.constraint(equalTo: filteredImage.bottomAnchor, constant: 10),
            filterName.centerXAnchor.constraint(equalTo: centerXAnchor),
            filterName.leadingAnchor.constraint(equalTo: leadingAnchor),
            filterName.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
