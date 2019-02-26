//: [Previous](@previous)
//: [Next](@next)

import Foundation

//: # Access Control

// アクセスシンタックスの種類と役割
/*:
 Open access and public access enable entities to be used within any source file from their defining module, and also in a source file from another module that imports the defining module. You typically use open or public access when specifying the public interface to a framework. The difference between open and public access is described below.
 Internal access enables entities to be used within any source file from their defining module, but not in any source file outside of that module. You typically use internal access when defining an app’s or a framework’s internal structure.
 File-private access restricts the use of an entity to its own defining source file. Use file-private access to hide the implementation details of a specific piece of functionality when those details are used within an entire file.
 Private access restricts the use of an entity to the enclosing declaration, and to extensions of that declaration that are in the same file. Use private access to hide the implementation details of a specific piece of functionality when those details are used only within a single declaration.
 
 Open access applies only to classes and class members, and it differs from public access as follows:
 
 Classes with public access, or any more restrictive access level, can be subclassed only within the module where they’re defined.
 Class members with public access, or any more restrictive access level, can be overridden by subclasses only within the module where they’re defined.
 Open classes can be subclassed within the module where they’re defined, and within any module that imports the module where they’re defined.
 Open class members can be overridden by subclasses within the module where they’re defined, and within any module that imports the module where they’re defined.
 */


public class SomePublicClass {}
internal class SomeInternalClass {}
fileprivate class SomeFilePrivateClass {}
private class SomePrivateClass {}

public var somePublicVariable = 0
internal let someInternalConstant = 0
fileprivate func someFilePrivateFunction() {}
private func somePrivateFunction() {}

class SomeInternalClass {}              // implicitly internal
let someInternalConstant = 0            // implicitly internal
