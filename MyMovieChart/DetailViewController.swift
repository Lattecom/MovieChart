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
    }
    
}