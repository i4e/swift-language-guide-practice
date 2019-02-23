//: [Previous](@previous)

import Foundation

//: # Automatic Reference Counting


class Person1 {
    let name: String
    init(name: String) {
        self.name = name
        print("\(name) is being initialized")
    }
    deinit {
        print("\(name) is being deinitialized")
    }
}

var reference1: Person1?
var reference2: Person1?
var reference3: Person1?

reference1 = Person1(name: "John Appleseed") // count 1
// Prints "John Appleseed is being initialized"

reference2 = reference1  // count 2
reference3 = reference1  // count 3

reference1 = nil  // count 2
reference2 = nil  // count 1
reference3 = nil  // count 0
// Prints "John Appleseed is being deinitialized"

//: ## Strong Reference Cycles Between Class Instances

class Person {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment {
    let unit: String
    init(unit: String) { self.unit = unit }
    var tenant: Person?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john: Person?
var unit4A: Apartment?

john = Person(name: "John Appleseed")   // john: count 1
unit4A = Apartment(unit: "4A")          // unit4A: count 1

john!.apartment = unit4A    // unit4A: count 2
unit4A!.tenant = john       // john: count 2

john = nil      // john: count 1
unit4A = nil    // unit4A: count 1
// deinitialize されない
// メモリリーク


//: ## Resolving Strong Reference Cycles Between Class Instances

//: ### Weak References

class Person3 {
    let name: String
    init(name: String) { self.name = name }
    var apartment: Apartment3?
    deinit { print("\(name) is being deinitialized") }
}

class Apartment3 {
    let unit: String
    init(unit: String) { self.unit = unit }
    weak var tenant: Person3?
    deinit { print("Apartment \(unit) is being deinitialized") }
}

var john3: Person3?
var unit4A3: Apartment3?

john3 = Person3(name: "John Appleseed")
unit4A3 = Apartment3(unit: "4A")

john3!.apartment = unit4A3
unit4A3!.tenant = john3

john = nil  // "John Appleseed is being deinitialized"
// 強参照が0になったので，弱参照であった unit4A.tenant に nil が設定

unit4A = nil // "Apartment 4A is being deinitialized"

//: ### Unowned References
/*:
 一方で、弱い参照と異なり、非所有の参照には常に値があるものと想定されます。これにより、非所有の参照は常にオプショナルでない型で定義されます。
 
 参照するインスタンスが割り当て解除された後に、非所有の参照にアクセスしようとした場合、実行時エラーになります。参照が常にインスタンスを参照するときにのみ、非所有の参照を利用します。

 参照するインスタンスが割り当て解除された後に、非所有の参照にアクセスしようとした場合、Swift は確実にアプリをクラッシュさせることにも注目してください。この状況において、予期しない振る舞いになることはありません。そうなることを防ぐべきですが、アプリは常に期待どおりクラッシュします。

 */


class Customer {
    let name: String
    var card: CreditCard?
    init(name: String) {
        self.name = name
    }
    deinit { print("\(name) is being deinitialized") }
}

class CreditCard {
    let number: UInt64
    unowned let customer: Customer
    init(number: UInt64, customer: Customer) {
        self.number = number
        self.customer = customer
    }
    deinit { print("Card #\(number) is being deinitialized") }
}

var john4: Customer?
john4 = Customer(name: "John Appleseed")
john4!.card = CreditCard(number: 1234_5678_9012_3456, customer: john4!)
john4 = nil
// Prints "John Appleseed is being deinitialized"
// Prints "Card #1234567890123456 is being deinitialized"


//: ### Unowned References and Implicitly Unwrapped Optional Properties

/*:
 1. Person と Apartment の例:
    - 2 つのプロパティが共に nil になることがあり、強い参照の循環になる可能性がある状況 -> 弱参照
 
 2. Customer と CreditCard の例:
    - 一方のプロパティは nil になることがあり、他方は nil になることがない、強い参照の循環になる可能性がある状況 -> unowned
 
 3.
    - 両方のプロパティに常に値があり、初期化完了後にはプロパティが nil になることが無い状況
    -> 一方のクラスを unowned, 他方のクラスを無条件にアンラップされるオプショナルプロパティとして組み合わせることが効果的
 
 */

class Country {
    let name: String
    var capitalCity: City!
    init(name: String, capitalName: String) {
        self.name = name
        self.capitalCity = City(name: capitalName, country: self)
    }
}

class City {
    let name: String
    unowned let country: Country
    init(name: String, country: Country) {
        self.name = name
        self.country = country
    }
}

var country = Country(name: "Canada", capitalName: "Ottawa")
print("\(country.name)'s capital city is called \(country.capitalCity.name)")
// "Canada's capital city is called Ottawa" と出力


//: ## Strong Reference Cycles for Closures

class HTMLElement {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

let heading = HTMLElement(name: "h1")
let defaultText = "some default text"
heading.asHTML = {
    return "<\(heading.name)>\(heading.text ?? defaultText)</\(heading.name)>"
}
print(heading.asHTML())
// Prints "<h1>some default text</h1>"

var paragraph: HTMLElement? = HTMLElement(name: "p", text: "hello, world")
print(paragraph!.asHTML())
// Prints "<p>hello, world</p>"

//: ## Resolving Strong Reference Cycles for Closures

//: ### Defining a Capture List

lazy var someClosure: (Int, String) -> String = {
    [unowned self, weak delegate = self.delegate!] (index: Int, stringToProcess: String) -> String in
    // closure body goes here
}

lazy var someClosure: () -> String = {
    [unowned self, weak delegate = self.delegate!] in
    // closure body goes here
}

//: ### Weak and Unowned References

class HTMLElement2 {
    
    let name: String
    let text: String?
    
    lazy var asHTML: () -> String = {
        [unowned self] in
        if let text = self.text {
            return "<\(self.name)>\(text)</\(self.name)>"
        } else {
            return "<\(self.name) />"
        }
    }
    
    init(name: String, text: String? = nil) {
        self.name = name
        self.text = text
    }
    
    deinit {
        print("\(name) is being deinitialized")
    }
    
}

var paragraph2: HTMLElement2? = HTMLElement2(name: "p", text: "hello, world")
print(paragraph2!.asHTML())
// Prints "<p>hello, world</p>"

//: [Next](@next)
