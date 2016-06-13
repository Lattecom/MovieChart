//
//  TheaterListController.swift
//  MyMovieChart
//
//  Created by green on 2016. 6. 13..
//  Copyright © 2016년 lattegreen. All rights reserved.
//

import UIKit

class TheaterListController: UITableViewController {
    
    // API를 통해 불러온 데이터를 저장할 배열 변수
    var list = [NSDictionary]()
    
    // 읽어올 데이터의 시작위치
    var startPoint = 0
    
    // 테이블 뷰에 대한 IBOutlet 변수
    @IBOutlet var theaterTable: UITableView!
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "segue_map") {
            let path = self.theaterTable.indexPathForCell(sender as! UITableViewCell)
            let data = self.list[path!.row]
            
            (segue.destinationViewController as? TheaterViewController)?.param = data
        }
    }
    
    override func viewDidLoad() {
        self.callTheaterAPI()
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.list.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // self.list 배열에서 행에 맞는 데이터를 꺼냄
        let obj = self.list[indexPath.row]
        
        // 재사용 큐로부터 tCell 식별자에 맞는 셀 객체를 전달받음
        let cell = tableView.dequeueReusableCellWithIdentifier("tCell") as! TheaterCell
        
        cell.name?.text = obj["상영관명"] as? String
        cell.tel?.text = obj["연락처"] as? String
        cell.addr.text = obj["소재지도로명주소"] as? String
        
        return cell
    }
    
    func callTheaterAPI() {
        // URL 및 인자값을 위한 변수를 선언
        let apiURL = "http://115.68.183.178:2029/theater/list"
        let sList = 100 // 불러올 데이터 갯수
        let type = "json"   // 데이터 형식
        
        // 인자값들을 요청 URL로 구성하여 NSURL 객체로 생성한다.
        let urlObj = NSURL(string: "\(apiURL)?s_page=\(self.startPoint)&s_list=\(sList)&type=\(type)")
        
        do {
            // NSString 객체를 이용하여 API를 호출하고 그 결과값을 인코딩된 문자열로 받아온다.
            let stringdata = try NSString(contentsOfURL: urlObj!, encoding: 0x80000422)
            
            // 문자열로 받은 데이터를 UTF-8로 인코딩처리한 NSData로 변환한다.
            let encdata = stringdata.dataUsingEncoding(NSUTF8StringEncoding)
            do {
                // NSData 객체를 파싱하여 NSArray 객체로 변환한다.
                let apiArray = try NSJSONSerialization.JSONObjectWithData(encdata!, options: []) as? NSArray
                
                // 읽어온 데이터를 순회하면서 self.list 배열에 추가한다.
                for obj in apiArray! {
                    self.list.append(obj as! NSDictionary)
                }
            } catch {
                // 경고창 형식으로 오류 메시지를 표시해준다.
                let alert = UIAlertController(title: "fail", message: "데이터 분석이 실패하였습니다.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "confirm", style: .Cancel, handler: nil)
                
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: true, completion: nil)
            }
            
            // 읽어와야 할 다음 페이지의 데이터 시작 위치를 구해 저장해둔다.
            self.startPoint += sList
        } catch {
            // 경고창 형식으로 오류 메시지를 표시해준다.
            let alert = UIAlertController(title: "fail", message: "데이터를 불러오는데 실패하였습니다.", preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "confirm", style: .Cancel, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
}
