//
//  ViewController.swift
//  OperationDemo
//
//  Created by Tong Yi on 6/22/20.
//  Copyright © 2020 Tong Yi. All rights reserved.
//

import UIKit

class OperationGroupWithDependency
{
    private var opGroups: [Operation] = []
    
    func groupEnter(completeHandler: @escaping () -> ())
    {
        let op = BlockOperation {
            completeHandler()
        }
        
        opGroups.append(op)
    }
    
    func groupNotify(completeHandler: @escaping () -> ())
    {
        let opNotify = BlockOperation {
            completeHandler()
        }
        
        for op in opGroups
        {
            opNotify.addDependency(op)
        }
        
        opGroups.append(opNotify)
        
        let queue = OperationQueue()
        queue.addOperations(opGroups, waitUntilFinished: false)
    }
}

class OperationGroupWithoutDependency
{
    private let op: BlockOperation = BlockOperation()
    
    func groupEnter(completeHandler: @escaping () -> ())
    {
        op.addExecutionBlock {
            completeHandler()
        }
    }
    
    func groupNotify(completeHandler: @escaping () -> ())
    {
        op.completionBlock = {
            completeHandler()
        }
        
        let queue = OperationQueue()
        queue.addOperation(op)
    }
}

class ViewController: UIViewController
{
    @IBOutlet weak var imageView1: UIImageView!
    @IBOutlet weak var imageView2: UIImageView!
    @IBOutlet weak var imageView3: UIImageView!
    
    var imageData = [String: Data]()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setup()
//        loadImageWithDependency()
        loadImageWithoutDependency()
//        useOperationImplementDispatchGroupMehtod1WithDependency()
//        useOperationImplementDispatchGroupMehtod2WithCompletionBlock()
//        downloadImage()
    }
    
    func setup()
    {
        imageView1.contentMode = .scaleToFill
        imageView2.contentMode = .scaleToFill
        imageView3.contentMode = .scaleToFill
    }
    
    func loadImageWithDependency()
    {
        let group = OperationGroupWithDependency()
        
        group.groupEnter {
            self.loadImageAsync1()
        }
        
        group.groupEnter {
            self.loadImageAsync2()
        }
        
        group.groupEnter {
            self.loadImageAsync3()
        }
        
        group.groupNotify {
            OperationQueue.main.addOperation
            {
                self.imageView1.image = UIImage(data: self.imageData["Image1"]!)
                self.imageView2.image = UIImage(data: self.imageData["Image2"]!)
                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
            }
        }
    }
    
    func loadImageWithoutDependency()
    {
        let group = OperationGroupWithoutDependency()
        
        group.groupEnter {
            self.loadImageAsync1()
        }
        
        group.groupEnter {
            self.loadImageAsync2()
        }
        
        group.groupEnter {
            self.loadImageAsync3()
        }
        
        group.groupNotify {
            OperationQueue.main.addOperation
            {
                self.imageView1.image = UIImage(data: self.imageData["Image1"]!)
                self.imageView2.image = UIImage(data: self.imageData["Image2"]!)
                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
            }
        }
    }
    
    
    
    func useOperationImplementDispatchGroupMehtod1WithDependency()
    {
        var opGroups: [Operation] = []
        
        let op1 = BlockOperation
        {
            self.loadImageAsync1()
        }
        
        let op2 = BlockOperation
        {
            self.loadImageAsync2()
        }
        
        let op3 = BlockOperation
        {
            self.loadImageAsync3()
        }
        
        opGroups.append(contentsOf: [op1, op2, op3])
        
        let opNotify = BlockOperation
        {
            OperationQueue.main.addOperation
            {
                self.imageView1.image = UIImage(data: self.imageData["Image1"]!)
                self.imageView2.image = UIImage(data: self.imageData["Image2"]!)
                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
            }
        }
        
        for op in opGroups
        {
            opNotify.addDependency(op)
        }
        
        opGroups.append(opNotify)
        
        let queue = OperationQueue()
        queue.addOperations(opGroups, waitUntilFinished: false)
    }
    
    func useOperationImplementDispatchGroupMehtod2WithCompletionBlock()
    {
        let op: BlockOperation = BlockOperation()
        
        op.addExecutionBlock {
            self.loadImageAsync1()
        }
        
        op.addExecutionBlock {
            self.loadImageAsync2()
        }
        
        op.addExecutionBlock {
            self.loadImageAsync3()
        }
        
        op.completionBlock = {
            OperationQueue.main.addOperation
            {
                self.imageView1.image = UIImage(data: self.imageData["Image1"]!)
                self.imageView2.image = UIImage(data: self.imageData["Image2"]!)
                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
            }
        }
        
        let queue = OperationQueue()
        queue.addOperation(op)
    }
    
    func loadImageAsync1()
    {
        guard let data = Service.shared.fetchData(url: AppConstants.url1) else { return }
        self.imageData["Image1"] = data
    }
    
    func loadImageAsync2()
    {
        guard let data = Service.shared.fetchData(url: AppConstants.url2) else { return }
        self.imageData["Image2"] = data
    }
    
    func loadImageAsync3()
    {
        guard let data = Service.shared.fetchData(url: AppConstants.url3) else { return }
        self.imageData["Image3"] = data
    }
    
    
    
    
    
    
    
    
    
    func downloadImage()
    {
        let startTime = Date()
        let queue = OperationQueue()
        
//        queue.maxConcurrentOperationCount = 2
        
        let image1OP = BlockOperation {
//            let cost = Date().timeIntervalSince(startTime)
//            print(String(format: "[1 OP start: %.5f ] seconds", cost))
            
            guard let data = Service.shared.fetchData(url: AppConstants.url1) else { return }
            self.imageData["Image1"] = data
            
//            OperationQueue.main.addOperation {
//                self.imageView1.image = UIImage(data: self.imageData["Image1"]!)
//            }
        }
        
        let image2OP = BlockOperation {
//            let cost = Date().timeIntervalSince(startTime)
//            print(String(format: "[2 OP start: %.5f ] seconds", cost))
            
            guard let data = Service.shared.fetchData(url: AppConstants.url2) else { return }
            self.imageData["Image2"] = data
            
//            OperationQueue.main.addOperation {
//                self.imageView2.image = UIImage(data: self.imageData["Image2"]!)
//            }
        }
        
        let image3OP = BlockOperation {
//            let cost = Date().timeIntervalSince(startTime)
//            print(String(format: "[3 OP start: %.5f ] seconds", cost))
            
            guard let data = Service.shared.fetchData(url: AppConstants.url3) else { return }
            self.imageData["Image3"] = data
            
//            OperationQueue.main.addOperation {
//                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
//            }
        }
        
        image1OP.completionBlock = {
//            print("image 1")
//            sleep(2)
            let cost = Date().timeIntervalSince(startTime)
            print(String(format: "[1 OP spent: %.5f ] seconds", cost))
//            OperationQueue.main.addOperation {
//                self.imageView1.image = UIImage(data: self.imageData["Image1"]!)
//            }
        }

        image2OP.completionBlock = {
//            print("image 2")
//            sleep(2)
            let cost = Date().timeIntervalSince(startTime)
            print(String(format: "[2 OP spent: %.5f ] seconds", cost))
//            OperationQueue.main.addOperation {
//                self.imageView2.image = UIImage(data: self.imageData["Image2"]!)
//            }
        }

        image3OP.completionBlock = {
            let cost = Date().timeIntervalSince(startTime)
            print(String(format: "[3 OP spent: %.5f ] seconds", cost))
            
            OperationQueue.main.addOperation {
                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
            }
        }
        
        //image size may be a problem
//        image3OP.queuePriority = .veryLow
//        image2OP.queuePriority = .low
//        image1OP.queuePriority = .veryHigh
        
//        image3OP.qualityOfService = .userInteractive
//        image2OP.qualityOfService = .background
//        image1OP.qualityOfService = .utility
        
        image3OP.addDependency(image2OP)
        image2OP.addDependency(image1OP)
        
        queue.addOperations([image1OP, image2OP, image3OP], waitUntilFinished: true)
        
        queue.addOperation {
//            print("image 3")
            let cost = Date().timeIntervalSince(startTime)
            print(String(format: "[after wait OP spent: %.5f ] seconds", cost))
//            OperationQueue.main.addOperation {
//                self.imageView3.image = UIImage(data: self.imageData["Image3"]!)
//            }
        }
        
    }

}

