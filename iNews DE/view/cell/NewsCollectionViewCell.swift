//
//  NewsCollectionViewCell.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SDWebImage

class NewsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var lblTitle: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var bgViewForShadow: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        prepareForReuse()
        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView() {
        backgroundColor = UIColor.clear
        
        bgView.layer.cornerRadius = 15
        img.layer.cornerRadius = 15
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.sd_cancelCurrentImageLoad()
        img.image = UIImage(named: "ImagePlaceholder")
    }
    
    func loadViewFromNews(news: News){
        lblTitle.text = news.title
        
        if let newsThumbImageUrl = news.thumbImageUrl {
            img.sd_setImage(with: URL(string: ApiController.baseUrl + newsThumbImageUrl), placeholderImage: UIImage(named: "ImagePlaceholder"), options: [.retryFailed])
        }
        
        if let newsOriginalImageUrl = news.originalImageUrl {
            //Download the original image to the cache
            SDWebImageManager.shared().loadImage(with: URL(string: ApiController.baseUrl + newsOriginalImageUrl), options: [.retryFailed], progress: nil) { (image: UIImage?, data: Data?, error: Error?, cacheType: SDImageCacheType, success: Bool, url: URL?) in
            }
        }
        
    }
    
}
