//
//  HomeViewController.swift
//  iNews DE
//
//  Created by MedAmine on 10/24/18.
//  Copyright © 2018 amine. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {
    
    @IBOutlet weak var segmentControlChangeDisplayMode: UISegmentedControl!
    
    @IBOutlet weak var tableViewNews: UITableView!
    @IBOutlet weak var collectionViewNews: UICollectionView!
    
    private var currentDisplayMode: DisplayMode!
    
    private let collectionViewCellIdentifier = "NewsCollectionViewCell"
    
    private var news: [News] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        loadData(from: .cache)
        setDisplayMode(to: .list)
    }
    
    //MARK:- View configurations
    
    private func configureView(){
        tableViewNews.delegate = self
        tableViewNews.dataSource = self
        
        collectionViewNews.delegate = self
        collectionViewNews.dataSource = self
        
        collectionViewNews.register(UINib(nibName: "NewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: collectionViewCellIdentifier)
        
        tableViewNews.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        collectionViewNews.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
        
        tableViewNews.es.addPullToRefresh { [unowned self] in
            self.loadData(from: .internet, onComplition: { (success: Bool) in
                self.tableViewNews.es.stopPullToRefresh()
            })
        }
    }
    
    private func loadData(from mode: LoadDataMode, onComplition: @escaping (Bool)->() = { _ in }){
        
        switch mode {
        case .cache:
            break
        case .internet:
            
            ApiController.shared.getAllNews { (allNews: [News]?) in
                if let allNews = allNews {
                    self.news = allNews
                    self.tableViewNews.reloadData()
                    self.collectionViewNews.reloadData()
                }
                
                onComplition(allNews != nil)
            }
            
        }
        
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
