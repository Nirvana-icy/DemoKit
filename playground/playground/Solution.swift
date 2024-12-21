//
//  Solution.swift
//  playground
//
//  Created by JinglongBi on 2024/12/19.
//

import Foundation

class Solution {
    func twoSum(nums: [Int], target: Int) -> [Int] {
        var valueIndexMap = [Int: Int]()
        var wantedIndexArray = [Int]()
        
        for (index, value) in nums.enumerated() {
            if let targetIndex = valueIndexMap[target - value] {
                wantedIndexArray = [targetIndex, index]
            } else {
                valueIndexMap[value] = index
            }
        }

        return wantedIndexArray.compactMap { value in
            nums[value]
        }
    }
    
    func twoSumValue(nums: [Int], target: Int) -> [Int] {
        let sortedNums = nums.sorted(by: <)
        
        for slowIndexValue in sortedNums {
            for fastIndexValue in sortedNums {
                if slowIndexValue + fastIndexValue == target {
                    return [slowIndexValue, fastIndexValue]
                }
            }
        }
        
        return []
    }
}
