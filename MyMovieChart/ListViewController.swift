//
//  ListViewController.swift
//  MyMovieChart
//
//  Created by green on 2016. 6. 8..
//  Copyright © 2016년 lattegreen. All rights reserved.
//

import UIKit

class ListViewController : UITableViewController {
    
    // 테이블 뷰를 구성할 리스트 데이터를 담을 배열 변수( = [MovieVO]( ) )
    
    var list = Array<MovieVO>()
    var page = 1 // 현재까지 읽어온 데이터의 페이지 정보
    
    @IBOutlet var movieTable: UITableView!
    @IBOutlet var moreBtn: UIButton!

    @IBAction func more(sender: AnyObject) {
        self.page += 1
        
        self.callMovieAPI()
        
        self.movieTable.reloadData()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 주어진 행에 맞는 데이터 소스를 가져옴
        let row = self.list[indexPath.row]
        
        // 호출 횟수 확인용
        NSLog("제목: \(row.title!), 호출된 행번호: \(indexPath.row)")
        
        // 테이블 셀을 큐로부터 가져옴
        let cell = tableView.dequeueReusableCellWithIdentifier("ListCell") as! MovieCell
        
        cell.title?.text = row.title
        cell.desc?.text = row.description
        cell.opendate?.text = row.opendate
        cell.rating?.text = "\(row.rating!)"
        
        dispatch_async(dispatch_get_main_queue(), {
            cell.thumbnail?.image = self.getThumbnailImage(indexPath.row)
        })
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        NSLog("Touch Table Row at %d", indexPath.row)
    }
    
    override func viewDidLoad() {
        self.callMovieAPI()
    }
    
    func callMovieAPI() {
        
        let apiURI = NSURL(string: "http://115.68.183.178:2029/hoppin/movies?order=releasedateasc&count=30&page=\(self.page)&version=1&genreId=")
        let apidata : NSData? = NSData(contentsOfURL: apiURI!)
        
        NSLog("API Result=%@", NSString(data: apidata!, encoding: NSUTF8StringEncoding)!)
        
        do {
            let apiDictionary = try NSJSONSerialization.JSONObjectWithData(apidata!, options: []) as! NSDictionary
            
            let hoppin = apiDictionary["hoppin"] as! NSDictionary
            let movies = hoppin["movies"] as! NSDictionary
            let movie = movies["movie"] as! NSArray
            
            var mvo : MovieVO
            
            for row in movie {
                mvo = MovieVO()
                
                mvo.title = row["title"] as? String
                mvo.description = row["genreNames"] as? String
                mvo.thumbnail = row["thumbnailImage"] as? String
                mvo.detail = row["linkUrl"] as? String
                mvo.rating = (row["ratingAverage"] as? NSString)!.floatValue
                // mvo.thumbnailImage = UIImage(data: NSData(contentsOfURL: NSURL(string: mvo.thumbnail!)!)!)
                
                self.list.append(mvo)
            }
            
            
            let totalCount = (hoppin["totalCount"] as? NSString)!.integerValue
            
            if (self.list.count >= totalCount) {
                self.moreBtn.hidden = true
            }
        } catch {
            NSLog("Parse ERROR!!")
        }

    }
    
    func getThumbnailImage(index : Int) -> UIImage {
        // 인자값으로 받은 인덱스를 기반으로 해당하는 배열 데이터를 읽어옴
        let mvo = self.list[index]
        
        if let savedImage = mvo.thumbnailImage {
            return savedImage
        } else {
            mvo.thumbnailImage = UIImage(data: NSData(contentsOfURL: NSURL(string: mvo.thumbnail!)!)!)
            return mvo.thumbnailImage!
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "segue_detail") {
            // 세그웨이를 실행한 sender 인자값을 이용하여 사용자가 클릭한 행 정보를 얻는다.
            let path = self.movieTable.indexPathForCell(sender as! MovieCell)
            
            // 행 정보를 이용하여 사용자가 선택한 영화 데이터를 찾은 다음,
            // 목적지 뷰 컨트롤러의 mvo 변수에 연결해준다.
            (segue.destinationViewController as? DetailViewController)?.mvo = self.list[path!.row]
        }
    }
}