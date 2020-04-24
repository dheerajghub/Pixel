//
//  VideoCollectionViewCell.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 24/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class VideoCollectionViewCell: UICollectionViewCell {
    
    var data:ListVideoData?{
        didSet{
            manageData()
        }
    }
    
    let imgView: CustomImageView = {
        let img = CustomImageView()
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        img.layer.borderColor = UIColor(red: 230/255, green: 230/255, blue:230/255, alpha: 1).cgColor
        img.layer.borderWidth = 0.5
        img.layer.cornerRadius = 8
        return img
    }()
    
    let backView: UIView = {
        let v = UIView()
        v.backgroundColor = .lightGray
        v.layer.cornerRadius = 8
        v.alpha = 0.5
        return v
    }()
    
    let overView: UIView = {
        let v = UIView()
        v.backgroundColor = .black
        v.layer.cornerRadius = 8
        v.alpha = 0.5
        return v
    }()
    
    let playBtnView: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "play-button")
        img.translatesAutoresizingMaskIntoConstraints = false
        return img
    }()
    
    let durationLabel: UILabel = {
        let l = UILabel()
        l.text = "0:13"
        l.font = UIFont.systemFont(ofSize: 14)
        l.textColor = .white
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(backView)
        addSubview(imgView)
        addSubview(overView)
        addSubview(playBtnView)
        addSubview(durationLabel)
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpConstraints(){
        imgView.pin(to: self)
        backView.pin(to: self)
        overView.pin(to: self)
        NSLayoutConstraint.activate([
            playBtnView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            playBtnView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            playBtnView.heightAnchor.constraint(equalToConstant: 50),
            playBtnView.widthAnchor.constraint(equalToConstant: 50),
            
            durationLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            durationLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10)
        ])
    }
    
    func manageData(){
        guard let data = data else {return}
        imgView.cacheImageWithLoader(withURL: data.thumbnail, view: backView)
        guard let interval = data.duration else { return }
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        let formattedString = formatter.string(from: TimeInterval(interval))!
        durationLabel.text = formattedString
    }
    
}
