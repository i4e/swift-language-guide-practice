//: [Previous](@previous)

import Foundation

//: # Properties
/*:
 - stored property, computed property
 - instance property, type property
 - property observers
 */

//: ## Stored Property
struct FixedLengthRange {
    var firstValue: Int
    let length: Int
}

var rangeOfThreeItems = FixedLengthRange(firstValue: 0, length: 3)
rangeOfThreeItems.firstValue = 6
// rangeOfThreeITems.length = 4  // プロパティ length は定数 なので再代入不可

//: ### Stored Properties of Constant Structure Instances
let rangeOfFourItems = FixedLengthRange(firstValue: 0, length: 4)
// rangeOfFourItems.firstValue = 6  // rangeOfFourItems が定数なので error

//: ### Lazy Stored Properties
/*:
 初めて利用されるまで初期値が算出されないプロパティ．宣言の前に lazy を記述する．
 lazy property は var である必要がある．
 定数のプロパティは、初期化を完了する前に常に値を持つ必要があり、遅延として宣言することはできない．
*/

class DataImporter {
    // 初期化にかなりの時間がかかるとする
    var fileName = "data.txt"
    // the DataImporter class would provide data importing functionality here
}

class DataManager {
    // >DataManager インスタンスは、ファイルからデータをインポートすることなく、データを管理することが可能です。そのため、DataManager が生成されるときに、DataImporter インスタンスを生成する必要はありません。そうではなく、DataImporter インスタンスが初めて利用されるときに生成することが理にかなっています。
    // >importer プロパティに lazy が付けられているため、fileName プロパティを問い合わせるときのように、importer プロパティに初めてアクセスしたときに DataImporter インスタンスは生成されます。
    lazy var importer = DataImporter()
    var data = [String]()
}

let manager = DataManager()
manager.data.append("Some data")
manager.data.append("Some more data")
// importer プロパティに格納される DataImporter インスタンスはまだ生成されていない

print(manager.importer.fileName)
// importer プロパティに格納される DataImporter インスタンスは生成された


//: ## Computed Properties

struct Point {
    var x = 0.0, y = 0.0
}
struct Size {
    var width = 0.0, height = 0.0
}
struct Rect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set(newCenter) {
            origin.x = newCenter.x - (size.width / 2)
            origin.y = newCenter.y - (size.height / 2)
        }
    }
}
var square = Rect(origin: Point(x: 0.0, y: 0.0),
                  size: Size(width: 10.0, height: 10.0))
let initialSquareCenter = square.center
square.center = Point(x: 15.0, y: 15.0)
print("square.origin is now at (\(square.origin.x), \(square.origin.y))")
// 10.0, 10.0


// Shorthand Setter Declaration
struct AlternativeRect {
    var origin = Point()
    var size = Size()
    var center: Point {
        get {
            let centerX = origin.x + (size.width / 2)
            let centerY = origin.y + (size.height / 2)
            return Point(x: centerX, y: centerY)
        }
        set {   // 新しい名前を定義しない
            // newValue が新しく受け取った値の名前となる
            origin.x = newValue.x - (size.width / 2)
            origin.y = newValue.y - (size.height / 2)
        }
    }
}

// Read-Only Computed Properties
// setter が無く、getter のみの computed property のこと
//: >コンピューテッドプロパティの値は固定でないため、読み取り専用のコンピューテッドプロパティを含め、var キーワードの変数プロパティとしてコンピューテッドプロパティを宣言する必要があります。let キーワードは、インスタンス初期化の一部として設定された後は、値を変更できないことを示す定数プロパティにのみ利用することができます。


struct Cuboid {
    var width = 0.0, height = 0.0, depth = 0.0
    // get キーワードと波括弧を省略して簡略化
    var volume: Double {
        return width * height * depth
    }
}

let fourByFiveByTwo = Cuboid(width: 4.0, height: 5.0, depth: 2.0)
print("the volume of fourByFiveByTwo is \(fourByFiveByTwo.volume)")
// "the volume of fourByFiveByTwo is 40.0" と出力

//: ## Property Observers

class StepCounter {
    var totalSteps: Int = 0 {
        willSet(newTotalSteps) { // default は newValue
            print("About to set totalSteps to \(newTotalSteps)")
        }
        didSet {    // 名前をつけなかったので defalut の oldValue
            if totalSteps > oldValue  {
                print("Added \(totalSteps - oldValue) steps")
            }
        }
    }
}

let stepCounter = StepCounter()
stepCounter.totalSteps = 200
// willSet: About to set totalSteps to 200
// (set)
// didSet: Added 200 steps
stepCounter.totalSteps = 360
// willSet: About to set totalSteps to 360
// (set)
// didSet: Added 160 steps

//: >オブザーバを持つプロパティを入出力パラメータとして関数に渡す場合、willSet と didSet のオブザーバが常に呼び出されます。これは、入出力パラメータのコピーイン・コピーアウトのメモリモデルによるものです。値は常に関数の最後でプロパティに書き戻されます。入出力パラメータの挙動についての詳細は、In-Out Parameters を確認してください。


//: ## Global and Local Variables
//: >computing and observing properties are also available to global variables and local variables.

//: >グローバル定数やグローバル変数は、Lazy Stored Properties と同じように、常に遅延して算出されます。遅延ストアドプロパティと異なり、グローバル定数やグローバル変数は、lazy を付ける必要はありません。ローカル定数とローカル変数が遅延して算出されることはありません。

//: ## Type Properties

/*:
 
 その型のすべてのインスタンスに共通の値を定義するのに役に立ちます
 ストアドタイププロパティは、変数にも定数にもできます。
 コンピューテッドタイププロパティは常に、コンピューテッドインスタンスプロパティと同じように変数プロパティとして宣言されます。
 
 ※ストアドインスタンスプロパティと違い、ストアドタイププロパティにはデフォルト値が必要です。これは、初期化時にストアドタイププロパティに値を代入できるイニシャライザを、型自身が持っていないためです。
 
 ストアドタイププロパティは、遅延して最初のアクセス時に初期化されます。複数のスレッドから同時にアクセスされた場合でも、一回だけ初期化されることが保証されており、lazy を付ける必要はありません。
 
 */


// static キーワードで型プロパティを定義
struct SomeStructure {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 1
    }
}
enum SomeEnumeration {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 6
    }
}
class SomeClass {
    static var storedTypeProperty = "Some value."
    static var computedTypeProperty: Int {
        return 27
    }
    class var overrideableComputedTypeProperty: Int {
        return 107
    }
}

// アクセス
print(SomeStructure.storedTypeProperty) // Some value
SomeStructure.storedTypeProperty = "Another value."
print(SomeStructure.storedTypeProperty)  // Another value.

print(SomeEnumeration.computedTypeProperty) // 6
print(SomeClass.computedTypeProperty)  // 27


// 例
struct AudioChannel {
    static let thresholdLevel = 10
    static var maxInputLevelForAllChannels = 0
    var currentLevel: Int = 0 {
        didSet {
            if currentLevel > AudioChannel.thresholdLevel {
                currentLevel = AudioChannel.thresholdLevel
            }
            if currentLevel > AudioChannel.maxInputLevelForAllChannels {
                AudioChannel.maxInputLevelForAllChannels = currentLevel
            }
        }
    }
}

var leftChannel = AudioChannel()
var rightChannel = AudioChannel()

leftChannel.currentLevel = 7
print(leftChannel.currentLevel)  // 7
print(AudioChannel.maxInputLevelForAllChannels)  // 7

rightChannel.currentLevel = 11
print(rightChannel.currentLevel)  // 10
print(AudioChannel.maxInputLevelForAllChannels)  // 10


//: [Next](@next)
