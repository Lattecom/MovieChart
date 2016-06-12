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
        let req = NSURLRequest(URL: NSURL(string: (self.mvo?.detail)!)!)
        self.wv.loadRequest(req)
    }
    
}