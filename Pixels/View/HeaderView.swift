//
//  HeaderView.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 21/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

struct CategoryData {
    var categoryTitle:String!
    var categoryImage:String!
}

protocol HeaderActionsProtocol {
    func didSearchBarTapped()
    func categoryTapped(_ category:String)
}

class HeaderView:UIView {
    
    var categoryData = [CategoryData]()
    var delegate:HeaderActionsProtocol?
    
    let searchBarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 5
        view.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchImage: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "search")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let searchLabel: UILabel = {
        let sL = UILabel()
        sL.text = "Search"
        sL.font = UIFont(name: "Times", size: 18)
        sL.textColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
        return sL
    }()
    
    let searchButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(searchBar), for: .touchUpInside)
        return btn
    }()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let seperatorView: UIView = {
        let v = UIView()
        v.backgroundColor = UIColor.lightGray
        v.alpha = 0.7
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ImageCategoryCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCategoryCollectionViewCell")
        collectionView.delaysContentTouches = false
        addSubview(searchBarView)
        searchBarView.addSubview(searchImage)
        searchBarView.addSubview(searchLabel)
        searchBarView.addSubview(searchButton)
        addSubview(collectionView)
        addSubview(seperatorView)
        setUpConstraints()
        
        categoryData = [
            CategoryData(categoryTitle: "Sports", categoryImage: "sports"),
            CategoryData(categoryTitle: "Fashion", categoryImage: "fashion"),
            CategoryData(categoryTitle: "Music", categoryImage: "music"),
            CategoryData(categoryTitle: "Nature", categoryImage: "nature"),
            CategoryData(categoryTitle: "Art", categoryImage: "art"),
            CategoryData(categoryTitle: "Architecture", categoryImage: "architecture"),
            CategoryData(categoryTitle: "Food", categoryImage: "food"),
            CategoryData(categoryTitle: "Travel", categoryImage: "travel")
        ]
    }
    
    func setUpConstraints(){
        addConstraintsWithFormat(format: "H:|-17-[v0]-17-|", views: searchBarView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: seperatorView)
        addConstraintsWithFormat(format: "V:|-17-[v0(45)][v1][v2(0.5)]|", views: searchBarView, collectionView, seperatorView)
        
        addConstraintsWithFormat(format: "H:|-15-[v0(20)]-10-[v1]-15-|", views: searchImage, searchLabel)
        addConstraintsWithFormat(format: "V:[v0(20)]", views: searchImage)
        searchImage.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor).isActive = true
        searchLabel.centerYAnchor.constraint(equalTo: searchBarView.centerYAnchor).isActive = true
        
        NSLayoutConstraint.activate([
            searchButton.leadingAnchor.constraint(equalTo: searchBarView.leadingAnchor),
            searchButton.trailingAnchor.constraint(equalTo: searchBarView.trailingAnchor),
            searchButton.topAnchor.constraint(equalTo: searchBarView.topAnchor),
            searchButton.bottomAnchor.constraint(equalTo: searchBarView.bottomAnchor)
        ])
    }
    
    @objc func searchBar(){
        delegate?.didSearchBarTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension HeaderView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryData.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCategoryCollectionViewCell", for: indexPath) as! ImageCategoryCollectionViewCell
        cell.data = categoryData[indexPath.row]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets(top: 17, left: 17, bottom: 17, right: 17)
        let font = UIFont(name: "Times-Bold", size: 23)
        let width = categoryData[indexPath.row].categoryTitle.width(withConstrainedHeight: 60, font: font!)
        return CGSize(width: width + 30, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCategoryCollectionViewCell{
                cell.cellCardView.transform = .init(scaleX: 0.90, y: 0.90)
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCategoryCollectionViewCell{
                cell.cellCardView.transform = .identity
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.categoryTapped(categoryData[indexPath.row].categoryTitle)
    }

}
