import Foundation

class Dog: NSObject {
    @objc 
    func makeNoiseObjC() {}

    @objc dynamic
    func makeNoiseDynamic() {}
}