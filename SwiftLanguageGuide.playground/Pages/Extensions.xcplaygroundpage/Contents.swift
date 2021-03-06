//: [Previous](@previous)

import Foundation

//: [Next](@next)

//: # Extensions

// > エクステンションは、既存のクラス、構造体、列挙型、あるいはプロトコルの型に新しい機能を追加します。これには、オリジナルのソースコードへのアクセスを持たない型の拡張（レトロアクティブモデリング）を含みます。

// Extensionsでできること，できないことを説明せよ

/*:
 Extensions でできること: 以下の項目に関する新しい定義の追加
 - computed instance property, stored type property, computed type property
 - instance method, type method
 - initializer
 - subscript
 - nested type
 - protocol に準拠
 Extensions でできないこと
 - stored instance property のついか
 - property observer の追加
 - 他の extension で定義されている内容を上書き
 */

// Extension の基本文法が理解できるか

struct Hoge { }
protocol Fuga {
    var fuga: Int { get }
    func fugaFunction()
}
extension Hoge {
//    var instanceStoredProperty: Int   // error
    var instanceComputedProperty: Int {
        return 1
    }
    static var storedTypeProperty: Int = 1
    static var computedTypeProperty: Int {
        return 2
    }
    
    init(_ hoge: Int) {
        print(hoge)
    }
    subscript(index: Int) -> String {
        return "hoge" + String(index)
    }
}

extension Hoge {
    struct NestedHoge {
        let number = 100
    }
    
    func nestedHoge() {
        let nested = NestedHoge()
        print(nested.number)
    }
}

extension Hoge: Fuga {
    var fuga: Int {
        return 1
    }
    func fugaFunction() {
        print("fuga")
    }
}

let hoge = Hoge(1)
print(hoge[1])
hoge.nestedHoge()


//: ## Computed Properties

// stored properties の追加や 既存の properties に property observers の追加はできない

extension Double {
    // error: extensions must not contain stored properties
    //    var a: Double
    var km: Double { return self * 1_000.0 }
    var m: Double { return self }
    var cm: Double { return self / 100.0 }
    var mm: Double { return self / 1_000.0 }
    var ft: Double { return self / 3.28084 }
}
let oneInch = 25.4.mm
print("One inch is \(oneInch) meters")  // "One inch is 0.0254 meters"
let threeFeet = 3.ft
print("Three feet is \(threeFeet) meters")  // "Three feet is 0.914399970739201 meters"


//: ## Initializers

struct Size {
    var width = 0.0, height = 0.0
}
struct Point {
    var x = 0.0, y = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
}

let defaultRect = Rect()
let memberwiseRect = Rect(origin: Point(x: 2.0, y: 2.0),
                          size: Size(width: 5.0, height: 5.0))

// イニシャライザを追加
extension Rect {
    init(center: Point, size: Size) {
        let originX = center.x - (size.width / 2)
        let originY = center.y - (size.height / 2)
        self.init(origin: Point(x: originX, y: originY), size: size)
    }
}

let centerRect = Rect(center: Point(x: 4.0, y: 4.0),
                      size: Size(width: 3.0, height: 3.0))
// centerRect の origin は (2.5, 2.5) で、size は (3.0, 3.0)


//: ## Methods

extension Int {
    func repetitions(task: () -> Void) {
        for _ in 0..<self {
            task()
        }
    }
}

3.repetitions {
    print("Hello!")
}
// Hello!
// Hello!
// Hello!

//: ### Mutating Instance Methods

extension Int {
    mutating func square() {
        self = self * self
    }
}
var someInt = 3
someInt.square()  // someInt is now 9



//: ## Subscripts

extension Int {
    subscript(digitIndex: Int) -> Int {
        var decimalBase = 1
        for _ in 0..<digitIndex {
            decimalBase *= 10
        }
        return (self / decimalBase) % 10
    }
}

746381295[0]
// returns 5
746381295[1]
// returns 9
746381295[2]
// returns 2
746381295[8]
// returns 7


//: ## Nested Types

extension Int {
    enum Kind {
        case negative, zero, positive
    }
    var kind: Kind {
        switch self {
        case 0:
            return .zero
        case let x where x > 0:
            return .positive
        default:
            return .negative
        }
    }
}

func printIntegerKinds(_ numbers: [Int]) {
    for number in numbers {
        switch number.kind {
        case .negative:
            print("- ", terminator: "")
        case .zero:
            print("0 ", terminator: "")
        case .positive:
            print("+ ", terminator: "")
        }
    }
    print("")
}
printIntegerKinds([3, 19, -27, 0, -6, 0, 7])
