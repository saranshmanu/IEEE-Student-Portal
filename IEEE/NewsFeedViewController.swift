//
//  NewsFeedViewController.swift
//  IEEE
//
//  Created by Saransh Mittal on 25/03/17.
//  Copyright © 2017 Saransh Mittal. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class NewsFeedViewController: UIViewController ,iCarouselDelegate, iCarouselDataSource{
    
    @IBOutlet weak var NewsTitle: UILabel!
    @IBOutlet weak var NewsDescription: UILabel!
    @IBOutlet weak var NewsImage: UIImageView!
    
    var articles = [NSDictionary]()
    var images = [UIImage]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        NewsFeed.dataSource = self
        NewsFeed.delegate = self
        NewsFeed.type = .linear
        NewsFeed.reloadData()
        fetchData()
    }

    func fetchData(){
        //for fetching the news data]
        let url = "https://newsapi.org/v1/articles?source=engadget&sortBy=top&apiKey=61142cee663d463aa704fb319fc0156a"
        Alamofire.request(url).responseJSON{response in
            print(response)
            let x = response.result.value as! NSDictionary
            self.articles = x["articles"] as! [NSDictionary]
            self.NewsFeed.reloadData()
        }
        if articles.count != 0{
            for i in 0...articles.count-1{
                Alamofire.request(String(describing: articles[i][""])).responseImage{
                    img in
                    if img.result.value != nil{
                        self.images.append(img.result.value!)
                        self.NewsFeed.reloadData()
                    }
                }
            }
        }
    }
    
    @IBOutlet var NewsFeed: iCarousel!
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func numberOfItems(in carousel: iCarousel) -> Int {
        return articles.count
    }
    
    func carousel(_ carousel: iCarousel, viewForItemAt index: Int, reusing view: UIView?) -> UIView {
//        var itemView = UIImageView()
//        if view == nil {
//            itemView = UIImageView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            
//        } else {
//            itemView = view as! UIImageView
//        }
//        itemView.contentMode = .scaleAspectFit
//        let z = articles[index]["urlToImage"] as! String
//        let url = URL(string: "\(z)")
//        itemView.af_setImage(withURL: url! ,placeholderImage: UIImage(named : ""))
        
        print(articles[index]["title"] as! String)
        NewsTitle.text = articles[index]["title"] as! String
        //NewsDescription.text = articles[index]["description"] as! String
        return NewsTitle
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
