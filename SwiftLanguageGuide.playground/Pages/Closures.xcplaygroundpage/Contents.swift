//: [Previous](@previous)

import Foundation

/*:
# Closures

## 概要
Closures: self-contained blocks of functionality that can be passed around and used in your code

global function, nested function は closure の特別なケース

closure は以下のうちどれかの形態をとる
 
 - Global functions: closures that have a name and do not capture any values.
 - Nested functions: closures that have a name and can capture values from their enclosing function.
 - Closure expressions: unnamed closures written in a lightweight syntax that can capture values from their surrounding context.
*/

//: ### 関数も Closure の一種

// 関数
func backward(_ s1: String, _ s2: String) -> Bool {
    return s1 > s2
}

// closure expression
let backwardClosure = { (s1: String, s2: String) -> Bool in
    return s1 > s2
}

// fucntion と closure expression の型は同じ
print(type(of: backward))  // (String, String) -> Bool
print(type(of: backwardClosure))  // (String, String) -> Bool

// 関数呼び出し closure expression はラベルを使わない
backward("a", "b")  // false
backwardClosure("a", "b")  // false

// 引数ラベルを記述するとエラーになる
// backwatdClosure(s1: "a", s2: "b")  error


//: ### Closure の使用例) 引数に渡す
let names = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
var reversedNames = names.sorted(by: backward)
reversedNames = names.sorted(by: backwardClosure)


/*:
## Closure Expression Syntax

 { (parameters) -> return type in
statements
}

paramter について
 - 設定可能
    - inout
    - variadic 可能
    - tuple 可能
 - デフォルト値は設定不可
 
`in` キーワード: indicates that the definition of the closure’s parameters and return type has finished, and the body of the closure is about to begin
*/

// 書き方いろいろ
reversedNames = names.sorted(by: { (s1: String, s2: String) -> Bool in  // 関数のような書き方
    return s1 < s2
})
reversedNames = names.sorted(by: { s1, s2 in return s1 > s2 } )  // Inferring Type From Context
reversedNames = names.sorted(by: { s1, s2 in s1 > s2 } )  // Implicit Returns
reversedNames = names.sorted(by: { $0 > $1 } )  // Shorthand Argument Names
reversedNames = names.sorted(by: >)  // Operator Methods


//: ## Tailing Closures

reversedNames = names.sorted() { $0 > $1 }
reversedNames = names.sorted { $0 > $1 }  // 引数が Closure のみの場合，() を省略可能

// 使用例)
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


/*:
 ## Capturing Values
- capture: インスタンスが生成される際, closure の外側にある変数の値を取り込む．
 インスタンスが呼び出されるときはいつでも値を取り出すことが可能
- context: closure が生成される時点で参照できる定数や変数の集合．
 1. グローバル変数: closure の内部からも変数自体に直接アクセス可能
 2. ローカル変数: コードブロックの実行が終わり，ローカル変数が消滅したあと
  元のローカル変数が存在し続けているかのように参照・更新が可能
    - 2-a. ブロックの実行が終わり，再び実行したときは別の変数になるため，値が共有されない
    - 2-b. 同スコープ内で生成された複数個のクロージャが同じローカル変数を参照する場合，値が共有される
    - 2-c. 参照型の値を持つローカル変数をキャプチャした場合，強参照で保持される．クロージャが開放されると，その値への強参照もなくなる
*/

// 2-a. ブロックの実行が終わり，再び実行したときは別の変数になるため，値が共有されない

func maker(_ a: Int, _ b: Int) -> () -> Int {
    var localVar = a
    return { () -> Int in
        globalCount += 1
        localVar += b
        return localVar
    }
}

var globalCount = 0
var m1 = maker(10, 1)       // localVar = 10, b = 1 としてコピーが生成
print(m1(), globalCount)    // 11, 1
print(m1(), globalCount)    // 12, 2

globalCount = 1000
var m2 = maker(50, 2)       // localVar = 50, b = 2 としてコピーが生成
print(m1(), globalCount)    // 13, 1001
print(m2(), globalCount)    // 52, 1002
// localVar や b が共有されていないことがわかる
print(m1(), globalCount)    // 14, 1003
print(m2(), globalCount)    // 54, 1004


// 2-b. 複数個のクロージャが同じローカル変数をキャプチャする場合，値が共有される

var m3: (() -> ())! = nil
var m4: (() -> ())! = nil

func makerW(_ a: Int) {
    var localVar = a
    m3 = { localVar += 1; print("m3: \(localVar)") }
    m4 = { localVar += 5; print("m4: \(localVar)") }
    m3()                        // 11
    print("--: \(localVar)")    // 11
    m4()                        // 16
    print("--: \(localVar)")    // 16
}

makerW(10)
m3()    // 17 (11 + 1)
m4()    // 22 (17 + 5)
m3()    // 23 (22 + 1)
// localVar が共有されている

// 2-c. 参照型の値を持つローカル変数をキャプチャした場合，強参照で保持される．

class MyInt {
    var value = 0
    init(_ v: Int) { value = v }
    deinit { print("deinit: \(value)") }
}

func makerZ(_ a: MyInt, _ s: String) -> () -> () {
    let localVar = a
    return {
        localVar.value += 1
        print("\(s): \(localVar.value)")
    }
}

var obj: MyInt! = MyInt(10)     // ARC 1 (0 + 1)
var m5: (() -> ())! = makerZ(obj, "m5")  // ARC 2 (1 + 1), m5 が obj を強参照でキャプチャ
var m6: (() -> ())! = makerZ(obj, "m6")  // ARC 3 (2 + 1), m6 が obj を強参照でキャプチャ
obj = nil   // ARC 2 (3 - 1)
m5()        // 11
m6()        // 12
m5()        // 13
m5 = nil    // ARC 2 (2 - 1)
m6()        // 14
m6 = nil    // ARC 0 (1 - 1), deinit: 14


// nested funciton

func makerNestedFunction(_ a: Int, _ b: Int) -> () -> Int {
    var localVar = a
    func localFunction() -> Int {
        globalCount += 1
        localVar += b       // localVar, b がキャプチャされる
        return localVar
    }
    return localFunction
}

globalCount = 0
var m7 = maker(10, 1)       // localVar = 10, b = 1 としてコピーが生成
print(m7(), globalCount)    // 11, 1
print(m7(), globalCount)    // 12, 2

globalCount = 1000
var m8 = maker(50, 2)       // localVar = 50, b = 2 としてコピーが生成
print(m8(), globalCount)    // 13, 1001
print(m8(), globalCount)    // 52, 1002

//: ## Closures Are Reference Types

let makerA = maker(10, 1)   // makerA には closure への参照が格納
let alsoMakerA = makerA     // alsoMakerA に closure への参照がコピーされる
makerA()        // 11
alsoMakerA()    // 12


/*:
## Escaping Closures
- escape: 関数の引数としてクロージャを渡したとき，その関数がリターンした後にクロージャが呼び出されること
*/

var theFunction:((Int) -> Int)! = nil
func doFunc(_ value: Int, _ function: (Int) -> (Int)) { print(function(value)) }
//func setFunttion(_ function: (Int) -> Int ) { theFunction = function }  // error
func setFunttion(_ function: @escaping (Int) -> Int ) { theFunction = function }

//  escape するクロージャに inout の引数を含めることはできない
func dungeon(level: inout Int) {
//    setFunttion( { level + $0 } )     // error
    setFunttion( { [level] in level + $0 } )  // キャプチャリストでコピーを渡す
}


/*:
 ## Autoclosures
 - autoclosure: 関数に引数として渡された式をラップするために自動で生成された closure
   - 関数のパラメータを囲む括弧を省略できる
   - オートクロージャを取る関数を呼び出すのは一般的だが，実装するのは一般的ではない

 - 例) assert(condition:message:file:line:)
   - condition と message に autoclosure
     - condition: evaluated only in debug builds
     - message: evaluated only if condition is false
 
 利点: autoclosure は以下のような処理を評価するタイミングをコントロールできる
 - 副作用を持つ処理
 - computationally expensive

 refs:
 - https://qiita.com/shimesaba/items/b1baced2ec3d9244b2c9
 - https://www.swiftbysundell.com/posts/using-autoclosure-when-designing-swift-apis
 */


// クロージャの遅延評価の例
var customerInLine = ["Chris", "Alex", "Ewa", "Barry", "Daniella"]
print(customerInLine)  // 5

let customerProvider = { customerInLine.remove(at: 0) }
print(customerInLine.count)  // 5, closure は呼び出されるまで評価されていない

print(customerProvider())  // Chris
print(customerInLine.count)  // 4


// 関数の引数としてクロージャを渡したときも同様の振る舞い
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serve(customer customerProvider: () -> String) {
    print(customerProvider())
}
serve(customer: { customerInLine.remove(at: 0) } )  // Alex

// Autoclosure の例
// customersInLine is ["Alex", "Ewa", "Barry", "Daniella"]
func serveWithAutoClosure(customer customerProvider: @autoclosure () -> String) {
    print(customerProvider())
}
serveWithAutoClosure(customer: customerInLine.remove(at: 0))    // Ewa

// autoclosure and escaping
var customerProviders: [() -> String] = []
func collectCustomerProviders(_ customerProvider: @autoclosure @escaping () -> String) {
    customerProviders.append(customerProvider)
}
collectCustomerProviders(customerInLine.remove(at: 0))
collectCustomerProviders(customerInLine.remove(at: 0))

print(customerProviders.count)  // 2
for customerProvider in customerProviders {
    print(customerProvider())
}
// Barry, Daniella


// 遅延評価を用いてハイコストな関数の呼び出しをコントロールする例
func highCostFunction(_ value: Int) -> Int {
    print("high cost")
    return value
}

// highCostFunctionの評価結果が skip に渡される
func skip(condition: Bool, _ arg: Int) {
    if !condition { print(arg) }
}
skip(condition: true, highCostFunction(10000))  // Prints "high cost"

// highCostFunction(10000) が skipWithAutoclosure に渡され，condition が false のときだけ評価される
func skipWithAutoclosure(condition: Bool, _ arg: @autoclosure () -> Int) {
    if !condition { print(arg()) }
}
skipWithAutoclosure(condition: true, highCostFunction(10000))   // 何も表示されない



//: ## Overload された関数の区別
func bracket(name: String) { print("[\(name)] ", terminator:"") }
func pr(name: String) { print(name + ": ", terminator:"") }
func pr(message m: String) { print("\"\(m)\"") }
func pr(_ strs: String...) {
    for s in strs { print(s, terminator:" ") }
    print()
}
func pr(_ num: Int) { print(num, terminator:" ") }

let f1 = bracket        // オーバーロードがなければ関数名だけでよい

// オーバーロードされた関数の指定方法
let f2 = pr(message:)   // 引数ラベルで関数を指定
let f3:(String...)->() = pr  // 関数の型を明示
f1("hoge")
f2("fugafuga")  // [hoge] "fugafuga"
f3("a", "bb", "ccc", "dddd")  // a bb ccc dddd


//: ## その他
// Optional type の Closure
var optionalClosure: ((Int, Int) -> Double)?

// Closure の Array
var closures = [(Int, Int) -> Double]()
var closures2 = Array<(Int, Int) -> Double>()

// 複雑になるのを防ぐために typealias を使用する
typealias MyClosure = (Int, Int)->Double
var closures3 = [MyClosure]()


//: [Next](@next)
