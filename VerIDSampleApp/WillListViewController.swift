//
//  WillListViewController.swift
//  VerIDSampleApp
//
//  Created by REO HARADA
//

import UIKit
import VerIDCore

class WillListViewController: UIViewController {

    @IBOutlet weak var willListTableView: UITableView!
    
    var faces = [Recognizable]()
    var willKey = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initSet()
    }
    
    fileprivate func initSet() {
        willKey = [String]()
        if let mapAndFilterData = (faces.map { UserDefaults.standard.object(forKey: $0.recognitionData.base64EncodedString()) }.filter{ $0 != nil }) as? [String] {
            mapAndFilterData.forEach { if !willKey.contains($0) { willKey.append($0) } }
        }
        willListTableView.reloadData()
    }

}

extension WillListViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return willKey.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let keys = willKey[indexPath.row].components(separatedBy: "_")
        cell.textLabel?.text = "\(keys[1]) へ"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "WillViewController") as! WillViewController
        vc.key = willKey[indexPath.row]
        navigationController?.show(vc, sender: nil)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let userDefaults = UserDefaults.standard
        userDefaults.removeObject(forKey: willKey[indexPath.row])
        userDefaults.synchronize()
        faces.forEach { if userDefaults.object(forKey: $0.recognitionData.base64EncodedString()) as! String == willKey[indexPath.row] { userDefaults.removeObject(forKey: $0.recognitionData.base64EncodedString()) } }
        initSet()
        tableView.reloadData()
    }
}
