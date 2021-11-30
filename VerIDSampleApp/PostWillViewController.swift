//
//  PostWillViewController.swift
//  VerIDSampleApp
//
//  Created by REO HARADA
//

import UIKit
import VerIDCore
import CryptoKit

class PostWillViewController: UIViewController {
    
    @IBOutlet weak var addressTextField: UITextField!
    @IBOutlet weak var willTextView: UITextView!
    
    var faces = [RecognizableFace]()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func tapRegistButton(_ sender: Any) {
        if addressTextField.text == "" { return showAlert("エラー", "宛名が記載されていません", nil) }
        if willTextView.text == "" { return showAlert("エラー", "遺言が記載されていません", nil) }
        guard let address = addressTextField.text else { return showAlert("エラー", "宛名が記載されていません", nil) }
        guard let will = willTextView.text else { return showAlert("エラー", "遺言が記載されていません", nil) }
        let recognitionData = faces.map { $0.recognitionData.base64EncodedString() }
        let userDefaults = UserDefaults.standard
        let key = "\(Date().timeIntervalSince1970)_\(address)"
        recognitionData.forEach {
            userDefaults.set(key, forKey: $0)
        }
        userDefaults.set(will, forKey: key)
        userDefaults.synchronize()
        showAlert("成功", "遺言が保存されました。顔認証して、内容を確認してください。") {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    fileprivate func showAlert(_ title: String, _ message: String, _ handler: (() -> Void)?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let button = UIAlertAction(title: "OK", style: .default) { alert in
            guard let h = handler else { return }
            h()
        }
        alert.addAction(button)
        present(alert, animated: true, completion: nil)
    }
}
