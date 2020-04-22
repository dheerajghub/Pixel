//
//  UIImageView.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 22/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

let imageCache = NSCache<AnyObject, AnyObject>()

class CustomImageView:UIImageView{
    
    var imageUrlString:String?
    
    func cacheImageWithLoader(withURL imageURL: String, view:UIView){
        imageUrlString = imageURL
        image = nil
        if imageURL == ""{
            self.image = UIImage(named: "defaultUser")
        } else {
            let url = URL(string: imageURL)
            let request = URLRequest(url: url!)
            
            if let cachedImage = imageCache.object(forKey: imageURL as AnyObject){
                image = (cachedImage as! UIImage)
                view.isHidden = true
            } else {
                URLSession.shared.dataTask(with: request) { (data, response, error) in
                    if error != nil {
                        print(error as Any)
                        return
                    }
                    
                    DispatchQueue.main.async {
                        guard let imageData = UIImage(data: data!) else {return}
                        imageCache.setObject(imageData, forKey: imageURL as AnyObject)
                        if self.imageUrlString == imageURL {
                            self.image = imageData
                        }
                        view.isHidden = true
                    }
                    
                    }.resume()
            }
        }
    }
}

