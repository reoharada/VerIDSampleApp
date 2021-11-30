//
//  WillViewController.swift
//  VerIDSampleApp
//
//  Created by REO HARADA
//

import UIKit

class WillViewController: UIViewController {
    
    var key = ""
    @IBOutlet weak var willTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let willMessage = UserDefaults.standard.object(forKey: key) as! String
        willTextView.text = willMessage
    }
    
}
