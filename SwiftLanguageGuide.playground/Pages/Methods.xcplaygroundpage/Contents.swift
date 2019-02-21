//: [Previous](@previous)

import Foundation

//: ## Instance Methods
class Counter {
    var count = 0
    func increment() {
        count += 1
    }
}

let counter = Counter()
counter.increment()
print(counter.count)


//: ### The self Property
//: >In practice, you don’t need to write self in your code very often. If you don’t explicitly write self, Swift assumes that you are referring to a property or method of the current instance whenever you use a known property or method name within a method.

//: >この規則の例外は、インスタンスメソッドのパラメータ名と、そのインスタンスのプロパティ名が同じ名前のときに発生します。この状況では、パラメータ名が優先され、プロパティをより限定した方法で参照する必要があります。self プロパティを使ってパラメータ名とプロパティ名を区別します。

struct Point {
    var x = 0.0, y = 0.0
    // paramter の名前が優先される
    func isToTheRightOf(x: Double) -> Bool {
        return self.x > x
    }
}
let somePoint = Point(x: 4.0, y: 5.0)
somePoint.isToTheRightOf(x: 1.0)  // true


/*:
 ### Modifying Value Types from Within Instance Methods
 構造体と列挙型は値型です。デフォルトでは、値型のプロパティをそのインスタンスメソッド内から変更することはできません。
 しかし、特定のメソッド内で構造体や列挙型のプロパティを変更する必要がある場合、そのメソッドに mutating の振る舞いを許可することができます。
 メソッド内からそのプロパティを変更できるようになり、そしてその変更は **メソッド終了時** に元の構造体に反映されます。
*/

struct Point2 {
    var x = 0.0, y = 0.0
    mutating func moveBy(x deltaX: Double, y deltaY: Double) {
        x += deltaX
        y += deltaY
        print(x)    // deltaX を加算する前の値が出力される
    }
}
var somePoint2 = Point2(x: 1.0, y: 1.0)
somePoint2.moveBy(x: 2.0, y: 3.0)      // Prints "1" (変更前の値)
print(somePoint2.x, somePoint2.y)   // 3.0, 4.0


//: ### Assigning to self Within a Mutating Method

struct Point3 {
    var x = 0.0, y = 0.0
    mutating func moveByX(deltaX: Double, y deltaY: Double) {
        self = Point3(x: x + deltaX, y: y + deltaY)
    }
}

enum TriStateSwitch {
    case off, low, high
    mutating func next() {
        switch self {
        case .off:
            self = .low
        case .low:
            self = .high
        case .high:
            self = .off
        }
    }
}

var ovenLight = TriStateSwitch.low
ovenLight.next()    // .high


//: ## Type Methods

class SomeClass {
    class func someTypeMethod() {
        // self プロパティは型自体を参照
        print(self)
    }
    func someInstanceMethod() {
        // self プロパティはインスタンスを参照
        print(self)
    }
}

SomeClass.someTypeMethod()          // SomeClass
SomeClass().someInstanceMethod()    // __lldb_expr_6.SomeClass など


// 例

struct LevelTracker {
    static var highestUnlockedLevel = 1
    var currentLevel = 1
    
    static func unlock(_ level: Int) {
        if level > highestUnlockedLevel {
            highestUnlockedLevel = level
        }
    }
    
    static func isUnlocked(_ level: Int) -> Bool {
        return level <= highestUnlockedLevel
    }
    
    @discardableResult
    mutating func advance(to level: Int) -> Bool {
        if LevelTracker.isUnlocked(level) {
            currentLevel = level
            return true
        } else {
            return false
        }
    }
}

class Player {
    var tracker = LevelTracker()
    let playerName: String
    func complete(level: Int) {
        LevelTracker.unlock(level + 1)
        tracker.advance(to: level + 1)
    }
    init(name: String) {
        playerName = name
    }
}


var player = Player(name: "Argyrios")
player.complete(level: 1)
print("highest unlocked level is now \(LevelTracker.highestUnlockedLevel)")
// Prints "highest unlocked level is now 2"

player = Player(name: "Beto")
if player.tracker.advance(to: 6) {
    print("player is now on level 6")
} else {
    print("level 6 has not yet been unlocked")
}
// Prints "level 6 has not yet been unlocked"

//: [Next](@next)
