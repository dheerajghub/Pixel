//
//  EditImageViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 13/08/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class EditImageViewController: UIViewController {

    let filtersView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .red
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(filtersView)
        view.backgroundColor = .white
        setUpConstraints()
        setUpNavigationBar()
    }
    
    func setUpNavigationBar(){
        navigationItem.title = ""
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        navigationController?.navigationBar.layer.shadowOffset = CGSize(width: 0, height: 0.5)
        navigationController?.navigationBar.layer.shadowColor = UIColor.lightGray.cgColor
        navigationController?.navigationBar.layer.shadowOpacity = 0.6
        navigationController?.navigationBar.layer.shadowRadius = 0.3
        navigationController?.navigationBar.barTintColor = .clear
        navigationController?.navigationBar.isTranslucent = true
        
        let backButton = UIButton(type: .system)
        backButton.setTitle("CANCEL", for: .normal)
        backButton.titleLabel?.font = UIFont(name:"Poppins-Thin", size: 14)
        backButton.setTitleColor(.black, for: .normal)
        backButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
        backButton.addTarget(self, action: #selector(backBtn), for: .touchUpInside)
        let leftBarButtonItem = UIBarButtonItem()
        leftBarButtonItem.customView = backButton
        navigationItem.setLeftBarButton(leftBarButtonItem, animated: false)
        
        let saveButton = UIButton(type: .system)
        saveButton.setTitle("SAVE", for: .normal)
        saveButton.titleLabel?.font = UIFont(name:"Poppins-Thin", size: 14)
        saveButton.setTitleColor(.black, for: .normal)
        saveButton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: saveButton)
        saveButton.addTarget(self, action: #selector(editButtonPressed), for: .touchUpInside)
        let rightBarButtonItem = UIBarButtonItem()
        rightBarButtonItem.customView = saveButton
        navigationItem.setRightBarButton(rightBarButtonItem, animated: false)
        
    }
    
    @objc func backBtn(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func editButtonPressed(){
        
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            filtersView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filtersView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filtersView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filtersView.heightAnchor.constraint(equalToConstant: 200)
        ])
    }
    
}
