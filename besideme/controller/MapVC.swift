//
//  ViewController.swift
//  besideme
//
//  Created by mohamed haggag on 11/28/19.
//  Copyright © 2019 mohamed haggag. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MapVC: UIViewController {

    //iboutlets
    
    @IBOutlet weak var pinview : UIView!
    
    @IBOutlet weak var pullupviewheight: NSLayoutConstraint!
    @IBOutlet weak var mapview: MKMapView!
    
    
    
    var locationmanger = CLLocationManager()
    var authorize = CLLocationManager.authorizationStatus()
    var yourlocation : CLLocation?
    let anno = MKPointAnnotation()
    var scewwnsieze = UIScreen.main.bounds
    var spinner :UIActivityIndicatorView?
    var progresslabel:UILabel?
    var flowlayout = UICollectionViewFlowLayout()
    var collection:UICollectionView?
    
    
    override func viewDidLoad() {
        
        mapview.delegate=self
        locationmanger.delegate=self
        self.locationmanger.requestAlwaysAuthorization()
        locationmanger.delegate = self
        locationmanger.desiredAccuracy = kCLLocationAccuracyBest
        locationmanger.startUpdatingLocation()
        super.viewDidLoad()
        adddoubletap()
        
        
        collection = UICollectionView(frame: view.bounds, collectionViewLayout: flowlayout)
        collection?.register(collectioncell.self, forCellWithReuseIdentifier: "collectioncell")
        collection?.dataSource=self
        collection?.delegate=self
        collection?.backgroundColor=#colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        pinview.addSubview(collection!)
    }
    
    func adddoubletap (){
        let doubletap = UITapGestureRecognizer(target: self, action: #selector(droppin(sender:)))
        doubletap.numberOfTapsRequired = 2
        mapview.addGestureRecognizer(doubletap)
    }
    
    @objc func droppin (sender : UITapGestureRecognizer){
        deleteannotions()
        removespinner()
        removelb()
        FlikerServes.instance.cancelallseion()

        
        
        animateingpullview()
        addswap()
        addspinner()
        addprogresslabel()
        let touchpoint = sender.location(in: mapview)
        let cordinate = mapview.convert(touchpoint, toCoordinateFrom: mapview)
        anno.coordinate=cordinate
        mapview.addAnnotation(anno)
        let region = MKCoordinateRegion(center: cordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        self.mapview.setRegion(region, animated: true)
    
     let url = URL(string:FlikerServes.instance.flikerurl(Apikey: API_KEY, lat:"\(anno.coordinate.latitude)", lon: "\(anno.coordinate.longitude)", pages: 40) )
        
        FlikerServes.instance.getimageurl(imgurl: url!) { (scuss) in
            if scuss{
                self.progresslabel?.text = "\(FlikerServes.instance.imagearray.count)  loadeding "
                FlikerServes.instance.retriveimage(complet: { (scuss) in
                    if scuss {
                        print(FlikerServes.instance.imagearray.count)
                        self.removespinner()
                        self.removelb()
                    }
                })
            }
        }
        
    }
    
    func animateingpullview(){
        pullupviewheight.constant = 300
       UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
    }
    
    func addspinner(){
        spinner = UIActivityIndicatorView()
        spinner?.center=CGPoint(x: (scewwnsieze.width/2)-((spinner?.frame.width)!/2), y: 150)
        spinner?.style = .whiteLarge
        spinner?.color = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
        spinner?.startAnimating()
        collection?.addSubview(spinner!)
    }
    
    func removespinner(){
        if spinner != nil {
            spinner?.stopAnimating()
            spinner?.removeFromSuperview()
        }}
    
    func addswap(){
        let swap = UISwipeGestureRecognizer(target: self, action: #selector(dismisspinview))
        swap.direction = .down
        pinview.addGestureRecognizer(swap)
    }
    
    
    @objc func dismisspinview(){
        pullupviewheight.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
            FlikerServes.instance.cancelallseion()

        }
    }
    func deleteannotions(){
        mapview.removeAnnotation(anno)
    }

    @IBAction func centermapbtnpress(_ sender: Any) {
        if authorize == .authorizedWhenInUse||authorize == .authorizedAlways {
			
            guard let coor = yourlocation?.coordinate else {return}
            let rigion = MKCoordinateRegion(center: coor, latitudinalMeters: 200, longitudinalMeters: 200)
            mapview.setRegion(rigion, animated: true)
            
        }
        
    }
    
    func addprogresslabel(){
        
        progresslabel=UILabel()
        progresslabel?.frame=CGRect(x: (scewwnsieze.width/2)-100, y: 175, width: 200, height: 40)
        progresslabel?.textColor=#colorLiteral(red: 0.9647058824, green: 0.6509803922, blue: 0.137254902, alpha: 1)
      
        progresslabel?.textAlignment = .center
        collection?.addSubview(progresslabel!)
    }
    
    func removelb(){
        if progresslabel != nil {
            progresslabel?.removeFromSuperview()
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}

extension MapVC :MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let pinannotion = MKPinAnnotationView(annotation: anno, reuseIdentifier:"droppin")
        pinannotion.pinTintColor=#colorLiteral(red: 0.9647058824, green: 0.6509803922, blue: 0.137254902, alpha: 1)
        pinannotion.animatesDrop=true
        return pinannotion
    }
    
}
extension MapVC :CLLocationManagerDelegate{

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let location = locations.last{
            yourlocation=location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapview.setRegion(region, animated: true)
            let anno = MKPointAnnotation()
            anno.coordinate =  center
            mapview.addAnnotation(anno)
        
    }
}}

extension MapVC :UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectioncell", for: indexPath) as? collectioncell
        return cell!

    }
    
}


