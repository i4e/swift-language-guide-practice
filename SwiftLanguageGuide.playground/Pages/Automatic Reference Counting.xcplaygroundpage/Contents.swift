//: [Previous](@previous)
//: [Next](@next)

import Foundation

//: # Automatic Reference Counting


class Person {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person?
var reference2: Person?
var reference3: Person?

reference1 = Person(name: "John Appleseed") // count 1
// Prints "John Appleseed is being initialized"

reference2 = reference1  // count 2
reference3 = reference1  // count 3

reference1 = nil  // count 2
reference2 = nil  // count 1
reference3 = nil  // count 0
// Prints "John Appleseed is being deinitialized"


//: ## Strong Reference Cycles Between Class Instances

