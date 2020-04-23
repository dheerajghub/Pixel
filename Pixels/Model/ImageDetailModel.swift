//
//  ImageDetailModel.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 22/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class FetchImageDetailModel:NSObject {
    
    var imageUrl:String!
    
    static func fetchImages(url:String, id:String, completionHandler: @escaping (FetchImageDetailModel) -> ()){
        
        let url = "\(url)/\(id)"
        
        let headers:HTTPHeaders = [
            "Authorization": "\(Constants.API_KEY)"
        ]
        
        AF.request(url, method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            
            switch(response.result){
            case .success(_):
                
                let data = JSON(response.value!)
                let modelData = FetchImageDetailModel()
                modelData.imageUrl = data["src"]["large"].string
                
                DispatchQueue.main.async {
                    completionHandler(modelData)
                }
                
                break
                
            case .failure(_):
                print(response.error!)
                break
            }
            
        }
    }
}

