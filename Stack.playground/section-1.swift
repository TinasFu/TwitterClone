// Playground - noun: a place where people can play

import UIKit


class Stack {
    
    var stackArray = [String]()
    
    
    func push(stringToPush : String) {
        self.stackArray.append(stringToPush)
    }
    
    func pop() -> String? {
        if !self.stackArray.isEmpty {
            var stringToReturn = self.stackArray.last
            self.stackArray.removeLast()
            return stringToReturn
        } else {
            return nil
        }
    }
}


var myStack = Stack()

myStack.push("A")
myStack.push("B")

myStack.pop()

myStack




