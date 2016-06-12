//
//  DetailViewController.swift
//  MyMovieChart
//
//  Created by green on 2016. 6. 13..
//  Copyright © 2016년 lattegreen. All rights reserved.
//

import UIKit

class DetailViewController : UIViewController {
    
    @IBOutlet var navibar: UINavigationItem!
    
    @IBOutlet var wv: UIWebView!
    
    // 목록에서 넘겨주는 영화 데이터를 받을 변수
    var mvo : MovieVO? = nil
    
    override func viewDidLoad() {
        NSLog("linkurl = \(self.mvo?.detail), title = \(self.mvo?.title)")
        
        // 내비게이션 바의 타이틀에 영화명을 출력을해준다.
        self.navibar.title = self.mvo?.title
        
        // detail을 이용하여 NSURLRequest 객체를 만들고 loadRequest 메소드를 호출한다. 로드가 끝나면 웹뷰에 웹 페이지가 출력된다.
//        let req = NSURLRequest(URL: NSURL(string: (self.mvo?.detail)!)!)
//        self.wv.loadRequest(req)
        
        if let url = self.mvo?.detail {
            if let urlObj = NSURL(string: url) {
                let req = NSURLRequest(URL: urlObj)
                self.wv.loadRequest(req)
            } else {    // URL 형식이 잘못되었을 경우에 대한 예외처리
                
                // 경고창 형식으로 오류 메세지를 표시해준다.
                let alert = UIAlertController(title: "오류", message: "잘못된 URL입니다.", preferredStyle: .Alert)
                let cancelAction = UIAlertAction(title: "확인", style: .Cancel) {
                    (_) in
                    self.navigationController?.popViewControllerAnimated(true)
                }
                
                alert.addAction(cancelAction)
                self.presentViewController(alert, animated: false, completion: nil)
            }
        } else {    // URL 값이 전달되지 않았을 경우에 대한 예외처리
            
            // 경고창 형식으로 오류 메세지를 표시해준다.
            let alert = UIAlertController(title: "오류", message: "필수 파라미터가 누락되었습니다.", preferredStyle: .Alert)
            let cancelAction = UIAlertAction(title: "확인", style: .Cancel) {
                (_) in
                self.navigationController?.popViewControllerAnimated(true)
            }
            
            alert.addAction(cancelAction)
            self.presentViewController(alert, animated: true, completion: nil)
        }
        
    }
    
}