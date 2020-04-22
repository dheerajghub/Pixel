//
//  SearchViewController.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 22/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {

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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(navView)
        navView.addSubview(searchTextField)
        navView.addSubview(seperatorView)
        navView.addSubview(cancelBtn)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            navView.topAnchor.constraint(equalTo: view.topAnchor),
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
        ])
    }
    
    @objc func cancelModal(){
        dismiss(animated: true, completion: nil)
    }
}
