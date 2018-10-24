//
//  NewsUtils.swift
//  iNews DE
//
//  Created by MedAmine on 10/23/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation

class NewsUtils {
    
    static let shared = NewsUtils()
    
    func parseFromJson(jsonData: [String: AnyObject]) -> News?{
        
        //Required fileds
        guard let id = jsonData["newsId"] as? Int, let title = jsonData["newsTitle"] as? String, let subTitle = jsonData["newsSubTitle"] as? String, let shortDescription = jsonData["newsShortDesc"] as? String, let body = jsonData["newsBody"] as? String, let fullUrl = jsonData["newsUrl"] as? String else {
            return nil
        }
        
        //Optionals fields
        let thumbImageUrl = jsonData["newsThumbImage"] as? String
        let originalImageUrl = jsonData["newsOriImage"] as? String
        
        let news = News(id: id, title: title, subTitle: subTitle, thumbImageUrl: thumbImageUrl, originalImageUrl: originalImageUrl, shortDescription: shortDescription, body: body, fullUrl: fullUrl)
        
        return news
    }
    
}
