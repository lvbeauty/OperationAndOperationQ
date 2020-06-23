import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class OperationExample
{
    func blockOperation()
    {
        let queue = OperationQueue()
        let op = BlockOperation {
            // Any task
            for index in 1...100
            {
                print(index)
            }
        }
        
        queue.addOperation(op)
    }
    
    func blockOperationConcurrent()
    {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        let op1 = BlockOperation {
            // Any task
            for index in 1...10
            {
                print(index)
            }
        }
        
        let op2 = BlockOperation {
            // Any task
            for index in 11...20
            {
                print(index)
            }
        }
        
        queue.addOperation(op1)
        queue.addOperation(op2)
    }
    
    func blockOperationConcurrentWithDependency()
    {
        let queue = OperationQueue()
//        queue.maxConcurrentOperationCount = 1
        let op1 = BlockOperation {
            // Any task
            for index in 1...10
            {
                print("\(index)\t\(Thread.current)")
            }
        }
        
        let op2 = BlockOperation {
            // Any task
            for index in 11...20
            {
                print("\(index)\t\(Thread.current)")
            }
        }
        
        let op3 = BlockOperation {
            // Any task
            for index in 21...30
            {
                print("\(index)\t\(Thread.current)")
            }
        }
        
        let op4 = BlockOperation {
            // Any task
            for index in 31...40
            {
                print("\(index)\t\(Thread.current)\t")
            }
        }
        op4.addDependency(op3)
        op3.addDependency(op2)
        op2.addDependency(op1)
        //OperationQueue.main.addOperations([op1, op2, op3, op4], waitUntilFinished: false)
        queue.addOperations([op1, op2, op3, op4], waitUntilFinished: false)
    }
    
    func excutionOrder()
    {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 2
        
        let bgOeration1 = BlockOperation {
            print("background1 Operation")
            
        }
        
        bgOeration1.completionBlock = {
            print("bg1 completed")
        }
        
        let bgOeration2 = BlockOperation {
            print("background2 Operation")
        }
        
        bgOeration2.completionBlock = {
            print("bg2 completed")
        }
        
        let bgOeration3 = BlockOperation {
            print("background3 Operation")
        }
        
        bgOeration3.completionBlock = {
            print("bg3 completed")
        }
        
        let bgOeration4 = BlockOperation {
            print("background4 Operation")
        }
        
        bgOeration4.completionBlock = {
            print("bg4 completed")
        }
        
        let userOperation = BlockOperation {
            print("user triggered")
        }
        
        bgOeration1.completionBlock = {
            print("user completed")
        }
        
//        userOperation.queuePriority = .
        userOperation.qualityOfService = .userInteractive
//        bgOeration1.qualityOfService = .default
        
        queue.addOperations([bgOeration1, bgOeration2, bgOeration3, bgOeration4, userOperation], waitUntilFinished: false)
    }
    
}

let obj = OperationExample()
obj.excutionOrder()
//obj.blockOperationConcurrentWithDependency()

public func example(of description: String, action: () -> Void) -> TimeInterval {
    let startTime = Date()
    
    print("\n--- Example of:", description, "---")
    action()
    
    let cost = Date().timeIntervalSince(startTime)
    print(String(format: "[ spent: %.5f ] seconds", cost))
    return cost
}

example(of: "OperationQueue") {
    let printerQueue = OperationQueue()
//    printerQueue.maxConcurrentOperationCount = 2
    printerQueue.addOperation { print("厉"); sleep(3) }
    printerQueue.addOperation { print("害"); sleep(3) }
    printerQueue.addOperation { print("了"); sleep(3) }
    printerQueue.addOperation { print("我"); sleep(3) }
    printerQueue.addOperation { print("的"); sleep(3) }
    printerQueue.addOperation { print("哥"); sleep(3) }
    
    printerQueue.waitUntilAllOperationsAreFinished()
}


PlaygroundPage.current.finishExecution()


