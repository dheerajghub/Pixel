//
//  OnboardingCollectionViewCell.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 20/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

struct OnboardingData{
    var image:String!
    var title:String!
    var subtitle:String!
}

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    var data:OnboardingData?{
        didSet{
            manageData()
        }
    }
    
    private let graphicImage: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    private let titleLabel:UILabel = {
        let title = UILabel()
        title.font = UIFont(name: "Times-Bold", size: 35)
        title.numberOfLines = 0
        title.textAlignment = .center
        return title
    }()
    
    private let subtitleLabel:UILabel = {
        let subtitle = UILabel()
        subtitle.font = UIFont(name: "Times", size: 20)
        subtitle.numberOfLines = 0
        subtitle.textAlignment = .center
        subtitle.textColor = .lightGray
        return subtitle
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(graphicImage)
        addSubview(titleLabel)
        addSubview(subtitleLabel)
        setUpviews()
        setUpConstraints()
    }
    
    func setUpviews(){
    }
    
    func setUpConstraints(){
        
        //Graphic Image
        addConstraintsWithFormat(format: "V:|-80-[v0(370)]", views: graphicImage)
        addConstraintsWithFormat(format: "H:|-30-[v0]-30-|", views: graphicImage)
        graphicImage.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //Title Label
        titleLabel.topAnchor.constraint(equalTo: graphicImage.bottomAnchor, constant: 20).isActive = true
        addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
        //Subtitle Label
        subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 10).isActive = true
        addConstraintsWithFormat(format: "H:|-50-[v0]-50-|", views: subtitleLabel)
        subtitleLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        
    }
    
    func manageData(){
        guard let data = data else {return}
        graphicImage.image = UIImage(named: data.image)
        titleLabel.text = data.title
        subtitleLabel.text = data.subtitle
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
