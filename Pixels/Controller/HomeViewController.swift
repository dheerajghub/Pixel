//
//  HomeViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 21/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    var imgs = [String]()
    
    let headerView: HeaderView = {
        let view = HeaderView()
        view.backgroundColor = .white
        return view
    }()
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = .white
        return cv
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
        view.backgroundColor = .white
        setUpNavigationBar()
        view.addSubview(headerView)
        view.addSubview(collectionView)
        setUpConstraints()
        imgs = ["travel", "nature", "sports", "architecture", "food"]
        
        ///Assigning Custom layout
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
    }

    func setUpNavigationBar(){
        navigationController?.navigationBar.topItem?.title = "PIXEL"
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
    }
    
    func setUpConstraints(){
        headerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(equalTo: view.topAnchor),
            headerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            headerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            headerView.heightAnchor.constraint(equalToConstant: 160)
        ])
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
}

extension HomeViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        cell.imgView.image = UIImage(named: imgs[indexPath.row])
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
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                cell.imgView.transform = .identity
            }
        }, completion: { _ in
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ImagePreviewViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension HomeViewController: PinterestLayoutDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
    let currImage = UIImage(named: imgs[indexPath.row])
    let imageRatio = currImage?.getImageRatio()
    return CGFloat(collectionView.frame.width / imageRatio!)
  }
}
