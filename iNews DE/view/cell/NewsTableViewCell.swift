//
//  NewsTableViewCell.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SDWebImage

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblShortDescription: UILabel!
    
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
        bgViewForShadow.layer.cornerRadius = 15
        
        bgViewForShadow.layer.shadowColor = UIColor.black.cgColor
        bgViewForShadow.layer.shadowOpacity = 0.2
        bgViewForShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.sd_cancelCurrentImageLoad()
        img.image = UIImage(named: "ImagePlaceholder")
    }
    
    func loadViewFromNews(news: News){
        lblTitle.text = news.title
        lblSubTitle.text = news.subTitle
        lblShortDescription.text = news.shortDescription
        
        if let newsOriginalImageUrl = news.originalImageUrl {
            img.sd_setImage(with: URL(string: ApiController.baseUrl + newsOriginalImageUrl), placeholderImage: UIImage(named: "ImagePlaceholder"), options: [.retryFailed])
        }
        
        if let newsThumbImageUrl = news.thumbImageUrl {
            //Used to download the thumb image to the cache
            SDWebImageManager.shared().loadImage(with: URL(string: ApiController.baseUrl + newsThumbImageUrl), options: [.retryFailed], progress: nil) { (image: UIImage?, data: Data?, error: Error?, cacheType: SDImageCacheType, success: Bool, url: URL?) in
            }
        }
        
    }
    
}
