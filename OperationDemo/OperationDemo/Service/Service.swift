//
//  Service.swift
//  OperationDemo
//
//  Created by Tong Yi on 6/22/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import Foundation

class Service
{
    static let shared = Service()
    private init() {}
    
    func fetchData(url: URL?) -> Data?
    {
        var data = Data()
        guard let url = url else { return nil}
        do
        {
            data = try Data(contentsOf: url)
        }
        catch
        {
            print(error.localizedDescription)
        }
        
        return data
    }
}
