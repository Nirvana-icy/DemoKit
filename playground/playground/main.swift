//
//  main.swift
//  playground
//
//  Created by JinglongBi on 2024/12/19.
//

import Foundation

let solution = Solution()

print(solution.twoSum(nums: [5, 3, 6, 9], target: 9))

print(solution.twoSumValue(nums: [5, 3, 6, 9], target: 9))

var nums = [5, 3, 6, 9]
print(solution.twoSumValueB(nums: &nums, target: 9))

