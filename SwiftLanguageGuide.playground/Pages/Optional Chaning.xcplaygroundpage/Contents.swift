//: [Previous](@previous)
//: [Next](@next)

import Foundation

//: # Optional Chaining

//: ## Optional Chaining as an Alternative to Forced Unwrapping

class Person {
    var residence: Residence?
}

class Residence {
    var numberOfRooms = 1
}

let john = Person()

// 強制アンラップはオプショナル値がnilのときエラー
// residence が nil なので実行時エラー
//let roomCount = john.residence!.numberOfRooms // error

// residence が nil なので nil を返す
john.residence?.numberOfRooms // nil

john.residence = Residence()

john.residence?.numberOfRooms // 1

// オプショナルチェーン呼び出しの結果は常にオプショナル
// 値がある場合
type(of: john.residence?.numberOfRooms)  // Optional<Int>
// 値がnilの場合
let paul = Person()
type(of: paul.residence?.numberOfRooms)  // Optional<Int>


//: ## Defining Model Classes for Optional Chaining

class Person2 {
    var residence: Residence2?
}

class Residence2 {
    var rooms = [Room]()
    var numberOfRooms: Int {
        return rooms.count
    }
    subscript(i: Int) -> Room {
        get {
            return rooms[i]
        }
        set {
            rooms[i] = newValue
        }
    }
    func printNumberOfRooms() {
        print(numberOfRooms)
    }
    var address: Address?
}

class Room {
    let name: String
    init(name: String) { self.name = name }
}

class Address {
    var buildingName: String?
    var buildingNumber: String?
    var street: String?
    func buildingIdentifier() -> String? {
        if let buildingNumber = buildingNumber, let street = street {
            return "\(buildingNumber) \(street)"
        } else if buildingName != nil {
            return buildingName
        } else {
            return nil
        }
    }
}

//: ## Accessing Properties Through Optional Chaining

let ringo = Person2()
ringo.residence?.numberOfRooms // nil

let someAddress = Address()
someAddress.buildingNumber = "29"
someAddress.street = "Acacia Road"
ringo.residence?.address = someAddress // 失敗
ringo.residence?.address // nil なので，上のコードが失敗していることがわかる

func createAddress() -> Address {
    print("Function was called")
    
    let someAddress = Address()
    someAddress.buildingNumber = "29"
    someAddress.street = "Acacia Road"
    
    return someAddress
    
}
ringo.residence?.address = createAddress() // 何も出力されていないため、関数 createAddress() が呼びだされていないとわかる


//: ## Calling Methods Through Optional Chaining

// オプショナル値のメソッドを呼び出すため、およびメソッド呼び出しが成功するかを確認するためにオプショナルチェーンを利用できる

// printNumberOfRooms() メソッドを呼び出せるかチェック
// Void を返すメソッドを optional chaining で呼び出した場合は Void? を返す
if ringo.residence?.printNumberOfRooms() != nil {
    print("success")
} else {
    print("failure")
}

// プロパティを設定できるかチェック
// optional chaining によるプロパティの設定は Void? を返す
if (ringo.residence?.address = someAddress) != nil {
    print("success")
} else {
    print("failure")
}


//: ## Accessing Subscripts Through Optional Chaining

ringo.residence?[0].name
ringo.residence?[0] = Room(name: "Bathroom")    // 失敗

let ringosHouse = Residence2()
ringosHouse.rooms.append(Room(name: "Living Room"))
ringosHouse.rooms.append(Room(name: "Kitchen"))
ringo.residence = ringosHouse

ringo.residence?[0].name    // Living Room


//: ## Accessing Subscripts of Optional Type

var testScores = ["Dave": [86, 82, 84], "Bev": [79, 94, 81]]
testScores["Dave"]?[0] = 91
testScores["Bev"]?[0] += 1
testScores["Brian"]?[0] = 72    // 失敗
// "Dave" 配列は [91, 82, 84] で、"Bev" 配列は [80, 94, 81]


//: ## Linking Multiple Levels of Chaining

// オプショナルチェーンで Int 値を取り出そうとした場合、使用されたチェーンのレベルにかかわらず、常に Int? が返されます。
// 同様に、オプショナルチェーンで Int? 値を取り出そうとした場合、使用されたチェーンのレベルにかかわらず、常に Int? が返されます。

// ringo.residence は有効
// ringo.residence.address は nil
ringo.residence?.address?.street    // nil

let ringoAddress = Address()
ringoAddress.buildingName = "The Larches"
ringoAddress.street = "Laurel Street"
ringo.residence?.address = ringoAddress

ringo.residence?.address?.street    // "Laurel Street"


//: ## Chaining on Methods with Optional Return Values


ringo.residence?.address?.buildingIdentifier()
type(of: ringo.residence?.address?.buildingIdentifier()) // String?

ringo.residence?.address?.buildingIdentifier()?.hasPrefix("The")
type(of: ringo.residence?.address?.buildingIdentifier()?.hasPrefix("The")) // Bool?
// この例では、チェーンするオプショナル値が buildingIdentifier() メソッド自体ではなく、buildingIdentifier() メソッドの戻り値であるため、丸括弧の後にオプショナルチェーンのクエスチョンマークを置いています。



//: # Basics


let possibleNumber = "123"
let convertedNumber = Int(possibleNumber)
var serverResponseCode: Int? = 404
serverResponseCode = nil
var surveyAnswer: String? // nil

// If Statements and Forced Unwrapping
if convertedNumber != nil {
    print(convertedNumber!)
}

// Optional Binding
if let convertedNumber = convertedNumber {
    print(convertedNumber)
}

// 複数のオプショナルバインディング と 条件
if let firstNumber = Int("4"), let secondNumber = Int("5"), firstNumber < secondNumber && secondNumber < 100 {
    print("\(firstNumber) < \(secondNumber) < 100")
}


if let firstNumber = Int("4") {
    if let secondNumber = Int("42") {
        if firstNumber < secondNumber && secondNumber < 100 {
            print("\(firstNumber) < \(secondNumber) < 100")
        }
    }
}

// 無条件アンラップ
// オプショナル型
var a: String? = "hoge"
let forcedString: String = a!

// 有値オプショナル型 (無条件アンラップ)
var b: String! = "hoge"
let implicitString: String = b

// 以下の2例は同じ結果
a = nil
//let hoge: String = a! // 実行時エラー
b = nil
//let fuga: String = b  // 実行時エラー

