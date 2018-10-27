//
//  NewsDetailsViewController.swift
//  iNews DE
//
//  Created by MedAmine on 10/26/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SDWebImage
import SafariServices

class NewsDetailsViewController: UIViewController {

    @IBOutlet weak var img: UIImageView!
    
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblSubTitle: UILabel!
    @IBOutlet weak var lblDescription: UILabel!
    
    @IBOutlet weak var bgViewForImg: UIView!
    @IBOutlet weak var viewDetails: UIView!
    
    private var news: News?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        img.layer.cornerRadius = 15
        bgViewForImg.layer.cornerRadius = 15
        viewDetails.layer.cornerRadius = 15
        
        bgViewForImg.layer.shadowColor = UIColor.black.cgColor
        bgViewForImg.layer.shadowOpacity = 0.2
        bgViewForImg.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        viewDetails.layer.shadowColor = UIColor.black.cgColor
        viewDetails.layer.shadowOpacity = 0.2
        viewDetails.layer.shadowOffset = CGSize(width: 5, height: 5)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Internet"), style: .plain, target: self, action: #selector(btnOpenInNavigatorClicked))
    }
    
    func loadDetailsFrom(news: News){
        loadViewIfNeeded()
        
        self.news = news
        
        title = news.subTitle
        
        lblTitle.text = news.title
        lblSubTitle.text = news.subTitle
        lblDescription.text = news.body
        
        if let newsDescriptionData = news.body.data(using: .utf8) {
            do {
                let attrNewsDescription = try NSAttributedString(data: newsDescriptionData, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
                lblDescription.text = attrNewsDescription.string
            }catch _ {
            }
        }
        
        if let newsOriginalImageUrl = news.originalImageUrl {
            img.sd_setImage(with: URL(string: ApiController.baseUrl + newsOriginalImageUrl), placeholderImage: UIImage(named: "ImagePlaceholder"), options: [.retryFailed])
        }
        
    }
    
    //MARK:- Actions
    
    @objc private func btnOpenInNavigatorClicked(){
        if let newsFullUrl = news?.fullUrl, let url = URL(string: ApiController.baseUrl + newsFullUrl) {
            let svc = SFSafariViewController(url: url)
            svc.modalPresentationStyle = .overFullScreen
            present(svc, animated: true, completion: nil)
        }
    }

}
