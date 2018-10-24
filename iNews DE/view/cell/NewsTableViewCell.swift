//
//  NewsTableViewCell.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell {

    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblShortDescription: UILabel!
    
    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var bgView: UIView!
    
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
        
        bgView.layer.shadowColor = UIColor.black.cgColor
        bgView.layer.shadowOpacity = 0.2
        bgView.layer.shadowOffset = CGSize(width: 5, height: 5)
    }
    
    override func prepareForReuse() {
        img.image = UIImage(named: "ImagePlaceholder")
    }
    
    func loadViewFromNews(news: News){
        lblTitle.text = news.title
        lblSubTitle.text = news.subTitle
        lblShortDescription.text = news.shortDescription
    }
    
}
