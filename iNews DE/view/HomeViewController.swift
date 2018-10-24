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
    }
    
    private func loadData(){
        ApiController.shared.getAllNews { (allNews: [News]?) in
            
            if let allNews = allNews {
                self.news = allNews
            } else {
                self.news = []
            }
            
            self.tableViewNews.reloadData()
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
