//
//  MyQueue.swift
//  playground
//
//  Created by JinglongBi on 2024/12/21.
//

import Foundation

class MyQueue {

    private var stackIn = [Int]()
    private var stackOut = [Int]()

    init() {
        
    }
    
    func push(_ x: Int) {
        stackIn.append(x)
    }
    
    func pop() -> Int {
        configData()
        return stackOut.popLast() ?? 0
    }
    
    func peek() -> Int {
        configData()

        return stackOut.last ?? 0
    }
    
    func empty() -> Bool {
        return stackIn.isEmpty && stackOut.isEmpty
    }

    private func configData() {
        if stackOut.isEmpty {
            while !stackIn.isEmpty {
                stackOut.append(stackIn.popLast()!)
            }
        }
    }
}
