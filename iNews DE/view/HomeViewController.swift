//
//  HomeViewController.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var tableViewNews: UITableView!
    @IBOutlet weak var collectionViewNews: UICollectionView!
    
    private let collectionViewCellIdentifier = "NewsCollectionViewCell"
    
    private var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        loadData()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        tableViewNews.delegate = self
        tableViewNews.dataSource = self
        
        collectionViewNews.delegate = self
        collectionViewNews.dataSource = self
        
        collectionViewNews.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
    }
    
    private func loadData(){
        ApiController.shared.getAllNews { (allNews: [News]?) in
            
            if let allNews = allNews {
                self.news = allNews
            } else {
                self.news = []
            }
            
            self.tableViewNews.reloadData()
            self.collectionViewNews.reloadData()
        }
    }

}

//MARK:- extension: UITableViewDelegate, UITableViewDataSource
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("NewsTableViewCell", owner: self, options: nil)?.first as! NewsTableViewCell
        cell.selectionStyle = .none
        
        cell.loadViewFromNews(news: news[indexPath.row])
        
        return cell
    }
    
}

//MARK:- extension:  UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewFlowLayout
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionViewCellIdentifier, for: indexPath) as! NewsCollectionViewCell
        
        cell.loadViewFromNews(news: news[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.size.width
        return CGSize(width: screenWidth / 2, height: screenWidth / 2)
    }
    
}
