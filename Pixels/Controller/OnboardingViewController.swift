//
//  OnboardingViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 20/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class OnboardingViewController: UIViewController {

    var dataArr = [OnboardingData]()
    
    let collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
        collectionView.backgroundColor = .white
        collectionView.isPagingEnabled = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPage = 0
        pageControl.numberOfPages = 3
        pageControl.pageIndicatorTintColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
        pageControl.currentPageIndicatorTintColor = UIColor(red: 29/255, green: 212/255, blue: 255/255, alpha: 1)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    let getStartedButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("Get Started", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.backgroundColor = UIColor(red: 29/255, green: 168/255, blue: 255/255, alpha: 1)
        btn.titleLabel?.font = UIFont(name: "Times-Bold", size: 22)
        btn.layer.cornerRadius = 25
        btn.addTarget(self, action: #selector(getStartedPressed), for: .touchUpInside)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout.scrollDirection = .horizontal
        collectionView.setCollectionViewLayout(layout, animated: false)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(OnboardingCollectionViewCell.self, forCellWithReuseIdentifier: "OnboardingCollectionViewCell")
        view.addSubview(pageControl)
        view.addSubview(getStartedButton)
        view.insertSubview(collectionView, belowSubview: pageControl)
        setUpConstraints()
        dataArr = [
            OnboardingData(image: "graphic1", title: "Explore Images", subtitle: "Explore large collection of images"),
            OnboardingData(image: "graphic2", title: "Category Search", subtitle: "Search image with category"),
            OnboardingData(image: "graphic3", title: "Download Images", subtitle: "Pick and save image to you imageroll"),
        ]
        getStartedButton.isHidden = true
    }
    
    @objc func getStartedPressed(){
        let userDefault = UserDefaults.standard
        userDefault.set(true, forKey: "onboardingCompletes")
        userDefault.synchronize()
        let vc = ImagesViewController()
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .fullScreen
        present(navVC, animated: true, completion: nil)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            //Page Controll
            pageControl.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            pageControl.heightAnchor.constraint(equalToConstant: 30),
            
            //Btn
            getStartedButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            getStartedButton.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -40),
            getStartedButton.heightAnchor.constraint(equalToConstant: 50),
            getStartedButton.widthAnchor.constraint(equalToConstant: 170)
        ])
        collectionView.pin(to: view)
    }
}

extension OnboardingViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OnboardingCollectionViewCell", for: indexPath) as! OnboardingCollectionViewCell
        cell.data = dataArr[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(collectionView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
        if self.pageControl.currentPage == 2 {
            getStartedButton.isHidden = false
        } else {
            getStartedButton.isHidden = true
        }
    }
    
}
