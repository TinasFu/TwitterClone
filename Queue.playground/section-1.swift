// Playground - noun: a place where people can play

import UIKit



class Queue {
    
    var queueArray = [String]()
    
    func enqueue(stringToEnqueue : String) {
        self.queueArray.append(stringToEnqueue)
    }
    
    func dequeue() -> String? {
        if !queueArray.isEmpty {
            var dequeuedString = queueArray.last
            queueArray.removeAtIndex(0)
            return dequeuedString!
        } else {
            return nil
        }
    }

}




