//
//  ApiController.swift
//  iNews DE
//
//  Created by MedAmine on 10/23/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation
import Alamofire

class ApiController {
    
    static let shared = ApiController()
    
    private let baseUrl = "https://www.gamesundbusiness.de"
    
    func getAllNews(onComplition: @escaping ([News]?)->()){
        request(baseUrl+"/index.php?id=581", method: .get).responseJSON { (dataResponse: DataResponse<Any>) in
            
            guard let statusCode = dataResponse.response?.statusCode else {
                onComplition(nil)
                return
            }
            
            let result = dataResponse.result.value
            
            switch statusCode {
            case 200:
                guard let allData = result as? [[String: AnyObject]] else {
                    onComplition(nil)
                    return
                }
                
                var allNews: [News] = []
                
                for data in allData {
                    if let news = NewsUtils.shared.parseFromJson(jsonData: data) {
                        allNews.append(news)
                    }
                }

                onComplition(allNews)
            default:
                onComplition(nil)
                return
            }
            
        }
    }
    
}
