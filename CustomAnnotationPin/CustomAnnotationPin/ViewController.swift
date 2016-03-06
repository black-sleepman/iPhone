//
//  ViewController.swift
//  CustomAnnotationPin
//
//  Created by nomunomu on 2016/03/05.
//  Copyright © 2016年 nomunomu. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

/* カスタムピンに持たせるデータ群 */
class CustomAnnotation: MKPointAnnotation {
    
    var string: String!
}

class ViewController: UIViewController, MKMapViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    var locationManager = CLLocationManager()
    var region: MKCoordinateRegion!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.mapView.delegate = self
        self.mapView.userTrackingMode = .Follow
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(36.0665693, 136.2173733), animated: true)
        
        /* 縮尺を設定 */
        self.region = self.mapView.region
        
        /* 0.15 : 16.8km */
        self.region.span.latitudeDelta = 0.15
        self.region.span.longitudeDelta = 0.15
        self.mapView.setRegion(self.region, animated:false)
        
        /* 表示タイプを航空写真と地図のハイブリッドに設定 */
        self.mapView.mapType = MKMapType.Standard
        
        let Annotation = CustomAnnotation()
        Annotation.coordinate = CLLocationCoordinate2DMake(36.0665693, 136.2173733)
        Annotation.title = "ここにタイトルが入ります"
        Annotation.subtitle = "ここにサブタイトルが入ります"
        Annotation.string = "各Pinに個別のデータを持たせることができます"
        
        self.mapView.addAnnotation(Annotation)
        
        /* locationManageの設定 */
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.delegate = self
        
        /* 位置情報のアクセス許可の状況に応じて、アクセス許可の取得、位置情報取得の開始を行う */
        let status = CLLocationManager.authorizationStatus()
        
        /* iOS8ではアクセス許可のリクエストをする。iOS7では位置情報取得処理を開始することでアクセス許可のリクエストをする */
        if self.locationManager.respondsToSelector("requestWhenInUseAuthorization") {
            self.locationManager.requestWhenInUseAuthorization()
        }
        
        switch status {
            
        case .Restricted, .Denied: break
        case .NotDetermined: break
        case .AuthorizedWhenInUse, .AuthorizedAlways: break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /* addAnnotationを実行することにより呼ばれる */
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        /* 現在地を表すマーカーならばそのままに */
        if annotation is MKUserLocation { return nil }
        
        /* カスタマイズするピンの識別子 */
        let reuseId: String! = "custom"
        
        /* すでに識別子のピンがカスタマイズされているか */
        if let annotationView = mapView.dequeueReusableAnnotationViewWithIdentifier( reuseId ) {
            
            /* されていればそのまま利用する */
            return annotationView
        }
        else {
            
            /*
            されていなければピンをカスタマイズする
            MKPinAnnotationView ではピンの色などを変更できる。
            ピンに任意の画像を使いたい場合は MKAnnotation を利用します。
            
            let annotationView = MKAnnotationView( annotation: annotation, reuseIdentifier: reuseId )
            
            /* ポップアップにボタンなどを表示させるか */
            annotationView.canShowCallout = true
            
            /* 表示させるボタンの種類と場所 */
            /* annotationView.leftCalloutAccessoryView = UIButton(type: .InfoLight) */
            annotationView.rightCalloutAccessoryView = UIButton(type: .InfoLight)
            
            /* カスタマイズしたピンのAnnotationは元のAnnotationを使用 */
            annotationView.annotation = annotation
            
            /* ピンの画像を任意のものに変更する */
            annotationView.image = UIImage(named: "pinImage");
            */
            
            let annotationView = MKPinAnnotationView( annotation: annotation, reuseIdentifier: reuseId )
            
            /* ポップアップにボタンなどを表示させるか */
            annotationView.canShowCallout = true
            
            /* 表示させるボタンの種類と場所 */
            /* annotationView.leftCalloutAccessoryView = UIButton(type: .InfoLight) */
            annotationView.rightCalloutAccessoryView = UIButton(type: .InfoLight)
            
            /* カスタマイズしたピンのAnnotationは元のAnnotationを使用 */
            annotationView.annotation = annotation
            
            /* ピンの色を指定 */
            annotationView.pinTintColor = UIColor.purpleColor()
            
            return annotationView
        }
    }
    
    /* Click on left or right button */
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        /* 押されたピンがもつ個別のデータを取得 */
        let string = (view.annotation as! CustomAnnotation).string
        
        /* 押されたボタンが右側のボタン */
        if (control == view.rightCalloutAccessoryView) {
            
            /*
            * iOSのバージョンによって使われるAlertが異なる
            * 詳しくは「SwiftでUIAlertController(iOS8以降)とUIAlertView(iOS7以前)を使い分ける」
            * http://qiita.com/osamu1203/items/f1aea7b932e69522f638 まで
            */
            if objc_getClass("UIAlertController") != nil {
                
                /* UIAlertController使用 */
                let ac = UIAlertController(title: "CustomAnnotation_string", message: string, preferredStyle: .Alert)
                
                /* キャンセルボタンとコールバック関数の設定 */
                let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) -> Void in
                    print("Cancel button tapped.")
                }
                
                /* OKボタンとコールバック関数の設定 */
                let okAction = UIAlertAction(title: "OK", style: .Default) { (action) -> Void in
                    print("OK button tapped.")
                }
                
                /* それぞれのボタンを追加する */
                ac.addAction(cancelAction)
                ac.addAction(okAction)
                
                /* Alertを表示する */
                presentViewController(ac, animated: true, completion: nil)
                
            }
            else {
                
                /* UIAlertView使用 */
                UIAlertView(
                    title: "CustomAnnotationのstring",
                    message: string,
                    delegate: self,
                    cancelButtonTitle: "Cancel",
                    otherButtonTitles: "OK"
                ).show()
            }
        }
    }
    
    /* UIAlertViewのボタンがクリックされた時のコールバック関数 */
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int) {
        
        /* キャンセルボタンがクリックされたとき */
        if (buttonIndex == alertView.cancelButtonIndex) {
            print("Cancel button tapped.")
        }
        /* OKボタンがクリックされたとき */
        else {
           print("OK button tapped.")
        }
    }
    
    /* 位置情報のアクセス許可の状況が変わったときの処理 */
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        switch status{
            case .Restricted:
                print("Error: It is restricted by settings.")
            case .Denied:
                print("Error: It is denied Location Service.")
                manager.stopUpdatingLocation()
            case .AuthorizedWhenInUse, .AuthorizedAlways:
                manager.startUpdatingLocation()
            case .NotDetermined:
                self.locationManager.requestAlwaysAuthorization()
        }
    }
    
    /* 位置情報取得成功時に実行される関数 */
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        /* 現在地のピンを作成する */
        let Annotation = CustomAnnotation()
        Annotation.coordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        Annotation.title = String(newLocation.coordinate.latitude, newLocation.coordinate.longitude)
        Annotation.subtitle = String(newLocation.timestamp)
        Annotation.string = newLocation.description
        
        /* Mapにピンを立てる */
        self.mapView.addAnnotation(Annotation)
        
        /* 現在地をマップの中心とする */
        self.mapView.setCenterCoordinate(CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude), animated: false)
        
        /* GPSの使用を停止する．停止しない限りGPSは実行され，指定間隔で更新され続ける．*/
        //        locationManager.stopUpdatingLocation()
    }
    
}

