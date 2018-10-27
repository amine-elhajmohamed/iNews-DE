//
//  HomeViewController.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit
import SDWebImage

class HomeViewController: UIViewController {
    
    @IBOutlet weak var btnTryAgain: UIButton!
    
    @IBOutlet weak var labelMessage: UILabel!
    
    @IBOutlet weak var segmentControlChangeDisplayMode: UISegmentedControl!
    
    @IBOutlet weak var tableViewNews: UITableView!
    @IBOutlet weak var collectionViewNews: UICollectionView!
    
    @IBOutlet weak var viewNoContent: UIView!
    @IBOutlet weak var viewMessage: UIView!
    
    private var currentDisplayMode: DisplayMode!
    
    private let collectionViewCellIdentifier = "NewsCollectionViewCell"
    
    private var news: [News] = []
    
    private var tableViewNewsIsRefreshing = false
    private var collectionViewNewsIsRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        loadData(from: .cache)
        setDisplayMode(to: .list)
        
        //To load data from internet with animating the refresh view
        tableViewNews.es.startPullToRefresh()
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        viewNoContent.isHidden = true
        viewMessage.isHidden = true
        
        tableViewNews.delegate = self
        tableViewNews.dataSource = self
        
        collectionViewNews.delegate = self
        collectionViewNews.dataSource = self
        
        collectionViewNews.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
        tableViewNews.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionViewNews.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        tableViewNews.es.addPullToRefresh { [unowned self] in
            self.tableViewNewsIsRefreshing = true
            
            if !self.collectionViewNewsIsRefreshing {
                self.collectionViewNews.es.startPullToRefresh()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1, execute: {
                self.loadData(from: .internet, onComplition: { (success: Bool) in
                    self.tableViewNews.es.stopPullToRefresh()
                    self.collectionViewNews.es.stopPullToRefresh()
                    self.tableViewNewsIsRefreshing = false
                    self.collectionViewNewsIsRefreshing = false
                })
            })   
        }
        
        collectionViewNews.es.addPullToRefresh { [unowned self] in
            self.collectionViewNewsIsRefreshing = true
            if !self.tableViewNewsIsRefreshing {
                self.tableViewNews.es.startPullToRefresh()
            }
        }
    }
    
    private func loadData(from mode: LoadDataMode, onComplition: @escaping (Bool)->() = { _ in }){
        
        switch mode {
        case .cache:
            if let news = NewsController.shared.getNewsFromCache() {
                self.news = news
                self.tableViewNews.reloadData()
                self.collectionViewNews.reloadData()
                onComplition(true)
            } else {
                onComplition(false)
            }
        case .internet:
            NewsController.shared.getNewsFromInternet { (news: [News]?) in
                if let news = news {
                    self.news = news
                    /*
                     // Need to only clear the unused images
                    SDImageCache.shared().clearMemory()
                    SDImageCache.shared().clearDisk()
                     */
                    NewsController.shared.saveNewsToCache(news: news)
                    
                    self.viewNoContent.isHidden = true
                    self.tableViewNews.reloadData()
                    self.collectionViewNews.reloadData()
                } else {
                    if self.news.count == 0 {
                        self.viewNoContent.isHidden = false
                    }
                    
                    if let newsUpdatedDate = NewsController.shared.getNewsUpdatedDate() {
                        self.showViewMessage(withText: "Failed to load - Last update : \(DateUtils.shared.differenceBetweenDates(from: newsUpdatedDate, to: Date())) ago")
                    } else {
                        self.showViewMessage(withText: "Failed to load")
                    }
                }
                
                onComplition(news != nil)
            }
            
        }
        
    }
    
    private func showViewMessage(withText text: String){
        labelMessage.text = text
        
        guard viewMessage.isHidden else {
            return
        }
        
        viewMessage.transform = CGAffineTransform(translationX: 0, y: viewMessage.frame.height)
        viewMessage.isHidden = false
        
        UIView.animate(withDuration: 0.5, animations: {
            self.viewMessage.transform = CGAffineTransform(translationX: 0, y: 0)
        })
        
        UIView.animate(withDuration: 0.5, delay: 3, animations: {
            self.viewMessage.transform = CGAffineTransform(translationX: 0, y: self.viewMessage.frame.height)
        }, completion: { (_) in
            self.viewMessage.isHidden = true
        })
        
    }
    
    private func setDisplayMode(to newDisplayMode: DisplayMode){
        guard currentDisplayMode != newDisplayMode else {
            return
        }
        
        currentDisplayMode = newDisplayMode
        
        changeScollPos(newDisplayMode: newDisplayMode)
        
        switch newDisplayMode {
        case .list:
            collectionViewNews.isHidden = true
            tableViewNews.isHidden = false
        case .grid:
            tableViewNews.isHidden = true
            collectionViewNews.isHidden = false
        }
    }
    
    private func changeScollPos(newDisplayMode: DisplayMode){
        switch newDisplayMode {
        case .list:
            var indexOfVisibleItems = collectionViewNews.indexPathsForVisibleItems.map { (i: IndexPath) -> Int in
                return i.row
            }
            
            indexOfVisibleItems.sort() // Need to sort it in collection view but not required for tableView
            
            if let firstVisibleItem = indexOfVisibleItems.first {
                tableViewNews.scrollToRow(at: IndexPath(row: firstVisibleItem, section: 0), at: .top, animated: false)
            }
        case .grid:
            if let indexOfVisibleRows = tableViewNews.indexPathsForVisibleRows, let firstVisibletRow = indexOfVisibleRows.first?.row {
                collectionViewNews.scrollToItem(at: IndexPath(item: firstVisibletRow, section: 0), at: .top, animated: false)
            }
        }
    }

    //MARK:- Actions
    
    @IBAction func btnClicked(_ sender: UIButton) {
        switch sender {
        case btnTryAgain:
            tableViewNews.es.startPullToRefresh()
        default:
            break
        }
    }
    
    @IBAction func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        switch sender {
        case segmentControlChangeDisplayMode:
            switch sender.selectedSegmentIndex {
            case 0:
                setDisplayMode(to: .list)
            case 1:
                setDisplayMode(to: .grid)
            default:
                break
            }
        default:
            break
        }
    }
    
    //MARK:- Enums
    
    private enum DisplayMode {
        case list
        case grid
    }
    
    private enum LoadDataMode {
        case cache
        case internet
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedNews = news[indexPath.row]
        let newsDetailsVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetailsVC") as! NewsDetailsViewController
        newsDetailsVC.loadDetailsFrom(news: selectedNews)
        navigationController?.pushViewController(newsDetailsVC, animated: true)
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedNews = news[indexPath.row]
        let newsDetailsVC = storyboard?.instantiateViewController(withIdentifier: "NewsDetailsVC") as! NewsDetailsViewController
        newsDetailsVC.loadDetailsFrom(news: selectedNews)
        navigationController?.pushViewController(newsDetailsVC, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = collectionView.bounds.size.width
        return CGSize(width: screenWidth / 2, height: screenWidth / 2)
    }
    
}
