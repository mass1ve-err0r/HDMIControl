//
//  IRServerManager.swift
//  HDMIControl Watch App
//
//  Created by Saadat Baig on 11.05.24.
//
import Foundation



class IRServerManager: ObservableObject {
    
    
    init() { }
    
    public func changeHDMIPort(_ toNewPort: Int, completion: @escaping (Bool) -> Void) -> Void {
        var portChangeRequest = URLRequest(url: URL(string: "http://ir-hdmi-control.local/hdmi/\(toNewPort)")!)
        portChangeRequest.httpMethod = "GET"
        portChangeRequest.timeoutInterval = 10
        
        URLSession.shared.dataTask(with: portChangeRequest) { data, response, error in
            if error != nil {
                completion(false)
            } else {
                completion(true)
            }
            
        }.resume()
    }
    
}
