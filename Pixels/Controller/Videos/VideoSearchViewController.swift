//
//  VideoSearchViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 25/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import AVKit

class VideoSearchViewController: UIViewController, UITextFieldDelegate {

    var FetchedVideos:FetchVideoModel?
    var videoList:[ListVideoData]?
    var page:Int = 1
    
    var bottomConstraint: NSLayoutConstraint?
    
    
    let navView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let searchTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Search"
        textField.textColor = .black
        textField.backgroundColor = UIColor(red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
        textField.tintColor = UIColor(red: 178/255, green: 178/255, blue: 178/255, alpha: 1)
        textField.layer.cornerRadius = 5
        let indentView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: 45))
        textField.leftView = indentView
        textField.leftViewMode = .always
        textField.font = UIFont(name: "Times", size: 20)
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.becomeFirstResponder()
        return textField
    }()
    
    let collectionView: UICollectionView = {
           let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: PinterestLayout.init())
           cv.showsVerticalScrollIndicator = false
           cv.showsHorizontalScrollIndicator = false
           cv.translatesAutoresizingMaskIntoConstraints = false
           cv.backgroundColor = UIColor(red: 239/255, green: 252/255, blue: 255/255, alpha: 1)
           return cv
    }()
    
    let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
    
    let cancelBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("cancel", for: .normal)
        btn.titleLabel?.font = UIFont(name: "Times-Bold", size: 20)
        btn.setTitleColor(.black, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(cancelModal), for: .touchUpInside)
        return btn
    }()
    
    let seperatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.alpha = 0.5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let aI = UIActivityIndicatorView()
        aI.style = .medium
        aI.color = .darkGray
        aI.translatesAutoresizingMaskIntoConstraints = false
        return aI
    }()
    
    let loadingMessage:UILabel = {
        let message = UILabel()
        message.font = UIFont(name: "Times", size: 20)
        message.textColor = .darkGray
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            layout.scrollDirection = .vertical
            collectionView.setCollectionViewLayout(layout, animated: false)
            let customLayout = PinterestLayout()
            collectionView.collectionViewLayout = customLayout
            collectionView.delegate = self
            collectionView.dataSource = self
            searchTextField.delegate = self
            view.backgroundColor = .white
            collectionView.register(VideoCollectionViewCell.self, forCellWithReuseIdentifier: "VideoCollectionViewCell")
            view.addSubview(navView)
            navView.addSubview(searchTextField)
            navView.addSubview(seperatorView)
            navView.addSubview(cancelBtn)
            view.addSubview(collectionView)
            collectionView.addSubview(activityIndicator)
            collectionView.addSubview(loadingMessage)
            setUpConstraints()
            
            searchTextField.addTarget(self, action: #selector(VideoSearchViewController.textFieldDidChange(_:)), for: UIControl.Event.editingChanged)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillShowNotification , object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardNotification) , name: UIResponder.keyboardWillHideNotification , object: nil)
            
            //bottomconstraints
            bottomConstraint = NSLayoutConstraint(item: collectionView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 0)
            view.addConstraint(bottomConstraint!)
            
            ///Assigning Custom layout
            if let layout = collectionView.collectionViewLayout as? PinterestLayout {
                layout.delegate = self
            }
            
            collectionView.contentInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            
        }
        
        override func viewWillAppear(_ animated: Bool) {
            navigationController?.navigationBar.isHidden = true
            tabBarController?.tabBar.isHidden = true
            self.tabBarController?.tabBar.layer.zPosition = -1
        }
        
        func setUpConstraints(){
            NSLayoutConstraint.activate([
                navView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
                navView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                navView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                navView.heightAnchor.constraint(equalToConstant: 70),
                
                seperatorView.leadingAnchor.constraint(equalTo: navView.leadingAnchor),
                seperatorView.trailingAnchor.constraint(equalTo: navView.trailingAnchor),
                seperatorView.bottomAnchor.constraint(equalTo: navView.bottomAnchor),
                seperatorView.heightAnchor.constraint(equalToConstant: 0.5),
                
                searchTextField.leadingAnchor.constraint(equalTo: navView.leadingAnchor, constant: 17),
                searchTextField.trailingAnchor.constraint(equalTo: cancelBtn.leadingAnchor, constant: -10),
                searchTextField.heightAnchor.constraint(equalToConstant: 45),
                searchTextField.centerYAnchor.constraint(equalTo: navView.centerYAnchor),
                
                cancelBtn.trailingAnchor.constraint(equalTo: navView.trailingAnchor, constant: -17),
                cancelBtn.leadingAnchor.constraint(equalTo: searchTextField.trailingAnchor, constant: 10),
                cancelBtn.heightAnchor.constraint(equalToConstant: 45),
                cancelBtn.centerYAnchor.constraint(equalTo: navView.centerYAnchor),
                
                collectionView.topAnchor.constraint(equalTo: navView.bottomAnchor),
                collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                collectionView.trailingAnchor.constraint(equalTo: navView.trailingAnchor),
                collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.topAnchor.constraint(equalTo: collectionView.topAnchor, constant: 30),
                
                loadingMessage.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 10),
                loadingMessage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        }
        
        func getVideoArray(_ data:FetchVideoModel){
            var videos = [ListVideoData]()
            let vidResult = data.videoData
            for i in 0..<vidResult!.count{
                let vid = ListVideoData(id: vidResult![i].id, height: vidResult![i].height, width: vidResult![i].width, thumbnail: vidResult![i].thumbnail, videoUrl: vidResult![i].videoUrl)
                videos.append(vid)
            }
            if videoList == nil {
                videoList = videos
            } else {
                videoList?.append(contentsOf: videos)
            }
        }
        
        @objc func textFieldDidChange(_ textField: UITextField) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 , execute: {
                self.activityIndicator.isHidden = false
                self.activityIndicator.startAnimating()
                FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query: self.searchTextField.text!, perPage: "40", page: "1") { (FetchedVideos) in
                    self.FetchedVideos = FetchedVideos
                    self.videoList?.removeAll()
                    self.getVideoArray(FetchedVideos)
                    if(self.FetchedVideos?.videoData.count == 0){
                        self.loadingMessage.text = "No result"
                    } else {
                        self.loadingMessage.text = ""
                    }
                    self.collectionView.reloadData()
                    self.collectionView.collectionViewLayout.invalidateLayout()
                    self.activityIndicator.stopAnimating()
                    self.activityIndicator.isHidden = true
                }
                
                if self.searchTextField.text == ""{
                    self.loadingMessage.text = ""
                }
            })
            
        }
        
        @objc func cancelModal(){
            navigationController?.popViewController(animated: false)
        }
        
        @objc func handleKeyboardNotification(notification: NSNotification){
            
            if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let keyboardRectangle = keyboardFrame.cgRectValue
                let keyboardHeight = keyboardRectangle.height
                
                let isKeyboardShowing = notification.name == UIResponder.keyboardWillShowNotification
                
                bottomConstraint?.constant = isKeyboardShowing ? -keyboardHeight : 0
                
                UIView.animate(withDuration:0.1, delay: 0 , options: .curveEaseOut , animations: {
                    self.view.layoutIfNeeded()
                } , completion: {(completed) in
                })
            }
        }
    }

extension VideoSearchViewController:UICollectionViewDelegate , UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
        
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                if let videoList = videoList {
                    if videoList.count > 0 {
                        return videoList.count
                    } else {
                        return 1
                    }
                    
                }
                return Int()
            }
            
            func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "VideoCollectionViewCell", for: indexPath) as! VideoCollectionViewCell
                if let videoList = videoList {
                    if videoList.count > 0{
                        cell.data = videoList[indexPath.row]
                        
                        let totalPosts = FetchedVideos?.totalResults
                        if indexPath.row == videoList.count - 1{
                            if totalPosts! > videoList.count {
                                self.page += 1
                                FetchVideoModel.fetchVideos(url: "\(Constants.BASE_URL_VIDEO)/search", query: self.searchTextField.text!, perPage: "40", page: "1") { (FetchedVideos) in
                                    self.FetchedVideos = FetchedVideos
                                    self.getVideoArray(FetchedVideos)
                                    self.collectionView.reloadData()
                                    self.collectionView.collectionViewLayout.invalidateLayout()
                                }
                            }
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
                    if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                        cell.imgView.transform = .init(scaleX: 0.95, y: 0.95)
                        cell.backView.transform = .init(scaleX: 0.95, y: 0.95)
                    }
                }, completion: { _ in
                })
            }
            
            func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
                UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                    if let cell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell{
                        cell.imgView.transform = .identity
                        cell.backView.transform = .identity
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

extension VideoSearchViewController: PinterestLayoutDelegate {
          func collectionView(
            _ collectionView: UICollectionView,
            heightForPhotoAtIndexPath indexPath:IndexPath) -> CGFloat {
            if let videoList = videoList {
                if videoList.count > 0 {
                    let cellWidth = (collectionView.frame.width - 44) / 2
                    let imageRatio = CGFloat(videoList[indexPath.row].width) / CGFloat(videoList[indexPath.row].height)
                    return CGFloat(cellWidth / imageRatio)
                }
            }
            return CGFloat()
          }
    }

