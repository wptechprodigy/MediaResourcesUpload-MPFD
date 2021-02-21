//
//  ViewController.swift
//  MediaResourcesUpload MPFD
//
//  Created by waheedCodes on 20/02/2021.
//

import UIKit

typealias Parameters = [String: String]

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    // MARK: - GET
    
    @IBAction func getImageButtonTapped(_ sender: Any) {
        guard let url = URL(string: Endpoints.getURL) else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print(jsonResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
    
    }
    
    // MARK: - POST
    
    @IBAction func postImageButtonTapped(_ sender: Any) {
        
        let parameters = [
            "name": "testImage000001",
            "description": "Image uploaded using multipart form-data"
        ]
        
        guard let image = UIImage(named: "GuardiansOfTheGalaxy") else {
            return
        }
        
        guard let media = Media(withImage: image, forKey: "image") else {
            return
        }
        
        guard let url = URL(string: Endpoints.postURL) else {
            return
        }
        
        var request = URLRequest(url: url)
        let boundary = generateBoundary()
        
        request.httpMethod = "POST"
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.addValue(API.accessToken, forHTTPHeaderField: "Token")
        request.addValue(API.clientID, forHTTPHeaderField: "Authorization")
        
        let dataBody = createDataBody(withParameters: parameters, media: [media], boundary: boundary)
        request.httpBody = dataBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            
            if let data = data {
                do {
                    let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                    print(jsonResponse)
                } catch {
                    print(error)
                }
            }
        }.resume()
        
    }
    
    // MARK: - Factories
    
    func generateBoundary() -> String {
        return "Boundary-\(NSUUID().uuidString)"
    }
    
    func createDataBody(withParameters parameters: Parameters?, media: [Media]?, boundary: String) -> Data {
        
        let lineBreak = "\r\n"
        var body = Data()
        
        if let parameters = parameters {
            for (key, value) in parameters {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(key)\"\(lineBreak + lineBreak)")
                body.append("\(value + lineBreak)")
            }
        }
        
        if let media = media {
            for photo in media {
                body.append("--\(boundary + lineBreak)")
                body.append("Content-Disposition: form-data; name=\"\(photo.key)\"; filename=\"\(photo.filename)\"\(lineBreak)")
                body.append("Content-Type: \(photo.mimeType + lineBreak + lineBreak)")
                body.append(photo.data)
                body.append(lineBreak)
            }
        }
        
        body.append("--\(boundary)--\(lineBreak)")
        
        return body
    }
    
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
