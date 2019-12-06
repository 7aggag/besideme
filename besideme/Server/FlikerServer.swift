//
//  FlikerServer.swift
//  besideme
//
//  Created by mohamed haggag on 12/6/19.
//  Copyright © 2019 mohamed haggag. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage


class FlikerServes{
    
    
static let  instance = FlikerServes()
    var imagesurl = [String]()
    var imagearray = [UIImage]()
    
    
    func flikerurl(Apikey : String , lat : String , lon : String , pages : Int )-> String {
        	
        return "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(Apikey)&lat=\(lat)&lon=\(lon)&radius=1&radius_units=mi&per_page=\(pages)&format=json&nojsoncallback=1"
        
    }
    
    func getimageurl(imgurl : URL , complection:@escaping CompletionHandelar){
        imagesurl=[]
        Alamofire.request(imgurl).responseJSON { (response) in
            if response.result.error == nil {
                guard let json = response.result.value as? Dictionary<String,AnyObject> else {return}
                let photos = json["photos"] as? Dictionary<String,AnyObject>
                let photo = photos!["photo"] as? [Dictionary<String,AnyObject>]
                for pho in photo! {
                    let url = "https://farm\(pho["farm"]!).staticflickr.com/\(pho["server"]!)/\(pho["id"]!)_\(pho["secret"]!).jpg"
                    self.imagesurl.append(url)
                      complection(true)
                }
            }
        }
        
    }
    
    
    func retriveimage(complet:@escaping CompletionHandelar){
        imagearray=[]
        
        for url in imagesurl {
            Alamofire.request(url).responseImage { (response) in
                if response.result.error == nil{
                    guard let image = response.result.value else {return}
                    self.imagearray.append(image)
                    if self.imagearray.count == self.imagesurl.count {
                        complet(true)
                    }
                }
            }
            
        }
        
    }
    
    
    
    func cancelallseion(){
        Alamofire.SessionManager.default.session.getTasksWithCompletionHandler { (sessiontask, uploadeddata, downladdata) in
            sessiontask.forEach({$0.cancel()})
            downladdata.forEach({$0.cancel()})
            
        }
    }
}

