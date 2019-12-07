//
//  POPVC.swift
//  besideme
//
//  Created by mohamed haggag on 12/6/19.
//  Copyright © 2019 mohamed haggag. All rights reserved.


import UIKit

class POPVC: UIViewController,UIGestureRecognizerDelegate {
    @IBOutlet weak var popimag:UIImageView!
    var popimge:UIImage?
    
    func imginit(forimage image : UIImage){
        self.popimge=image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        popimag.image = popimge
        doubletap()
    }
    
    
    func doubletap(){
        
        let doubletap = UITapGestureRecognizer(target: self, action: #selector(screenswap))
        doubletap.numberOfTapsRequired=2
        doubletap.delegate = self
       view.addGestureRecognizer(doubletap)
    }
    
    @objc func screenswap(){
    dismiss(animated: true, completion: nil)
    }

}
