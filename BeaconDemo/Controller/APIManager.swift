//
//  APIManager.swift
//  KBeaconDemo_Ios
//
//  Created by Senarios on 21/02/2022.
//  Copyright © 2022 hogen. All rights reserved.
//

import Foundation
import Alamofire


struct APIManager{
    
    let url : String
    let parameters : [String:String]?
    let session = URLSession.shared
    
    
    init(url : String,parameters : [String:String]? = nil){
        self.url = url
        self.parameters = parameters
    }
    
    public func getRequest(completion : @escaping (Result<[String:Any],APIError>) -> Void){
        print("url is",url)
      //  print("parameters are",parameters)
        let APIKEY = UserDefaults.standard.string(forKey: "TOKEN")
        print("APIKEY: \(APIKEY!)")
//        guard
            let url = URL(string: self.url)
//            let parameters = self.parameters else{
//                print("Fail to get the appropriate url & parameters")
//                completion(.failure(.urlInvalid))
//                return
//            }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        if(APIKEY != nil){
            request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
        }
        else
        {
            request.setValue(APIs.distributer_API_Key, forHTTPHeaderField: "apiKey")
        }
      //  request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
       // request.setValue("78408836-f4a2-41fe-a39e-4b32f8c97b2f", forHTTPHeaderField: "apiKey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
//        guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
//            print("fail to get the data fromparams")
//            completion(.failure(.dataCorrupt))
//            return
//        }
       // request.httpBody = data
        
        print("data task hit")
        session.dataTask(with: request) { data, response, error in
            print("come in response")
           guard
            let httpResponse = response as? HTTPURLResponse else{
                return
            }
            let code = httpResponse.statusCode
            
            
            if (200...299) ~= code{
                
                print("code is",code)
                
            }else{
                print("code is",code)
                completion(.failure(.inavlidStausCode(code)))
                return
            }
        
            
            if error != nil{
                print("error is not nil so return",error?.localizedDescription)
                completion(.failure(.failure(error?.localizedDescription ?? "Error description not found")))
            }
            
            guard let data = data else {
                print("fail to get the data data is in corrupt form")
                completion(.failure(.dataCorrupt))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [String:Any]{
                    completion(.success(json))
                }else{
                    completion(.failure(.jsonSerilizationError))
                }
                
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(.jsonSerilizationError))
            }
            
        }.resume()
    }
    
    public func getRequestArray(completion : @escaping (Result<[Any],APIError>) -> Void){
        print("url is",url)
      //  print("parameters are",parameters)
        let APIKEY = UserDefaults.standard.string(forKey: "TOKEN")
        print("APIKEY: \(APIKEY!)")
//        guard
            let url = URL(string: self.url)
//            let parameters = self.parameters else{
//                print("Fail to get the appropriate url & parameters")
//                completion(.failure(.urlInvalid))
//                return
//            }
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        
        if(APIKEY != nil){
            request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
        }
        else
        {
            request.setValue(APIs.distributer_API_Key, forHTTPHeaderField: "apiKey")
        }
      //  request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
       // request.setValue("78408836-f4a2-41fe-a39e-4b32f8c97b2f", forHTTPHeaderField: "apiKey")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
//        guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
//            print("fail to get the data fromparams")
//            completion(.failure(.dataCorrupt))
//            return
//        }
       // request.httpBody = data
        
        print("data task hit")
        session.dataTask(with: request) { data, response, error in
            print("come in response")
           guard
            let httpResponse = response as? HTTPURLResponse else{
                return
            }
            let code = httpResponse.statusCode
            
            
            if (200...299) ~= code{
                
                print("code is",code)
                
            }else{
                print("code is",code)
                completion(.failure(.inavlidStausCode(code)))
                return
            }
        
            
            if error != nil{
                print("error is not nil so return",error?.localizedDescription)
                completion(.failure(.failure(error?.localizedDescription ?? "Error description not found")))
            }
            
            guard let data = data else {
                print("fail to get the data data is in corrupt form")
                completion(.failure(.dataCorrupt))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [Any]{
                    completion(.success(json))
                }else{
                    completion(.failure(.jsonSerilizationError))
                }
                
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(.jsonSerilizationError))
            }
            
        }.resume()
    }
    
    public func postRequest(completion : @escaping (Result<[String:Any],APIError>) -> Void){
        print("url is",url)
        print("parameters are",parameters)
        let APIKEY = UserDefaults.standard.string(forKey: "TOKEN")
        if(APIKEY != nil){
            print("APIKEY:", APIKEY!)
        }
        
    //    guard
            let url = URL(string: self.url)
            let parameters = self.parameters
//            let parameters = self.parameters else{
//                print("Fail to get the appropriate url & parameters")
//                completion(.failure(.urlInvalid))
//                return
//            }
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
       // request.setValue("78408836-f4a2-41fe-a39e-4b32f8c97b2f", forHTTPHeaderField: "apiKey")
        if(APIKEY != nil){
            request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
        }
        else
        {
            request.setValue(APIs.distributer_API_Key, forHTTPHeaderField: "apiKey")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        
        guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
            print("fail to get the data fromparams")
            completion(.failure(.dataCorrupt))
            return
        }
        request.httpBody = data
        
        print("data task hit")
        session.dataTask(with: request) { data, response, error in
            print("come in response")
           guard
            let httpResponse = response as? HTTPURLResponse else{
                return
            }
            let code = httpResponse.statusCode
            
            
            if (200...299) ~= code{
                
                print("code is",code)
                
            }else{
                print("code is",code)
                completion(.failure(.inavlidStausCode(code)))
                return
            }
        
            
            if error != nil{
                print("error is not nil so return",error?.localizedDescription)
                completion(.failure(.failure(error?.localizedDescription ?? "Error description not found")))
            }
            
            guard let data = data else {
                print("fail to get the data data is in corrupt form")
                completion(.failure(.dataCorrupt))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [String:Any]{
                    completion(.success(json))
                }else{
                    completion(.failure(.jsonSerilizationError))
                }
                
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(.jsonSerilizationError))
            }
            
        }.resume()
    }
    
    public func putRequest(completion : @escaping (Result<[String:Any],APIError>) -> Void){
        print("url is",url)
        print("parameters are",parameters)
        let APIKEY = UserDefaults.standard.string(forKey: "TOKEN")
        
     //   guard
            let url = URL(string: self.url)
            let parameters = self.parameters
//            let parameters = self.parameters else{
//                print("Fail to get the appropriate url & parameters")
//                completion(.failure(.urlInvalid))
//                return
//            }
        var request = URLRequest(url: url!)
        request.httpMethod = "PUT"
       // request.setValue("78408836-f4a2-41fe-a39e-4b32f8c97b2f", forHTTPHeaderField: "apiKey")
        if(APIKEY != nil){
            request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
        }
        else
        {
            request.setValue(APIs.distributer_API_Key, forHTTPHeaderField: "apiKey")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
   
        
        
        guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
            print("fail to get the data fromparams")
            completion(.failure(.dataCorrupt))
            return
        }
        request.httpBody = data
        
        print("data task hit")
        session.dataTask(with: request) { data, response, error in
            print("come in response")
           guard
            let httpResponse = response as? HTTPURLResponse else{
                return
            }
            let code = httpResponse.statusCode
            
            
            if (200...299) ~= code{
                
                print("code is",code)
                
            }else{
                print("code is",code)
                completion(.failure(.inavlidStausCode(code)))
                return
            }
        
            
            if error != nil{
                print("error is not nil so return",error?.localizedDescription)
                completion(.failure(.failure(error?.localizedDescription ?? "Error description not found")))
            }
            
            guard let data = data else {
                print("fail to get the data data is in corrupt form")
                completion(.failure(.dataCorrupt))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [String:Any]{
                    completion(.success(json))
                }else{
                    completion(.failure(.jsonSerilizationError))
                }
                
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(.jsonSerilizationError))
            }
            
        }.resume()
    }
    
    public func deleteRequest(completion : @escaping (Result<[String:Any],APIError>) -> Void){
        print("url is",url)
        print("parameters are",parameters)
        let APIKEY = UserDefaults.standard.string(forKey: "TOKEN")
        
     //   guard
            let url = URL(string: self.url)
            let parameters = self.parameters
//            let parameters = self.parameters else{
//                print("Fail to get the appropriate url & parameters")
//                completion(.failure(.urlInvalid))
//                return
//            }
        var request = URLRequest(url: url!)
        request.httpMethod = "DELETE"
       // request.setValue("78408836-f4a2-41fe-a39e-4b32f8c97b2f", forHTTPHeaderField: "apiKey")
        if(APIKEY != nil){
            request.setValue(APIKEY!, forHTTPHeaderField: "apiKey")
        }
        else
        {
            request.setValue(APIs.distributer_API_Key, forHTTPHeaderField: "apiKey")
        }
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
   
        
        
        guard let data = try? JSONSerialization.data(withJSONObject: parameters, options: []) else{
            print("fail to get the data fromparams")
            completion(.failure(.dataCorrupt))
            return
        }
        request.httpBody = data
        
        print("data task hit")
        session.dataTask(with: request) { data, response, error in
            print("come in response")
           guard
            let httpResponse = response as? HTTPURLResponse else{
                return
            }
            let code = httpResponse.statusCode
            
            
            if (200...299) ~= code{
                
                print("code is",code)
                
            }else{
                print("code is",code)
                completion(.failure(.inavlidStausCode(code)))
                return
            }
        
            
            if error != nil{
                print("error is not nil so return",error?.localizedDescription)
                completion(.failure(.failure(error?.localizedDescription ?? "Error description not found")))
            }
            
            guard let data = data else {
                print("fail to get the data data is in corrupt form")
                completion(.failure(.dataCorrupt))
                return
            }
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                
                if let json = json as? [String:Any]{
                    completion(.success(json))
                }else{
                    completion(.failure(.jsonSerilizationError))
                }
                
            } catch(let error) {
                print(error.localizedDescription)
                completion(.failure(.jsonSerilizationError))
            }
            
        }.resume()
    }
    
    
    
    func post(model : AddLocationModel){
       
        
        guard
            let url = URL(string: url)
            else{
                print("Fail to get the appropriate url & parameters")
            
                return
            }

        
        
        let header : HTTPHeaders = [
            "Accept":"application/json",
            "apiKey": "78408836-f4a2-41fe-a39e-4b32f8c97b2f"
        ]
     
        
     
        
        
        AF.request(url, method: .post, parameters: model, headers: header).responseJSON { json in
            print("json as",json)
        }
        
        
        
        
        
        
    }
    
    
    
    
    
    
}




enum APIError : LocalizedError{
    
    case urlInvalid
    case dataCorrupt
    case inavlidStausCode(Int)
    case jsonSerilizationError
    case failure(String)
    
    

    var errorDescription: String?{
        
        switch self {
        case .urlInvalid:
            return "Invalid Url For Api Call"
        case .dataCorrupt:
            return "Corrupt data error"
        case .inavlidStausCode(let code):
            return String(code)
        case .jsonSerilizationError:
            return "Fail to serialize json response"
        case .failure(let error):
            return error
        }
        

    }
}




struct AddLocationModel : Encodable{
    
    let id : Int
    let timestamp : String
    let latitude : String
    let longitude : String
    
}
