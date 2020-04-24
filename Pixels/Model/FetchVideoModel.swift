//
//  FetchVideoModel.swift
//  Pixels
//
//  Created by Dheeraj Kumar Sharma on 24/04/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Videos {
    var id:Int!
    var width:Int!
    var height:Int!
    var thumbnail:String!
    var duration:Int!
    var videoUrl:String!
}

class FetchVideoModel:NSObject {
    var totalResults:Int!
    var videoData:[Videos]!
    static func fetchVideos(url:String, query:String, perPage:String, page:String, completionHandler: @escaping (FetchVideoModel) -> ()){
        
        let url = "\(url)/?query=\(query)&per_page=\(perPage)&page=\(page)"
        
        let headers:HTTPHeaders = [
            "Authorization": "\(Constants.API_KEY)"
        ]
        
        AF.request(url, method: .get, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            
            switch(response.result){
            case .success(_):
                
                let data = JSON(response.value!)
                let modelData = FetchVideoModel()
                modelData.totalResults = data["total_results"].int
                var videosData = [Videos]()
                for i in 0..<data["videos"].count{
                    let video = Videos()
                    video.id = data["videos"][i]["id"].int
                    video.height = data["videos"][i]["height"].int
                    video.width = data["videos"][i]["width"].int
                    video.thumbnail = data["videos"][i]["image"].string
                    video.duration = data["videos"][i]["duration"].int
                    video.videoUrl = data["videos"][i]["video_files"][2]["link"].string
                    videosData.append(video)
                }
                modelData.videoData = videosData
                
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
