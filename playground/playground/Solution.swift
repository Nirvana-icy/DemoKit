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
    
    func twoSumValueB(nums: inout [Int], target: Int) -> [Int] {
        //  [3, 6, 1, 2, 5]
        var sortedIndex = 0
        
        while sortedIndex < nums.count {
            var curIndex = sortedIndex + 1
            while curIndex > 0 && curIndex < nums.count {
                if nums[curIndex] < nums[curIndex - 1] {
                    let tmp = nums[curIndex]
                    nums[curIndex] = nums[curIndex - 1]
                    nums[curIndex - 1] = tmp
                }
                curIndex -= 1
            }
            sortedIndex += 1
        }
        
        for slowIndexValue in nums {
            for fastInexValue in nums {
                if slowIndexValue + fastInexValue == target {
                    return [slowIndexValue, fastInexValue]
                }
            }
        }
        return []
    }
}
