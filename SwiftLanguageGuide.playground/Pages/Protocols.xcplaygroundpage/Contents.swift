//: [Previous](@previous)
//: [Next](@next)

import Foundation

//: # Protocols

/*:
 protocol とは何か
 protocol が使えると何が嬉しいか
 - 例) Comparable プロトコルに適合していらば， sort ができる.それぞれの型について個別に並び替えの関数を定義し直す必要がない
 継承の問題点
 - 継承する側とされる側の独立性が低い: スーパークラスの実装が変更されるとサブクラスすべてが影響を受ける
 プロトコルやインターフェース
 - 複数種類のオブジェクトに同じ操作をしたいときに，それらのインターフェースが同じならば実装に関係なくプログラム内で同様に扱うことができる
 - 欠点: それぞれのオブジェクトに対する実装を共有する方法
 Swift では，extension を用いることで解決
 //TODO: つまり？
*/

//: ## Protoocl Syntax

protocol SomeProtocol {}
protocol AnotherProtocol {}
struct SomeStructure: SomeProtocol, AnotherProtocol {}
class SomeSuperClass {}
class SomeClass: SomeSuperClass, SomeProtocol, AnotherProtocol {}

//: ## Property Requierments

// プロパティがストアドプロパティかコンピューテッドプロパティかは指定せず、プロパティの名前と型だけを指定

protocol ProtocolOne {
    // gettable かつ settable であることが要求されるので，
    // 定数のストアドプロパティや読み取り専用の computed property で満たすことはできない
    var mustBeSettable: Int { get set }
    
    // どのようなプロパティでも要件を満たすことができる
    var doesNotNeedToBeSettable: Int { get }
    
    // type property
    static var someTypeProperty: Int { get set}
}

protocol FullyNamed {
    var fullName: String { get }
}

struct Person: FullyNamed {
    // stored property として要件を満たす
    var fullName: String
}
let john = Person(fullName: "John Applessed")

struct AnotherPerson: FullyNamed {
    var firstName: String
    var lastName: String
    // computed property として要件を満たす
    var fullName: String {
        return "\(firstName) \(lastName)"
    }
}

let paul = AnotherPerson(firstName: "Paul", lastName: "McCartney")
print(paul.fullName)


//: ## Method Requirements
protocol RandomNumberGenerator {
    func random() -> Double
}

class LinearCongruentialGenerator: RandomNumberGenerator {
    var lastRandom = 42.0
    let m = 139968.0
    let a = 3877.0
    let c = 29573.0
    func random() -> Double {
        lastRandom = ((lastRandom * a + c).truncatingRemainder(dividingBy:m))
        return lastRandom / m
    }
}

let generator = LinearCongruentialGenerator()
generator.random()
generator.random()

//: ## Mutating Method Requirements

protocol Togglable {
    mutating func toggle()
}

enum OnOffSwitch: Togglable {
    case off, on
    mutating func toggle() {
        switch self {
        case .off:
            self = .on
        case .on:
            self = .off
        }
    }
}

var lightSwitch = OnOffSwitch.off
lightSwitch.toggle()



//: ## Initializer Requirements

protocol SomeProtocol2 {
    init(someParameter: Int)
}

class SomeClass2: SomeProtocol2 {
    // required をつける
    required init(someParameter: Int) {
    }
}

class SomeSuperClass2 {
    init(someParameter: Int) {
        
    }
}

class SomeSubClass2: SomeSuperClass2, SomeProtocol2 {
    // required: SomeProtocol2, override: SomeSuperClass2
    required override init(someParameter: Int) {
        super.init(someParameter: someParameter)
    }
}



//: ## Protocols as Types

/*:
 プロトコルは、どのような機能もプロトコル自体に実装しません。それでも、作成したプロトコルはコードで使用するためのれっきとした型になります。
 
 プロトコルが型であるため、以下を含め、他の型が使える多くの場面でプロトコルを使用することができます。
 
 関数、メソッド、イニシャライザのパラメータの型、または戻り値の型として
 定数、変数、プロパティの型として
 配列、辞書、その他コンテナ内でのアイテムの型として
 */


class Dice {
    let sides: Int
    // プロパティ generator には、RandomNumberGenerator プロトコルに準拠するあらゆる型のインスタンスを設定することができる
    let generator: RandomNumberGenerator
    init(sides: Int, generator: RandomNumberGenerator) {
        self.sides = sides
        self.generator = generator
    }
    func roll() -> Int {
        return Int(generator.random() * Double(sides)) + 1
    }
}

var d6 = Dice(sides: 6, generator: LinearCongruentialGenerator())
d6.roll()


//: ## Delegation

protocol DiceGame {
    var dice: Dice { get }
    func play()
}

protocol DiceGameDelegate: AnyObject {
    func gameDidStart(_ game: DiceGame)
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int)
    func gameDidEnd(_ game: DiceGame)
}

class SnakesAndLadders: DiceGame {
    let finalSquare = 25
    let dice = Dice(sides: 6, generator: LinearCongruentialGenerator())
    var square = 0
    var board: [Int]
    init() {
        board = Array(repeating: 0, count: finalSquare + 1)
        board[03] = +08; board[06] = +11; board[09] = +09; board[10] = +02
        board[14] = -10; board[19] = -11; board[22] = -02; board[24] = -08
    }
    weak var delegate: DiceGameDelegate?
    func play() {
        square = 0
        delegate?.gameDidStart(self)
        gameLoop: while square != finalSquare {
            let diceRoll = dice.roll()
            delegate?.game(self, didStartNewTurnWithDiceRoll: diceRoll)
            switch square + diceRoll {
            case finalSquare:
                break gameLoop
            case let newSquare where newSquare > finalSquare:
                continue gameLoop
            default:
                square += diceRoll
                square += board[square]
            }
        }
        delegate?.gameDidEnd(self)
    }
}

class DiceGameTracker: DiceGameDelegate {
    var numberOfTurns = 0
    func gameDidStart(_ game: DiceGame) {
        numberOfTurns = 0
        if game is SnakesAndLadders {
            print("Started a new game of Snakes and Ladders")
        }
        print("The game is using a \(game.dice.sides)-sided dice")
    }
    func game(_ game: DiceGame, didStartNewTurnWithDiceRoll diceRoll: Int) {
        numberOfTurns += 1
        print("Rolled a \(diceRoll)")
    }
    func gameDidEnd(_ game: DiceGame) {
        print("The game lasted for \(numberOfTurns) turns")
    }
}

let tracker = DiceGameTracker()
let game = SnakesAndLadders()
game.delegate = tracker
game.play()
// Started a new game of Snakes and Ladders
// The game is using a 6-sided dice
// Rolled a 3
// Rolled a 5
// Rolled a 4
// Rolled a 5
// The game lasted for 4 turns


//: ## Adding Protocol Conformance with an Extension

protocol TextRepresentable {
    var textualDescription: String { get }
}

extension Dice: TextRepresentable {
    var textualDescription: String {
        return "A \(sides)-sided dice"
    }
}

let d12 = Dice(sides: 12, generator: LinearCongruentialGenerator())
print(d12.textualDescription)


//: ### Conditionally Conforming to a Protocol

extension Array: TextRepresentable where Element: TextRepresentable {
    var textualDescription: String {
        let itemsAsText = self.map { $0.textualDescription }
        return "[" + itemsAsText.joined(separator: ", ") + "]"
    }
}
let myDice = [d6, d12]
print(myDice.textualDescription)
// Prints "[A 6-sided dice, A 12-sided dice]"

//: Declaring Protocol Adoption with an Extension

struct Hamster {
    var name: String
    var textualDescription: String {
        return "A hamster named \(name)"
    }
}
extension Hamster: TextRepresentable {}
let simonTheHamster = Hamster(name: "Simon")

//: ## Collections of Protocol Types

let things: [TextRepresentable] = [d12, simonTheHamster]
for thing in things {
    print(thing.textualDescription)
}

//: ## Protocol Inheritance

protocol PrettyTextRepresentable: TextRepresentable {
    var prettyTextualDescription: String { get }
}

//: Class-Only Protocols

protocol SomeClassOnlyProtocol: AnyObject, SomeProtocol {
    // class-only protocol definition goes here
}

//: Protocol Composition

// 一度に複数のプロトコルに準拠するよう型に要求すること

protocol Named {
    var name: String { get }
}
protocol Aged {
    var age: Int { get }
}
struct Person2: Named, Aged {
    var name: String
    var age: Int
}

func wishHappyBirthday(to celebrator: Named & Aged) {
    print(celebrator.name, celebrator.age)
}
let birthdayPerson = Person2(name: "Malcolm", age: 21)
wishHappyBirthday(to: birthdayPerson)


//: ## Checking for Protocol Conformance
//　プロトコル準拠をチェックし、特定のプロトコルにキャストするために、Type Casting で説明されている is と as の演算子を使用できる
/*:
 - is 演算子は、インスタンスがプロトコルに準拠する場合に true を返し、そうでない場合は false を返す。
 - as? ダウンキャスト演算子は、プロトコルの型のオプショナル値を返し、インスタンスがそのプロトコルに準拠しない場合にはこの値は nil になります。
 - as! ダウンキャスト演算子は、プロトコル型へのダウンキャストを強制し、ダウンキャストが成功しない場合には実行時エラーを引き起こします。
 */

protocol HasArea {
    var area: Double { get }
}

class Circle: HasArea {
    let pi = 3.14
    var radius: Double
    var area: Double { return pi * radius * radius }
    init(radius: Double) { self.radius = radius }
}
class Country: HasArea {
    var area: Double
    init(area: Double) { self.area = area }
}
class Animal {
    var legs: Int
    init(legs: Int) { self.legs = legs }
}
let objects: [AnyObject] = [
    Circle(radius: 2.0),
    Country(area: 243_610),
    Animal(legs: 4)
]
for object in objects {
    if let objectWithArea = object as? HasArea {
        print("Area: \(objectWithArea.area)")
    } else {
        print("No area")
    }
}

//: ## Optional Protocol Requirements

@objc protocol CounterDataSource {
    @objc optional func increment(forCount count: Int) -> Int
    @objc optional var fixedIncrement: Int { get }
}

class Counter {
    var count = 0
    var dataSource: CounterDataSource?
    func increment() {
        if let amount = dataSource?.increment?(forCount: count) {
            count += amount
        } else if let amount = dataSource?.fixedIncrement {
            count += amount
        }
    }
}


//: ## Protocol Extensions
// プロトコル自体に振る舞いを追加できる
extension RandomNumberGenerator {
    func randomBool() -> Bool {
        return random() > 0.5
    }
}



//: ### Providing Default Implementations
extension PrettyTextRepresentable  {
    var prettyTextualDescription: String {
        return textualDescription
    }
}

//: ### Adding Constraints to Protocol Extensions
extension Collection where Element: Equatable {
    func allEqual() -> Bool {
        for element in self {
            if element != self.first {
                return false
            }
        }
        return true
    }
}

let equalNumbers = [100, 100, 100, 100, 100]
let differentNumbers = [100, 100, 200, 100, 200]
print(equalNumbers.allEqual())
print(differentNumbers.allEqual())
