//
//  News.swift
//  iNews DE
//
//  Created by MedAmine on 10/23/18.
//  Copyright © 2018 amine. All rights reserved.
//

import Foundation

class News {
    
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
    
}
