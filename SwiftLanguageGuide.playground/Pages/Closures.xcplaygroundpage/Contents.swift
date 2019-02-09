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

/// 関数も Closure の一種
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}
let backwardClosure = { (s1: String, s2: String) -> Bool in
    return s1 > s2
}

/// 同じ型
print(type(of: backward))  // (String, String) -> Bool
print(type(of: backwardClosure))  // (String, String) -> Bool

/// 関数呼び出し
backward("a", "b")  // false
backwardClosure("a", "b")  // false

/// 引数ラベルを記述するとエラーになる
// backwatdClosure(s1: "a", s2: "b")  error


/// Closure を引数に渡す
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversedNames = names.sorted(by: backward)
reversedNames = names.sorted(by: backwardClosure)

/// Closure Expression Syntax
/// { (parameters) -> return type in
/// statements
/// }

/// paramter
///  - 設定可能
///    - inout
///    - variadic 可能
///    - tuple 可能
///  - デフォルト値は設定不可

/// Closure Expression を直接引数に渡す
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in
    return s1 < s2
})

/// in keyword: indicates that the definition of the closure’s parameters and return type has finished, and the body of the closure is about to begin

reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )  // Inferring Type From Context
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )  // Implicit Returns
reversedNames = names.sorted(by: { $0 > $1 } )  // Shorthand Argument Names
reversedNames = names.sorted(by: >)  // Operator Methods


/// Tailing Closures
reversedNames = names.sorted() { $0 > $1 }

/// 引数が Closure のみの場合，() を省略可能
reversedNames = names.sorted { $0 > $1 }

/// 使用例
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


/// Capturing Values
/// capture: インスタンスが生成される際, closure の外側にある変数の値を取り込む
///          インスタンスが呼び出されるときはいつでも値を取り出すことが可能
/// context: closure が生成される時点で参照できる定数や変数の集合
///          - グローバル変数，ブロック内で参照可能なローカル変数など
/// グローバル変数: closure の内部からも変数自体に直接アクセス可能
/// ローカル変数: コードブロックの実行が終わり，ローカル変数が消滅したあと
///             元のローカル変数が存在し続けているかのように参照・更新が可能
/// 実行終わり，再び実行したとき
/// 複数個のクロージャが同時に生成されたとき
/// 参照型の値を持つローカル変数をキャプチャした場合

/// 例) nested funciton
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


/// Closures Are Reference Types
let alsoIncrementByTen = incrementByTen
alsoIncrementByTen() // 50
incrementByTen() //  60

/// Escaping Closures

/// Autoclosures


/// Overload された関数の区別
func bracket(name: String) { print("[\(name)] ", terminator:"") }
func pr(name: String) { print(name + ": ", terminator:"") }
func pr(message m: String) { print("\"\(m)\"") }
func pr(_ strs: String...) {
    for s in strs { print(s, terminator:" ") }
    print()
}
func pr(_ num: Int) { print(num, terminator:" ") }

let f1 = bracket        // オーバーロードがなければ関数名だけでよい

/// オーバーロードされた関数の指定方法
let f2 = pr(message:)   // 引数ラベルで関数を指定
let f3:(String...)->() = pr  // 関数の型を明示
f1("hoge")
f2("fugafuga")  // [hoge] "fugafuga"
f3("a", "bb", "ccc", "dddd")  // a bb ccc dddd


/// Optional type の Closure
var optionalClosure: ((Int, Int) -> Double)?

/// Closure の Array
var closures = [(Int, Int) -> Double]()
var closures2 = Array<(Int, Int) -> Double>()

/// 複雑になるのを防ぐために typealias を使用する
typealias MyClosure = (Int, Int)->Double
var closures3 = [MyClosure]()


//: [Next](@next)
