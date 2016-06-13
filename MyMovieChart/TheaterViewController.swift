//
//  TheaterViewController.swift
//  MyMovieChart
//
//  Created by green on 2016. 6. 13..
//  Copyright © 2016년 lattegreen. All rights reserved.
//

import UIKit
import MapKit

class TheaterViewController : UIViewController {
    var param : NSDictionary?
    
    @IBOutlet var map: MKMapView!
    
    @IBOutlet var navibar: UINavigationItem!
    
    override func viewDidLoad() {
        navibar.title = param?["상영관명"] as? String
        
        let lat = (param?["위도"] as! NSString).doubleValue
        let lng = (param?["경도"] as! NSString).doubleValue
        
        // 위도와 경도를 인수로 하는 2D 위치 정보 객체 정의
        let location = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        // 지도에 표현될 거리: 값의 단위는 m
        let regionRadius: CLLocationDistance = 100
        
        // 거리를 반영한 지역 정보를 조합한 지도 데이터를 생성
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location, regionRadius, regionRadius)
        
        // map 변수에 연결된 지도 객체에 데이터를 전달하여 화면에 표시
        self.map.setRegion(coordinateRegion, animated: true)
        
        // 위치를 표시해줄 객체를 생성하고, 앞에서 작성해준 위치값 객체를 할당
        let point = MKPointAnnotation()
        point.coordinate = location
        
        self.map.addAnnotation(point)
    }
}
