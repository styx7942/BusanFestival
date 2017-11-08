//
//  ViewController.swift
//  BusanFestival
//
//  Created by 이현호 on 2017. 11. 8..
//  Copyright © 2017년 이현호. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {
    @IBOutlet weak var myMapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        zoomToRegion()
        
        //plist 화일을 프로그램에 가져오기
        let path = Bundle.main.path(forResource: "data", ofType: "plist")
        print("path = \(String(describing: path))")
        
        //이 프로그램에서 ViewPoint3.Plist를 사용하기 위해 복사하기
        let contents = NSArray(contentsOfFile: path!)
        print("contents = \(String(describing: contents))")
        
        
        var annotations = [MKPointAnnotation]()
        
        //optional binding
        if let myItems = contents{
            //Dictionary Array에서 값 뽑기
            for item in myItems{
                let lat = (item as AnyObject).value(forKey: "lat")
                let long = (item as AnyObject).value(forKey: "longi")
                let title = (item as AnyObject).value(forKey: "csNm")
                let subTitle = (item as AnyObject).value(forKey: "cpNm")
                //let img = (item as AnyObject).value(forKey: "img")
                
                let annotation = MKPointAnnotation()
                
                print("lat = \(String(describing: lat))")
                
                let myLat = (lat as! NSString).doubleValue
                let myLong = (long as! NSString).doubleValue
                let myTitle = title as! String
                let mySubTitle = subTitle as! String
                
                print("myLat = \(myLat)")
                
                annotation.coordinate.latitude = myLat
                annotation.coordinate.longitude = myLong
                annotation.title = myTitle
                annotation.subtitle = mySubTitle
                
                annotations.append(annotation)
                
                myMapView.delegate = self
            }
        } else {
            print("contents의 값은 nil")
        }
        
        
        //전체 핀이 지도에 보이도록 함
        myMapView.showAnnotations(annotations, animated: true)
        
        //핀 하나가 자동으로 탭되도록 처리
        myMapView.selectAnnotation(annotations[0], animated: true)
        
        myMapView.addAnnotations(annotations)
        
        
        
        
    }

    
    func zoomToRegion(){
        let center = CLLocationCoordinate2DMake(35.166197, 129.072594)//중심
        let span = MKCoordinateSpanMake(0.05, 0.05)//반경
        let region = MKCoordinateRegion(center: center, span: span)
        
        myMapView.setRegion(region, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let identifier = "MyPin"
        var  annotationView = myMapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView?.canShowCallout = true
            
            if annotation.title! == "부산시민공원" {
                // 부시민공원
                annotationView?.pinTintColor = UIColor.green
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 53, height: 53))
                leftIconView.image = UIImage(named:"citizen_logo.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            } else if annotation.title! == "송상현광장" {
                // 송상현광장
                annotationView?.pinTintColor = UIColor.blue
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                leftIconView.image = UIImage(named:"Songsang.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            } else {
                // 동의과학대학교
                annotationView?.pinTintColor = UIColor.red
                let leftIconView = UIImageView(frame: CGRect(x: 0, y: 0, width: 45, height: 45))
                leftIconView.image = UIImage(named:"DIT_logo.png" )
                annotationView?.leftCalloutAccessoryView = leftIconView
                
            }
        } else {
            annotationView?.annotation = annotation
        }
        
        let btn = UIButton(type: .detailDisclosure)
        annotationView?.rightCalloutAccessoryView = btn
        
        return annotationView
        
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        print("callout Accessory Tapped!")
        
        let viewAnno = view.annotation
        let viewTitle: String = ((viewAnno?.title)!)!
        let viewSubTitle: String = ((viewAnno?.subtitle)!)!
        
        print("\(viewTitle) \(viewSubTitle)")
        
        let ac = UIAlertController(title: viewTitle, message: viewSubTitle, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }

}

