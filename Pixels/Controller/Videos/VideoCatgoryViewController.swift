//
//  VideoCatgoryViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 24/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import AVKit

class VideoCatgoryViewController: UIViewController {

    var query = ""
    var FetchedVideos:FetchVideoModel?
    var videoList:[ListVideoData]?
    var page:Int = 1
    
    let collectionView: UICollectionView = {
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
        cv.showsVerticalScrollIndicator = false
        cv.showsHorizontalScrollIndicator = false
        cv.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 255/255, alpha: 1)
        return cv
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView()
        aI.style = .large
        aI.color = .darkGray
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
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
        collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
        view.addSubview(collectionView)
        view.addSubview(activityIndicator)
        setUpConstraints()
        ///Assigning Custom layout
        if let layout = collectionView.collectionViewLayout as? PinterestLayout {
            layout.delegate = self
        }
        collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        setUpNavigationBar()
        activityIndicator.startAnimating()
        FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query: "\(query)", perPage: "20", page: "1") { (FetchedVideos) in
            self.FetchedVideos = FetchedVideos
            self.getVideoArray(FetchedVideos)
            self.collectionView.reloadData()
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    func getVideoArray(_ data:FetchVideoModel){
        var images = [ListVideoData]()
        let vidResult = data.videoData
        for i in 0..<vidResult!.count{
            let img = ListVideoData(id: vidResult![i].id, height: vidResult![i].height, width: vidResult![i].width, thumbnail: vidResult![i].thumbnail, duration: vidResult![i].duration, videoUrl: vidResult![i].videoUrl)
            images.append(img)
        }
        if videoList == nil {
            videoList = images
        } else {
            videoList?.append(contentsOf: images)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavigationBar()
        tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.layer.zPosition = -1
    }
    
    func setUpNavigationBar(){
        navigationItem.title = "\(query)"
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
        
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(named: "whiteBack")?.withRenderingMode(.alwaysOriginal), for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
    }
        
    @objc func backBtn(){
        navigationController?.popViewController(animated: true)
    }
    
    func setUpConstraints(){
        collectionView.pin(to: view)
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
        
}

extension VideoCatgoryViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            if let videoList = videoList {
                return videoList.count
            }
            return Int()
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
            cell.data = videoList![indexPath.row]
            
            let totalPosts = FetchedVideos?.totalResults
            if indexPath.row == videoList!.count - 1{
                if totalPosts! > videoList!.count {
                    self.page += 1
                    FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query: "\(query)", perPage: "20", page: "\(page)") { (FetchedVideos) in
                        self.FetchedVideos = FetchedVideos
                        self.getVideoArray(FetchedVideos)
                        self.collectionView.reloadData()
                    }
                }
            }
            
            return cell
        }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
          let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
          return CGSize(width: itemSize, height: itemSize)
        }
        
        func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell{
                    cell.imgView.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.backView.transform = .init(scaleX: 0.95, y: 0.95)
                    cell.overView.transform = .init(scaleX: 0.95, y: 0.95)
                }
            }, completion: { _ in
            })
        }
        
        func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                if let cell = collectionView.cellForItem(at: indexPath) as? VideoCollectionViewCell{
                    cell.imgView.transform = .identity
                    cell.backView.transform = .identity
                    cell.overView.transform = .identity
                }
            }, completion: { _ in
            })
        }
        
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let videoList = videoList {
                let videoURL = URL(string: videoList[indexPath.row].videoUrl)
                let player = AVPlayer(url: videoURL!)
                let playerViewController = AVPlayerViewController()
                playerViewController.player = player

                present(playerViewController, animated: true) {
                  player.play()
                }
            }
        }
}

extension VideoCatgoryViewController: PinterestLayoutDelegate {
      func collectionView(
        _ collectionView: UICollectionView,
        heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
        if let videoList = videoList {
            let cellWidth = (collectionView.frame.width - 44) / 2
            let imageRatio = CGFloat(videoList[indexPath.row].width) / CGFloat(videoList[indexPath.row].height)
            return CGFloat(cellWidth / imageRatio)
        }
        return CGFloat()
      }
}

