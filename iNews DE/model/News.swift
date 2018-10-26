//
//  News.swift
//  iNews DE
//
//  Created by MedAmine on 10/23/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation

class News: NSObject, NSCoding {
    
    var id: Int
    var title: String
    var subTitle: String
    var thumbImageUrl: String?
    var originalImageUrl: String?
    var shortDescription: String
    var body: String
    var fullUrl: String
    
    init (id: Int, title: String, subTitle: String, thumbImageUrl: String?, originalImageUrl: String?, shortDescription: String,body: String,fullUrl: String) {
        self.id = id
        self.title = title
        self.subTitle = subTitle
        self.thumbImageUrl = thumbImageUrl
        self.originalImageUrl = originalImageUrl
        self.shortDescription = shortDescription
        self.body = body
        self.fullUrl = fullUrl
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: "id")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(subTitle, forKey: "subTitle")
        aCoder.encode(thumbImageUrl, forKey: "thumbImageUrl")
        aCoder.encode(originalImageUrl, forKey: "originalImageUrl")
        aCoder.encode(shortDescription, forKey: "shortDescription")
        aCoder.encode(body, forKey: "body")
        aCoder.encode(fullUrl, forKey: "fullUrl")
    }
    
    required init?(coder aDecoder: NSCoder) {
        id = aDecoder.decodeInteger(forKey: "id")
        title = aDecoder.decodeObject(forKey: "title") as! String
        subTitle = aDecoder.decodeObject(forKey: "subTitle") as! String
        thumbImageUrl = aDecoder.decodeObject(forKey: "thumbImageUrl") as? String
        originalImageUrl = aDecoder.decodeObject(forKey: "originalImageUrl") as? String
        shortDescription = aDecoder.decodeObject(forKey: "shortDescription") as! String
        body = aDecoder.decodeObject(forKey: "body") as! String
        fullUrl = aDecoder.decodeObject(forKey: "fullUrl") as! String
    }
    
}
