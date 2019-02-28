//
//  ViewController.swift
//  RestTest
//
//  Created by Тимур Кошевой on 2/19/19.
//  Copyright © 2019 Тимур Кошевой. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!

    let API_URL: String = "https://jsonplaceholder.typicode.com"
    let alert = AlertView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func fetch(url: String, method: Methods, data: [String: Any] = ["0": "0"], callback: @escaping (_ data: Any) -> ()) {
        guard let url = URL(string: url) else { return }
        
        var request = URLRequest(url: url)
        
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpMethod = method.rawValue
        
        print(method.rawValue)
        
        if (method != .get) {
            let jsonData = try! JSONSerialization.data(withJSONObject: data, options: [])
            request.httpBody = jsonData
        }
        
        let session = URLSession.shared
        
        session.dataTask(with: request) { (data, response, error) in
            if let response = response as? HTTPURLResponse {
                self.alert.showAlert(view: self, title: "Status Code", message: "\(response.statusCode)")
            }
            
            guard let data = data else { return }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                callback(json)
            } catch {
                print(error)
            }
            
            }.resume()
    }
    
    let jsonEx: [String : Any] = [
        "title": "some title",
        "body": "some body",
        "userId": 1234
    ]
    
    @IBAction func loginButtonAction(_ sender: Any) {
        fetch(url: (API_URL + "/posts") , method: .post, data: jsonEx, callback: {(data: Any) -> Void in
            print(data)
        })
    }
    
    @IBAction func listingResourcesBtn(_ sender: Any) {
        fetch(url: (API_URL + "/posts"), method: .get, callback: {(data: Any) -> Void in
            print(data)
        })
    }
    
}
