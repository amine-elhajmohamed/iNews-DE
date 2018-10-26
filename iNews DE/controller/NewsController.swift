//
//  NewsController.swift
//  iNews DE
//
//  Created by MedAmine on 10/26/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation
import Alamofire

class NewsController {
    
    static let shared = NewsController()
    
    private let _CACHED_NEWS_KEY = "CACHED_NEWS"
    private let _CACHED_NEWS_DATE_KEY = "CACHED_NEWS_DATE"
    
    func saveNewsToCache(news: [News]) {
        UserDefaults.standard.set(NSKeyedArchiver.archivedData(withRootObject: news), forKey: _CACHED_NEWS_KEY)
        UserDefaults.standard.set(Date(), forKey: _CACHED_NEWS_DATE_KEY)
    }
    
    func getNewsFromCache() -> [News]?{
        if let newsData = UserDefaults.standard.value(forKey: _CACHED_NEWS_KEY) as? Data, let news = NSKeyedUnarchiver.unarchiveObject(with: newsData) as? [News] {
            return news
        }else{
            return nil
        }
    }
    
    func getNewsUpdatedDate() -> Date?{
        return UserDefaults.standard.value(forKey: _CACHED_NEWS_DATE_KEY) as? Date
    }
    
    func getNewsFromInternet(onComplition: @escaping ([News]?)->()){
        request(ApiController.baseUrl+"/index.php?id=581", method: .get).responseJSON { (dataResponse: DataResponse<Any>) in
            
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
