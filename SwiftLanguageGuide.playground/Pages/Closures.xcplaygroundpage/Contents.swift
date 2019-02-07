//: [Previous](@previous)

import Foundation

// Closures

// Closures are self-contained blocks of functionality that can be passed around and used in your code.

/*
Global and nested functions, as introduced in Functions, are actually special cases of closures. Closures take one of three forms:
 - Global functions are closures that have a name and do not capture any values.
 - Nested functions are closures that have a name and can capture values from their enclosing function.
　- Closure expressions are unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
*/



let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]

func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}

var reversedNames = names.sorted(by: backward)


// Closure Expression Syntax
/*
 { (parameters) -> return type in
 statements
 }
*/

/* paramter
 - inout
 - variadic
 - tuple
 - no default value
*/

reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 < s2
})

// in keyword: indicates that the definition of the closure’s parameters and return type has finished, and the body of the closure is about to begin


// Inferring Type From Context
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )

// you can still make the types explicit if you wish, and doing so is encouraged if it avoids ambiguity for readers of your code

// Implicit Returns from Single-Expression Closures
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )

// Shorthand Argument Names
reversedNames = names.sorted(by: { $0 > $1 } )

// Operator Methods
reversedNames = names.sorted(by: >)


// Trailing Closures
reversedNames = names.sorted() { $0 > $1 }

// If closure is only argument
reversedNames = names.sorted { $0 > $1 }

let digitNames = [
    0: "Zero", 1: "One", 2: "Two",   3: "Three", 4: "Four",
    5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine"
]
let numbers = [16, 58, 510]

let strings = numbers.map { (number) -> String in
    var number = number
    var output = ""
    repeat {
        output = digitNames[number % 10]! + output
        number /= 10
    } while number > 0
    return output
}

// Capturing Values

func makeIncrementer(forIncrement amount: Int) -> () -> Int {
    var runningTotal = 0
    func incrementer() -> Int {
        runningTotal += amount
        return runningTotal
    }
    return incrementer
}

let incrementByTen = makeIncrementer(forIncrement: 10)

print(incrementByTen()) // 10
print(incrementByTen()) // 20
print(incrementByTen()) // 30

let incrementBySeven = makeIncrementer(forIncrement: 7)
print(incrementBySeven()) // 7

print(incrementByTen()) // 40


// Closures Are Reference Types

let alsoIncrementByTen = incrementByTen
alsoIncrementByTen() // 50
incrementByTen() //  60

// Escaping Closures

// Autoclosures


//: [Next](@next)
