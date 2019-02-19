//: [Previous](@previous)

import Foundation

//: # Structures and Classes
//: refs: https://docs.swift.org/swift-book/LanguageGuide/ClassesAndStructures.html

//: ## Comparing Structures and Classes
/*:
- Define properties to store values
- Define methods to provide functionality
- Define subscripts to provide access to their values using subscript syntax
- Define initializers to set up their initial state
- Be extended to expand their functionality beyond a default implementation
- Conform to protocols to provide standard functionality of a certain kind
 
 Classes have additional capabilities that structures don’t have:
 
- Inheritance enables one class to inherit the characteristics of another.
- Type casting enables you to check and interpret the type of a class instance at runtime.
- Deinitializers enable an instance of a class to free up any resources it has assigned.
- Reference counting allows more than one reference to a class instance.
 */

/*:

 ### Choosing Between Structures and Classes
 refs: https://developer.apple.com/documentation/swift/choosing_between_structures_and_classes
 - 基本的には struct
 - Objective-C と一緒に使うものは class
 - identity を制御する必要がある場合は class
    - file handles
    - network connections
    - shared hardware intermediaries like CBCentralManager
 - 実装をシェアしてprotocolに準拠させたい場合は struct
 
 ほとんどのカスタムデータ型は structures and enumerations になる

 */


// 定義
struct Resolution {
    var width = 0
    var height = 0
}

class VideoMode {
    var resolution = Resolution()
    var interlaced = false
    var frameRate = 0.0
    var name: String?   // nil
}

// インスタンスの生成
let someResolution = Resolution()
let someVideoMode = VideoMode()

// プロパティへのアクセス
print(someResolution.width)
print(someVideoMode.resolution.width)

// プロパティの値の更新
//someResolution.width = 10.0  // let で宣言したので再代入不可
someVideoMode.frameRate = 10.0
someVideoMode.resolution.width = 1280

// メンバワイズの初期化
let vga = Resolution(width: 640, height: 480)


//: ## Structures and Enumerations Are Value Types

//: >Collections defined by the standard library like arrays, dictionaries, and strings use an optimization to reduce the performance cost of copying. Instead of making a copy immediately, these collections share the memory where the elements are stored between the original instance and any copies. If one of the copies of the collection is modified, the elements are copied just before the modification. The behavior you see in your code is always as if a copy took place immediately.

let hd = Resolution(width: 1920, height: 1080)
var cinema = hd // コピーが生成され，代入される
cinema.width = 2048     // hd.width には影響なし
print(hd.width, cinema.width)   // 1920, 2048

// enum も値型
enum CompassPoint {
    case north, south, east, west
    mutating func turnNorth() {
        self = .north
    }
}
var currentDirection = CompassPoint.west
let rememberedDirection = currentDirection
currentDirection.turnNorth()

print(currentDirection, rememberedDirection) // north, west


//: ## Classes Are Reference Types

let tenEighty = VideoMode()

// VideoMode を参照する定数は変化していないので，プロパティの値を変更できる
tenEighty.resolution = hd
tenEighty.interlaced = true
tenEighty.name = "1080i"
tenEighty.frameRate = 25.0

let alsoTenEighty = tenEighty
alsoTenEighty.frameRate = 30.0

print(tenEighty.frameRate) // 30.0

// >This example also shows how reference types can be harder to reason about. If tenEighty and alsoTenEighty were far apart in your program’s code, it could be difficult to find all the ways that the video mode is changed. Wherever you use tenEighty, you also have to think about the code that uses alsoTenEighty, and vice versa. In contrast, value types are easier to reason about because all of the code that interacts with the same value is close together in your source files.

// >Note that tenEighty and alsoTenEighty are declared as constants, rather than variables. However, you can still change tenEighty.frameRate and alsoTenEighty.frameRate because the values of the tenEighty and alsoTenEighty constants themselves don’t actually change. tenEighty and alsoTenEighty themselves don’t “store” the VideoMode instance—instead, they both refer to a VideoMode instance behind the scenes. It’s the frameRate property of the underlying VideoMode that is changed, not the values of the constant references to that VideoMode.


// Identity Operators
print(tenEighty === alsoTenEighty) // true

//: [Next](@next)
