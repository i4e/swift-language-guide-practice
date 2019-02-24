//: [Previous](@previous)
//: [Next](@next)

import Foundation

//: # Type Casting

//: ## Defining a Class Hierarchy for Type Casting

class MediaItem {
    var name: String
    init(name: String) {
        self.name = name
    }
}

class Movie: MediaItem {
    var director: String
    init(name: String, director: String) {
        self.director = director
        super.init(name: name)
    }
}

class Song: MediaItem {
    var artist: String
    init(name: String, artist: String) {
        self.artist = artist
        super.init(name: name)
    }
}

let library = [
    Movie(name: "Casablanca", director: "Michael Curtiz"),
    Song(name: "Blue Suede Shoes", artist: "Elvis Presley"),
    Movie(name: "Citizen Kane", director: "Orson Welles"),
    Song(name: "The One And Only", artist: "Chesney Hawkes"),
    Song(name: "Never Gonna Give You Up", artist: "Rick Astley")
]
// the type of "library" is inferred to be [MediaItem]

print(type(of: library))        // Array<MediaItem>
print(type(of: library[0]))     // Movie
print(type(of: library[1]))     // Song
print(type(of: library[2]))     // Movie


//: ## Checking Type

var movieCount = 0
var songCount = 0

for item in library {
    if item is Movie {
        movieCount += 1
    } else if item is Song {
        songCount += 1
    }
}

print("Media library contains \(movieCount) movies and \(songCount) songs")
// Prints "Media library contains 2 movies and 3 songs"


//: ## Downcasting
// サブクラスの型にキャスト

// あるクラス型の定数や変数が、実際にはサブクラスのインスタンスを参照している場合があります。このケースでは、型キャスト演算子（as? または as!）でサブクラスの型にダウンキャストすることができます。

// ダウンキャストが成功するか不確かなときは、条件形式の型キャスト演算子 (as?) を使用します。この形式の演算子は常にオプショナル値を返し、ダウンキャストできなかった場合には値は nil になります。
// ダウンキャストが常に成功することが確かなときは、強制形式の型キャスト演算子 (as!) を使用します。正しくないクラス型にダウンキャストしようとした場合には、この形式の演算子は実行時エラーを起こします。


// この例では，各アイテムの実際のクラスが事前にはわかっていないため、ループごとにダウンキャストをチェックするために、条件形式の型キャスト演算子 (as?) を使用する
for item in library {
    if let movie = item as? Movie {
        print("Movie: \(movie.name), dir. \(movie.director)")
    } else if let song = item as? Song {
        print("Song: \(song.name), by \(song.artist)")
    }
}

// item as? Movie の結果は、Movie?、つまりオプショナル Movie
// 「Movie として item にアクセスしてみる。成功する場合、オプショナル Movie の値を一時的な定数 movie に設定する。」

// Movie: Casablanca, dir. Michael Curtiz
// Song: Blue Suede Shoes, by Elvis Presley
// Movie: Citizen Kane, dir. Orson Welles
// Song: The One And Only, by Chesney Hawkes
// Song: Never Gonna Give You Up, by Rick Astley

// NOTE: キャストは実際にはインスタンスを変更することも、値を変更することもありません。インスタンスは同じままで、単にキャストされた型のインスタンスとしてみなされ、アクセスされます。


//: ## Type Casting for Any and AnyObject

/*:
 Swift には、不特定な型を扱うための特別なタイプエイリアスがあります。
 - AnyObject は、あらゆるクラス型のインスタンスを表現できます。
 - Any は、関数型を含め、あらゆるすべての型のインスタンスを表現できます。
 
 Use Any and AnyObject only when you explicitly need the behavior and capabilities they provide. It is always better to be specific about the types you expect to work with in your code.
 */

var things = [Any]()

things.append(0)
things.append(0.0)
things.append(42)
things.append(3.14159)
things.append("hello")
things.append((3.0, 5.0))
things.append(Movie(name: "Ghostbusters", director: "Ivan Reitman"))
things.append({ (name: String) -> String in "Hello, \(name)" })

for thing in things {
    switch thing {
    case 0 as Int:
        print("zero as an Int")
    case 0 as Double:
        print("zero as a Double")
    case let someInt as Int:
        print("an integer value of \(someInt)")
    case let someDouble as Double where someDouble > 0:
        print("a positive double value of \(someDouble)")
    case is Double:
        print("some other double value that I don't want to print")
    case let someString as String:
        print("a string value of \"\(someString)\"")
    case let (x, y) as (Double, Double):
        print("an (x, y) point at \(x), \(y)")
    case let movie as Movie:
        print("a movie called \(movie.name), dir. \(movie.director)")
    case let stringConverter as (String) -> String:
        print(stringConverter("Michael"))
    default:
        print("something else")
    }
}

// zero as an Int
// zero as a Double
// an integer value of 42
// a positive double value of 3.14159
// a string value of "hello"
// an (x, y) point at 3.0, 5.0
// a movie called Ghostbusters, dir. Ivan Reitman
// Hello, Michael
