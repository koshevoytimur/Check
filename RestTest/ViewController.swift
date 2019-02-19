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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    enum Methods: String {
        case get = "GET"
        case post = "POST"
        case patch = "PATCH"
        case delete = "DELETE"
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
            if let response = response {
                print(response)
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
    
    let jsonEx = [
        "user": [
            "email": "some1@mail.com",
            "password": "somepass"
        ]
    ]
    
    @IBAction func loginButtonAction(_ sender: Any) {
        fetch(url: "http://192.168.0.103:3000/sign_in", method: .post, data: jsonEx, callback: {(data: Any) -> Void in
                print(data)
                })
    }
    
}
