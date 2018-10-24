//
//  NewsCollectionViewCell.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

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
        bgViewForShadow.layer.cornerRadius = 15
        img.layer.cornerRadius = 15
        
        bgViewForShadow.layer.shadowColor = UIColor.black.cgColor
        bgViewForShadow.layer.shadowOpacity = 0.2
        bgViewForShadow.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        img.image = UIImage(named: "ImagePlaceholder")
    }
    
    func loadViewFromNews(news: News){
        lblTitle.text = news.title
    }
    
}
