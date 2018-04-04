//
//  WebService.swift
//  FYPv4
//
//  Created by Ben Kovacs on 2018-01-24.
//  Copyright © 2018 BenKovacs. All rights reserved.
//

import Foundation
import UIKit

final class WebService {
    
    private let session = URLSession(configuration: URLSessionConfiguration.ephemeral)
    
    func load<A>(_ resource: Resource<A>, completion: @escaping (Result<A>?) -> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        session.dataTask(with: resource.request) { (data, _, _) in
            
            let result = data.flatMap(resource.parse)
//            self.printData(data)
        DispatchQueue.main.async {
             completion(Result(result, or: "Couldn't Parse data"))
             UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
       }.resume()
        
    }
    
    private func printData(_ data: Data?) {
        if let _data = data {
            let json = try? JSONSerialization.jsonObject(with: _data, options: [])
            print(json ?? "json conversion didnt work")
        }
    }
    
    func postImage(image: UIImage, forWorkoutID: String, completion: @escaping (Data?) -> ()) {
        let scaled = image.resize(to: 200)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let imageData = UIImageJPEGRepresentation(scaled! , 1.0)
        guard let url = URL(string: "http://192.168.2.11:8080/image") else {return}
        let session = URLSession(configuration: .default)
        var mutableURLRequest = URLRequest(url: url)
        mutableURLRequest.httpMethod = "POST"
        
        let boundaryConstant = "----------------12345";
        let contentType = "multipart/form-data;boundary=" + boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        var uploadData = Data()
        
        // add image
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"image\"; filename=\"workoutImage|\(forWorkoutID)\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData!)
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        mutableURLRequest.httpBody = uploadData
        
        let task = session.dataTask(with: mutableURLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            completion(data)
        })
        task.resume()
    }
    
    func postProfileImage(image: UIImage, forUserID: String, completion: @escaping (Data?) -> ()) {
        let scaled = image.resize(to: 200)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let imageData = UIImageJPEGRepresentation(scaled!, 1.0)
        guard let url = URL(string: "http://192.168.2.11:8080/profileImage") else {return}
        let session = URLSession(configuration: .default)
        var mutableURLRequest = URLRequest(url: url)
        mutableURLRequest.httpMethod = "POST"
        
        let boundaryConstant = "----------------12345";
        let contentType = "multipart/form-data;boundary=" + boundaryConstant
        mutableURLRequest.setValue(contentType, forHTTPHeaderField: "Content-Type")
        
        // create upload data to send
        var uploadData = Data()
        
        // add image
        uploadData.append("\r\n--\(boundaryConstant)\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Disposition: form-data; name=\"image\"; filename=\"profileImage|\(forUserID)\"\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append("Content-Type: image/png\r\n\r\n".data(using: String.Encoding.utf8)!)
        uploadData.append(imageData!)
        uploadData.append("\r\n--\(boundaryConstant)--\r\n".data(using: String.Encoding.utf8)!)
        
        mutableURLRequest.httpBody = uploadData
        
        let task = session.dataTask(with: mutableURLRequest, completionHandler: { (data, response, error) -> Void in
            DispatchQueue.main.async { UIApplication.shared.isNetworkActivityIndicatorVisible = false }
            completion(data)
        })
        task.resume()
    }
}
